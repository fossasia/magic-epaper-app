# Project Overview

**Magic E-Paper App** is a Flutter cross-platform application for designing and generating electronic paper labels, price tags, and customizable display templates for e-paper devices. It supports adding text, images, clipart, barcodes, QR codes, and other elements to create rich layouts.

## Tech Stack

- **Framework**: Flutter (stable channel)
- **Language**: Dart
- **State Management**: Provider pattern
- **Dependency Injection**: GetIt (service locator pattern)
- **Supported Platforms**: Android, iOS, Linux, macOS, Windows, Web

## Repository Structure

```text
magic-e-paper-app/
├── android/          # Android-specific platform code
├── ios/              # iOS-specific platform code
├── linux/            # Linux-specific platform code
├── macos/            # macOS-specific platform code
├── windows/          # Windows-specific platform code
├── web/              # Web-specific platform code
├── lib/              # Code shared by all platforms
│   ├── card_templates/   # Predefined card and label templates
│   ├── constants/        # App-wide constants
│   ├── image_library/    # Image and asset management
│   ├── l10n/             # Localization (i18n) files
│   ├── ndef_screen/      # NFC/NDEF related screens and logic
│   ├── pro_image_editor/ # Image editing and canvas features
│   ├── provider/         # State management (Provider pattern)
│   ├── util/             # Utilities and helper functions
│   ├── view/             # UI screens and widgets
│   ├── waveshare/        # Waveshare e-paper integrations
│   └── main.dart         # App entry point
├── test/             # Unit and widget tests
├── test_integration/ # Integration tests
├── assets/           # Images, icons, fonts, and other assets
├── scripts/          # Build and deployment scripts
├── .github/
│   └── workflows/    # CI/CD workflows
├── pubspec.yaml      # Dependencies and project configuration
└── analysis_options.yaml # Dart analyzer configuration
```

## Coding Standards

- Adhere to the coding style described in <https://dart.dev/effective-dart/style>.
- Adhere to the SOLID design principles described in <https://simple.wikipedia.org/wiki/SOLID_(object-oriented_design)>.
- Adhere to Object-Oriented Design best practices described in <http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod>.
- Keep in mind the architecture recommendations described in <https://docs.flutter.dev/app-architecture/guide>.

## Commit Style

- Adhere to the commit style described in the file `commitstyle.md` in
  the `docs` folder of this project.

## UI guidelines

- The UI of the app must be consistent
- The UI of the app should adhere to the best practices for adaptive design described
  in <https://docs.flutter.dev/ui/adaptive-responsive/best-practices>.
