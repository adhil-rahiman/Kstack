# 🧩 Kotlin Compose Multiplatform Starter Template

A production-ready, elegant Compose Multiplatform starter project targeting Android, iOS, Web, Desktop, Server. 
Built with:

- ✅ Jetpack Compose (Android, iOS, Desktop)
- 🧱 Modular Clean Architecture
- ⚙️ Ktor + DI + Resource Loader pre-wired
- 🎨 Ready-to-use design system

## 🚀 Quick Start

1. Click [**Use this template**](../../generate)
2. Clone the generated repo
3. Open in Android Studio (Canary recommended)
4. Run the app on Android or iOS

## 🧪 Tech Stack

- Kotlin Multiplatform (KMP)
- Jetpack Compose Multiplatform
- Ktor Client
- Dependency Injection (Koin or Hilt)
- Material 3 UI (with custom theme)

## 🛠️ Setup

No extra steps required — it's ready out of the box.

## 📦 Folder Structure



* `/composeApp` is for code that will be shared across your Compose Multiplatform applications.
  It contains several subfolders:
  - `commonMain` is for code that’s common for all targets.
  - Other folders are for Kotlin code that will be compiled for only the platform indicated in the folder name.
    For example, if you want to use Apple’s CoreCrypto for the iOS part of your Kotlin app,
    `iosMain` would be the right folder for such calls.

* `/iosApp` contains iOS applications. Even if you’re sharing your UI with Compose Multiplatform, 
  you need this entry point for your iOS app. This is also where you should add SwiftUI code for your project.

* `/server` is for the Ktor server application.

* `/shared` is for the code that will be shared between all targets in the project.
  The most important subfolder is `commonMain`. If preferred, you can add code to the platform-specific folders here too.


Learn more about [Kotlin Multiplatform](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html),
[Compose Multiplatform](https://github.com/JetBrains/compose-multiplatform/#compose-multiplatform),
[Kotlin/Wasm](https://kotl.in/wasm/)…

We would appreciate your feedback on Compose/Web and Kotlin/Wasm in the public Slack channel [#compose-web](https://slack-chats.kotlinlang.org/c/compose-web).
If you face any issues, please report them on [YouTrack](https://youtrack.jetbrains.com/newIssue?project=CMP).

You can open the web application by running the `:composeApp:wasmJsBrowserDevelopmentRun` Gradle task.