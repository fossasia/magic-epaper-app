# AGENTS.md

Guidance for AI coding agents (Claude Code, Cursor, Aider, Copilot, Codex, and others) working in this repository. `AGENTS.md` is a vendor-neutral convention; keep instructions here rather than in tool-specific files.

## Project Overview

**Magic E-Paper App** is a Flutter cross-platform application for designing and generating electronic paper labels, price tags, and customizable display templates for e-paper devices. It supports adding text, images, clipart, barcodes, QR codes, and other elements to create rich layouts, and transferring them to NFC ePaper badges.

## Tech Stack

- **Framework**: Flutter (stable channel, pinned to `3.41.9` in `pubspec.yaml`)
- **Language**: Dart (`>=3.3.4 <4.0.0`)
- **State Management**: Provider pattern (`provider` package)
- **Dependency Injection**: GetIt (service locator pattern)
- **NFC**: `flutter_nfc_kit`, `ndef`
- **Image editing**: in-house `native_canvas` editor, `image`, `image_cropper`, `image_picker`
- **Supported Platforms**: Android, iOS, Linux, macOS, Windows, Web

## Repository Structure

```text
magic-epaper-app/
├── android/          # Android-specific platform code
├── ios/              # iOS-specific platform code
├── linux/            # Linux-specific platform code
├── macos/            # macOS-specific platform code
├── windows/          # Windows-specific platform code
├── web/              # Web-specific platform code
├── lib/              # Code shared by all platforms
│   ├── card_templates/   # Predefined card and label templates
│   ├── constants/        # App-wide constants
│   ├── image_library/    # Saved-image storage, provider, services, dialogs
│   ├── l10n/             # Localization (ARB + generated AppLocalizations)
│   ├── ndef_screen/      # NFC/NDEF screens, controller, services, models
│   ├── native_canvas/    # In-house canvas/image editor (text, image, barcode, draw)
│   ├── provider/         # ChangeNotifier providers + GetIt locator
│   ├── util/             # EPD drivers, image processing, protocol, helpers
│   ├── view/             # Top-level screens and shared widgets
│   ├── waveshare/        # Waveshare NFC ePaper services
│   └── main.dart         # App entry point
├── test/             # Unit and widget tests
├── test_integration/ # Integration tests
├── assets/           # Images, icons, fonts, canvas backgrounds
├── scripts/          # Build and deployment scripts
├── docs/             # Project documentation (incl. commitStyle.md)
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
- Run `flutter analyze` before proposing changes; respect rules in `analysis_options.yaml`.

## Localization

- User-facing strings must be added to the ARB files under `lib/l10n/` (start with `app_en.arb`), not hard-coded.
- Access strings via `AppLocalizations` (registered through GetIt in `main.dart`).

## Commit Style

- Adhere to the commit style described in `docs/commitStyle.md`.
- One commit per pull request; squash before merge.

## Privacy

- The app's privacy policy lives at `docs/privacyPolicy.md`. If a change introduces new data collection, logging, third-party SDKs, or alters how personal information is handled, update `docs/privacyPolicy.md` in the same PR and flag it in the description.

## UI Guidelines

- The UI of the app must be consistent across screens and platforms.
- The UI should adhere to the best practices for adaptive design described in <https://docs.flutter.dev/ui/adaptive-responsive/best-practices>.
- For frontend changes, attach screenshots in the PR description.

## Notes for Agents

- Prefer editing existing files over creating new ones.
- Do not introduce new dependencies without a clear justification; check `pubspec.yaml` first.
- When touching ePaper transfer or NFC code paths (`lib/util/epd/`, `lib/util/protocol.dart`, `lib/ndef_screen/`, `lib/waveshare/`), preserve the existing device/driver abstractions (`DisplayDevice`, `Epd`, `Driver`, `Waveform`).
- Image processing changes should go through `lib/util/image_processing/` and keep the `processingMethods` contract on `DisplayDevice` intact.
