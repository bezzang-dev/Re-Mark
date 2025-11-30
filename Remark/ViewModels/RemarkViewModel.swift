//
//  RemarkViewModel.swift
//  Remark
//
//  Created by 김진명 on 11/30/25.
//

import Foundation
import AppKit
internal import Combine
import GoogleGenerativeAI


@MainActor
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
            guard let note = getRandomNote() else {
                self.summaryText = "No .md files found in this folder."
                self.isLoading = false
                return
            }
            
            let prompt = createPrompt(for: note)
            
            do {
                let response = try await model.generateContent(prompt)
                
                self.summaryText = response.text ?? "No Response from Gemini."
                self.isLoading = false
            
            } catch {
                    self.summaryText = "Error: \(error.localizedDescription)"
                    self.isLoading = false
            }
        }
    }
    
    private func createPrompt(for note: NoteModel) -> String {
        let constraints = """
        [Constraints]
        1. Do NOT use introductory phrases.
        2. Start directly with the Summary Heading.
        3. Do NOT use HTML tags.
        4. Provide the answer at the very bottom in 'Answer: ||content||' format.
        """
        
        if targetLanguage == .korean {
            return """
            [지시사항]
            아래 내용을 '한국어'로 요약하고 퀴즈를 만드세요.
            \(constraints)
            
            [파일명: \(note.fileName)]
            [내용]
            \(note.content)
            """
        } else {
            return """
            [Instructions]
            Summarize content in 'English' and create a quiz.
            \(constraints)
            
            [Filename: \(note.fileName)]
            [Content]
            \(note.content)
            """
        }
    }
    
    private func getRandomNote() -> NoteModel? {
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
            return NoteModel(fileName: picked.lastPathComponent, content: content, fileURL: picked)
        } catch {
            return nil
        }
    }
}
