//
//  ContentView.swift
//  Re:Mark
//
//  Created by 김진명 on 11/30/25.
//

import SwiftUI
import GoogleGenerativeAI
import MarkdownUI
internal import Combine

enum TargetLanguage: String, CaseIterable, Identifiable {
    case korean = "한국어 🇰🇷"
    case english = "English 🇺🇸"
        
    var id: String { self.rawValue }
}

class RemarkViewModel: ObservableObject {
    @Published var summaryText: String = "Select a folder to start reviewing."
    @Published var isLoading: Bool = false
    @Published var selectedPath: String = ""
    @Published var targetLanguage: TargetLanguage = .korean
    
    // INSERT YOUR GEMINI API KEY
    let model = GenerativeModel(name: "gemini-2.5-flash", apiKey: "YOUR_API_KEY")
    
    init() {
        self.selectedPath = UserDefaults.standard.string(forKey: "savedStudyPath") ?? ""
    }
    
    func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Select Folder"
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                let path = url.path
                self.selectedPath = path
                UserDefaults.standard.set(path, forKey: "savedStudyPath")
                self.summaryText = "Folder selected! Ready to review."
            }
        }
    }
    
    func reviewRandomNote() {
        guard !selectedPath.isEmpty else {
            self.summaryText = "Please select a folder containing .md files first."
            return
        }
        
        self.isLoading = true
        self.summaryText = (targetLanguage == .korean) ? "Gemini가 읽는 중..." : "Gemini is reading..."
        
        Task {
            guard let randomFileContent = getRandomFileContent() else {
                DispatchQueue.main.async {
                    self.summaryText = "No .md files found in this folder."
                    self.isLoading = false
                }
                return
            }
            
            let prompt: String
            if targetLanguage == .korean {
                prompt = """
                [지시사항]
                아래 마크다운 파일의 내용을 '한국어'로 요약하고 복습 퀴즈를 만드세요.
                
                [제약사항]
                1. "다음은 요약입니다" 같은 서론이나 인사말을 절대로 하지 마세요.
                2. 바로 요약 제목(Heading)부터 출력을 시작하세요.
                3. HTML 태그(<details> 등)는 사용하지 마세요.
                4. 퀴즈 정답은 맨 마지막에 '정답: ||내용||' 형식으로 적어주세요.
                
                [학습 내용]
                \(randomFileContent)
                """
            } else {
                prompt = """
                [Instructions]
                Summarize the markdown content in 'English' and create a quiz.
                
                [Constraints]
                1. Do NOT use introductory phrases like "Here is the summary".
                2. Start directly with the Summary Heading.
                3. Do NOT use HTML tags.
                4. Provide the answer at the very bottom in 'Answer: ||content||' format.
                
                [Content]
                \(randomFileContent)
                """
            }
            
            do {
                let response = try await model.generateContent(prompt)
                
                DispatchQueue.main.async {
                    self.summaryText = response.text ?? "No Response from Gemini."
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.summaryText = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func getRandomFileContent() -> String? {
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: selectedPath)
        
        guard let enumerator = fileManager.enumerator(at: url, includingPropertiesForKeys: nil) else { return nil }
        
        var mdFiles: [URL] = []
        for case let fileURL as URL in enumerator {
            if fileURL.pathExtension == "md" {
                mdFiles.append(fileURL)
            }
        }
        
        guard let picked = mdFiles.randomElement() else { return nil }
        
        do {
            let content = try String(contentsOf: picked, encoding: .utf8)
            return "File: \(picked.lastPathComponent)\n\n\(content)"
        } catch {
            return nil
        }
    }
}

struct RemarkView: View {
    @StateObject var studyManager = RemarkViewModel()
    
    var body: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // Header
                HStack {
                    Button(action: { studyManager.selectFolder() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "folder.fill")
                                .foregroundColor(.secondary)
                            Text(studyManager.selectedPath.isEmpty ? "Select Folder" : "Change Folder")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.regularMaterial)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    HStack(spacing: 8) {
                        Text("Output Language:")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        Picker("", selection: $studyManager.targetLanguage) {
                            ForEach(TargetLanguage.allCases) { lang in
                                Text(lang.rawValue).tag(lang)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        .frame(width: 220)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                
                Divider().opacity(0.3)
                
                // Main content box
                ZStack {
                    if studyManager.isLoading {
                        VStack(spacing: 15) {
                            ProgressView()
                                .scaleEffect(1.0)
                            Text("Gemini is thinking...")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading) {
                                Markdown(studyManager.summaryText)
                                    .markdownTheme(.docC)
                                    .textSelection(.enabled)
                                    .padding(35)
                            }
                        }
                    }
                }
                .background(Color(nsColor: .textBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .padding(.horizontal, 20)
                .padding(.bottom, 0)
                
                // Action Bar at the Bottom
                HStack {
                    if !studyManager.selectedPath.isEmpty {
                        Image(systemName: "doc.text")
                            .foregroundColor(.secondary)
                        Text(studyManager.selectedPath)
                            .font(.caption)
                            .foregroundColor(Color(nsColor: .secondaryLabelColor))
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        studyManager.reviewRandomNote()
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Random Review")
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                    .disabled(studyManager.selectedPath.isEmpty)
                    .opacity(studyManager.selectedPath.isEmpty ? 0.6 : 1.0)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .frame(minWidth: 700, minHeight: 800)
    }
}

#Preview {
    RemarkView()
}
