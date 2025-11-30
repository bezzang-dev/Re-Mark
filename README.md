# 🎲 Re:Mark

> **Your Randomized AI Study Companion for macOS.**
> *Rediscover your forgotten notes with the power of Gemini AI.*

![Swift](https://img.shields.io/badge/Swift-6.2.1-orange?style=flat-square&logo=swift)
![Platform](https://img.shields.io/badge/Platform-macOS-lightgrey?style=flat-square&logo=apple)
![Gemini API](https://img.shields.io/badge/AI-Gemini_2.5_Flash-blue?style=flat-square&logo=google)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

<br>

## 📖 Introduction

We all have a folder full of Markdown study notes that we wrote once and never looked at again. **Re:Mark** solves the problem of "What should I review today?"

By **randomly selecting** a note from your local directory and generating an **instant AI summary & quiz**, Re:Mark transforms your static notes into an active learning experience.

Don't just store your knowledge—**Re:Mark** it.

<br>

## ✨ Key Features

### 🎲 Random Pick Engine
- Eliminates decision paralysis.
- Recursively scans your target directory to find hidden `.md` gems.
- Promotes **Spaced Repetition** by surfacing old notes you haven't seen in a while.

### 🧠 AI-Powered Analysis
- Powered by **Google Gemini 1.5 Flash**.
- Instantly condenses long documents into key concepts.
- Generates **Active Recall Quizzes** to test your understanding immediately.

### 🎨 Modern macOS Experience
- Built with **SwiftUI** and **Glassmorphism (Material)** design.
- Supports **Light & Dark Mode** seamlessly.
- Renders Markdown beautifully (Code blocks, Blockquotes, Headers) using `MarkdownUI`.

### 🌐 Bilingual Support
- **English 🇺🇸 / Korean 🇰🇷** toggle.
- Switch the AI's output language instantly with a single click.

<br>

## 🛠 Tech Stack

- **Language**: Swift
- **Framework**: SwiftUI (macOS)
- **AI Model**: Google Gemini 1.5 Flash
- **Dependencies**:
  - [`google-generative-ai-swift`](https://github.com/google/generative-ai-swift)
  - [`MarkdownUI`](https://github.com/gonzalezreal/MarkdownUI)

<br>

## 🚀 Getting Started

Since this app uses the Gemini API, you will need your own API Key to run it.

### Prerequisites
- macOS Sonoma 14.0+ (Recommended)
- Xcode 15.0+
- A Google Gemini API Key ([Get it here for free](https://aistudio.google.com/))

### Installation

1. **Clone the repository**
   ```bash
   git clone [https://github.com/YOUR_USERNAME/Remark.git](https://github.com/YOUR_USERNAME/Remark.git)
````

2.  **Open in Xcode**

      - Double-click `Remark.xcodeproj` to open the project.

3.  **Configure API Key**

      - Open the `StudyManager.swift` file.
      - Locate the `model` initialization and paste your API Key.

    <!-- end list -->

    ```swift
    // StudyManager.swift
    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: "PASTE_YOUR_API_KEY_HERE")
    ```

    > **⚠️ Important:** Do not commit your API Key to a public repository\!

4.  **Build & Run**

      - Press `Cmd + R` to build and launch the app on your Mac.

<br>

## 🎮 How to Use

1.  **Select Folder**: Click the folder button in the top left and choose the directory where your Markdown notes are stored.
2.  **Choose Language**: Toggle between **Korean** and **English** for the summary output.
3.  **Random Review**: Click the button at the bottom.
4.  **Study**: Read the AI-generated summary and try to answer the quiz at the end\!

<br>

## 📸 Screenshots

| Home Screen | AI Summary & Quiz |
|:---:|:---:|
| *(Add your screenshot here)* | *(Add your screenshot here)* |

<br>

## 🤝 Contributing

Contributions are welcome\! If you have ideas for new features (e.g., Anki integration, History view), feel free to fork the repository and submit a Pull Request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/NewFeature`)
3.  Commit your Changes (`git commit -m 'Add some NewFeature'`)
4.  Push to the Branch (`git push origin feature/NewFeature`)
5.  Open a Pull Request

<br>

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
