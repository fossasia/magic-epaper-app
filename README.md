<img height="200px" src="./assets/icons/app_icon_desktop.png" align="right" />

# Magic ePaper

[![Build](https://img.shields.io/github/actions/workflow/status/fossasia/magic-epaper-app/push.yml?branch=main&label=build&logo=github)](https://github.com/fossasia/magic-epaper-app/actions/workflows/push.yml)
[![License](https://img.shields.io/github/license/fossasia/magic-epaper-app)](LICENSE.md)
[![Issues](https://img.shields.io/github/issues/fossasia/magic-epaper-app)](https://github.com/fossasia/magic-epaper-app/issues)
[![Last commit](https://img.shields.io/github/last-commit/fossasia/magic-epaper-app)](https://github.com/fossasia/magic-epaper-app/commits/main)
[![Contributors](https://img.shields.io/github/contributors/fossasia/magic-epaper-app)](https://github.com/fossasia/magic-epaper-app/graphs/contributors)
[![Translation status](https://hosted.weblate.org/widget/fossasia/magic-epaper-app/svg-badge.svg)](https://hosted.weblate.org/projects/fossasia/magic-epaper-app/)

Magic ePaper is an open-source Flutter app that lets you design content on your phone and transfer it to a battery-free NFC ePaper badge wirelessly. No cables or power needed on the badge. Import and dither photos for ePaper, draw and add text, generate QR codes and barcodes, or start from a ready-made card template, then tap your phone to the badge to write the image.

## Table of Contents

- [Download](#download)
- [Get a badge](#get-a-badge)
- [Features](#features)
- [Supported Displays](#supported-displays)
- [Roadmap](#roadmap)
- [Usage](#usage)
- [Permissions](#permissions)
- [Screenshots](#screenshots)
- [Development](#development)
- [Contributing](#contributing)
- [Branch Policy](#branch-policy)
- [Translations](#translations)
- [License](#license)

## Download

The app is currently in **beta testing** and runs on **Android**. Desktop support (Windows, macOS and Linux) is under active development.

* Download the latest build from the [app branch](https://github.com/fossasia/magic-epaper-app/tree/app), or build it yourself (see [Development](#development)).
* You need an **Android device with NFC** and a supported **NFC ePaper badge** (see [Supported Displays](#supported-displays)). Most design tools work without a badge; a badge is only needed to transfer an image.
* Found a bug? Please open an issue on the [issue tracker](https://github.com/fossasia/magic-epaper-app/issues) and include your phone model and badge.

## Get a badge

The Magic ePaper badge is still a **prototype** and is not on general sale yet. Ordering is planned to open on [fossasia.com](https://fossasia.com) in the future, and the hardware designs and prototypes are shared in the FOSSASIA repositories in the meantime. Any of the [supported NFC ePaper badges](#supported-displays) below already works with the app today.

## Features

* **Image editor**: import a photo, rotate/flip, adjust brightness and contrast, and dither for ePaper (Floyd-Steinberg, Atkinson, Stucki, Sierra, Burkes, Halftone, Threshold).
* **Canvas editor**: draw freehand, add text (fonts, size, colour), images and shapes, and generate QR/barcodes (QR, Data Matrix, Aztec, PDF417, Code 128/93/39, Codabar, EAN-13/8, ITF, UPC-A) with a live preview.
* **Card templates**: Employee ID, Shop Price Tag, Entry Pass, Event Badge, Calendar, QR Tag, Weather Snapshot and Contact/Business card. Generate many at once from a CSV.
* **NFC**: transfer designs to the badge, and read/write NDEF tags (text, URLs, vCards, app-launch records).
* **Command console**: send raw hex/APDU commands to a tag for debugging.
* **Image Library**: save processed designs for quick re-transfer and re-editing.
* **Arduino export** and a multi-language UI translated on Weblate.

## Supported Displays

| Display | Colors | Model |
| --- | --- | --- |
| Waveshare 2.13" NFC | tri-color | 17745 |
| Waveshare 2.7" NFC | tri-color | 18136 |
| Waveshare 2.9" NFC | tri-color | 17746 |
| Waveshare 2.9" B NFC | tri-color | 13339 |
| Goodisplay 2.9" 4-Color | Black / White / Red / Yellow | GDEY029F51 |
| Magic ePaper 3.1" | Black / White | GDEQ031T10 |
| Magic ePaper 3.7" | Black / White | GDEY037T03 |
| Magic ePaper 3.7" | Black / White / Red | GDEY037Z03 |
| Waveshare 4.2" NFC | tri-color | 17341 |
| Waveshare 7.5" NFC | tri-color | 17675 |
| Waveshare 7.5" HD NFC | tri-color | 18082 |

## Roadmap

- [x] Image editor with ePaper dithering, canvas editor and card templates
- [x] NFC transfer to badges and NDEF read/write
- [x] Bulk card generation from CSV and a reusable Image Library
- [ ] Desktop support (Windows, macOS and Linux)
- [ ] Support for more NFC ePaper badges

## Usage

1. Pick the display that matches your badge on the home screen.
2. Create your design: import and dither a photo, draw and add text/barcodes on the canvas, or fill in a card template.
3. Tap **Transfer** and hold the back of your phone against the badge to write the image over NFC.

Read and write NDEF tags (text, URLs, vCards) from the side menu, and use the Command Console to send raw hex/APDU commands to a tag.

## Permissions

| Permission | Purpose |
| --- | --- |
| NFC | Read from and write images and NDEF data to the ePaper badge. |
| Internet | Weather Snapshot lookups and other network operations. |
| Photos and media | Import pictures from the device to design and dither for the badge. |

## Screenshots

### Create, dither and transfer

<table>
  <tr>
    <td><img src="./assets/docs/screenshots/adjust.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/image-editor.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/custom-display.jpeg" width="250"/></td>
  </tr>
  <tr>
    <td><img src="./assets/docs/screenshots/transfer.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/badge.jpeg" width="250"/></td>
  </tr>
</table>

### Canvas editor

<table>
  <tr>
    <td><img src="./assets/docs/screenshots/canvas.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/text-editor.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/barcode.jpeg" width="250"/></td>
  </tr>
</table>

### Card templates

<table>
  <tr>
    <td><img src="./assets/docs/screenshots/templates.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/employee-id.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/restaurant-menu.jpeg" width="250"/></td>
  </tr>
  <tr>
    <td><img src="./assets/docs/screenshots/weather.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/calendar.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/bulk-import.jpeg" width="250"/></td>
  </tr>
</table>

### NFC, library and more

<table>
  <tr>
    <td><img src="./assets/docs/screenshots/displays.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/read-nfc.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/write-nfc.jpeg" width="250"/></td>
  </tr>
  <tr>
    <td><img src="./assets/docs/screenshots/command-console.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/library.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/save-image.jpeg" width="250"/></td>
  </tr>
  <tr>
    <td><img src="./assets/docs/screenshots/menu.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/about.jpeg" width="250"/></td>
    <td><img src="./assets/docs/screenshots/faq.jpeg" width="250"/></td>
  </tr>
</table>

## Development

Magic ePaper currently runs on **Android**. Desktop support (Windows, macOS and Linux) is under active development.

The app is built with **Flutter** and a small **Rust** core that handles the image dithering. The Rust code lives in `rust/` and is bridged to Dart with [`flutter_rust_bridge`](https://cjycode.com/flutter_rust_bridge/); the native library is compiled automatically as part of the normal Flutter build.

### Prerequisites

* **Flutter SDK**: install from the [Flutter website](https://docs.flutter.dev/get-started/install).
* **Dart SDK**: bundled with Flutter (`dart --version` to verify).
* **Rust toolchain**: install via [rustup](https://rustup.rs/); required to build the native image-processing library.
* **Git**: to clone the repository.
* **Android Studio or VS Code** with the Flutter/Dart plugins.
* An **Android device with NFC** (physical device required for NFC features) or an emulator for UI work.

### Running the project locally

1. **Clone the repository**

   ```bash
   git clone https://github.com/fossasia/magic-epaper-app
   cd magic-epaper-app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app** on a connected device or emulator (`flutter devices` to check what's connected):

   ```bash
   flutter run
   ```

   Use a physical Android device to test the NFC read/write and transfer features; an emulator is fine for the UI and design tools.

4. **Build release binaries** (optional, for production/testing):

   ```bash
   flutter build apk   # Android
   flutter build ios   # iOS (macOS + Xcode required)
   ```

### Testing

Run the unit and widget tests:

```bash
flutter test
```

Before opening a pull request, format the code and run the analyzer to match CI:

```bash
dart format .
flutter analyze
```

### Dev Container

Opening this repository in VS Code, GitHub Codespaces or another supported editor will let you reopen it inside a [Dev Container](https://containers.dev/) that bundles all tools needed to build, run and debug the app.

#### Connecting a device via `adb`

> **Note:** If `adb` is already installed and running on the host it may need to be stopped first.

**USB pass-through (entirely inside the container)**

> **Windows** and **macOS** need a working **USB/IP** setup. See the [Docker Desktop documentation](https://docs.docker.com/desktop/features/usbip/) and this [blog post](https://blog.golioth.io/usb-docker-windows-macos/).

The Dev Container bind-mounts `/dev/bus/usb/` and sets the correct access controls. Enable [USB debugging](https://developer.android.com/tools/adb#Enabling) on your phone and run `adb devices`; if it shows up, run `flutter run` to push a development build to your device.

**Using the host's `adb` server**

1. Ensure the host `adb` server listens on all interfaces: `adb kill-server && adb -a server`.
2. Export `ADB_SERVER_SOCKET=tcp:host.docker.internal:5037` before running `adb` or `flutter run`.
3. You should now see host-connected USB devices from inside the container.

**Wireless connection**

Android 11+ supports [wireless debugging](https://developer.android.com/tools/adb#wireless-android11-command-line). With both the workstation and device on the same network, `adb pair <IP>:<PORT>` then `adb connect <IP>:<PORT>`. This also works inside Codespaces if you bring both onto the same network with WireGuard, Tailscale or another overlay network.

## Contributing

Please read FOSSASIA's [Best Practices](https://blog.fossasia.org/open-source-developer-guide-and-best-practices-at-fossasia/) before contributing. Some basics:

* Single commit per pull request; squash before it can be merged.
* For commit messages, see [CommitStyle.md](docs/commitStyle.md).
* Follow the app's existing design language and keep the UI consistent.
* Attach relevant screenshots to any PR that changes the UI.
* Set up and explore the app locally before starting.
* Comment on an issue before working on it. If it's assigned but inactive, feel free to ask.

## Branch Policy

* **main**: all development happens here; open pull requests against `main`. PRs must pass the CI build check.
* **app**: latest app builds and releases.
* **version**: stores version information (versionName and versionCode) used for automatic versioning.
* **fastlane-android**: metadata used by Fastlane to automate Android deployment.
* **pr-screenshots**: screenshots generated per open pull request, shown in PR comments.

## Translations

Help translate the app on [Weblate](https://hosted.weblate.org/projects/fossasia/magic-epaper-app/).

Localized strings live in `lib/l10n` as `.arb` files. After editing an `.arb`, regenerate the Dart localizations with `flutter gen-l10n`.

## License

Licensed under the [Apache License 2.0](/LICENSE.md). Copyright © FOSSASIA and contributors.
