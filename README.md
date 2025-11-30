# Re:Mark

> **macOS AI Study Companion**
> Randomly selects a local Markdown note and generates a summary & quiz using Gemini AI.

![Swift](https://img.shields.io/badge/Swift-6.2.1-orange?style=flat-square&logo=swift)
![Platform](https://img.shields.io/badge/Platform-macOS-lightgrey?style=flat-square&logo=apple)
![Gemini](https://img.shields.io/badge/Model-Gemini_Flash_2.5-blue?style=flat-square&logo=google)

## Features

- **Random Pick**: Recursively scans a target directory to select a random `.md` file.
- **AI Summary**: Summarizes content using **Google Gemini Flash 2.5**.
- **Quiz Generation**: Creates an active recall quiz based on the note.
- **Bilingual Support**: Toggle output between **English** and **Korean**.
- **Markdown Rendering**: Native rendering for code blocks and headers using `MarkdownUI`.

## Tech Stack

- **Language**: Swift 6.2.1
- **Framework**: SwiftUI (macOS)
- **AI Model**: Google Gemini Flash 2.5
- **Dependencies**: `google-generative-ai-swift`, `MarkdownUI`

## Getting Started

### Prerequisites
- macOS Sonoma 14.0+
- Xcode 16+
- **Google Gemini API Key** ([Get API Key](https://aistudio.google.com/))

### Installation

1. **Clone the repository**
   ```bash
   git clone [https://github.com/YOUR_USERNAME/Remark.git](https://github.com/YOUR_USERNAME/Remark.git)
   ```
2. **Configure API Key**: Open `RemarkView.swift`, Enter your API Key in the model initialization:

```Swift

let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: "YOUR_API_KEY")
```
3. Run: Open Remark.xcodeproj in Xcode and press Cmd + R.

### Usage
1. Click Select Folder to choose your notes directory.
2. Select Language (English / Korean).
3. Click Random Review to generate a summary.

### License
- MIT License