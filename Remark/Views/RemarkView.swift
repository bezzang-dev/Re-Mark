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
