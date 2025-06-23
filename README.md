# magic_epaper_app

A new Flutter project.

## Table of Contents
- [Getting Started](#getting-started)
- [Assets](#assets)
- [Localization](#localization)
- [Installation Steps](#installation-steps)
  - [Prerequisites](#prerequisites)
  - [Clone the Repository](#clone-the-repository)
  - [Install Dependencies](#install-dependencies)
- [Running the Project](#running-the-project)


## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/to/state-management-sample).

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/to/resolution-aware-images).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter apps](https://flutter.dev/to/internationalization).

## Installation Steps

### Prerequisites

##### Before setting up the project, ensure you have the following installed:

Flutter SDK: Install from Flutter's official website.

Dart SDK: Included with Flutter, but verify installation using `dart --version`

Git: Required for cloning the repository. Install from Git's official site.

Android Studio or VS Code: Recommended IDEs for Flutter development.

Android Emulator or Physical Device: For running the application.


1. Clone the Repository
```
git clone https://github.com/fossasia/magic-epaper-app
cd magic-epaper-app
```

2. Install Dependencies
```
flutter pub get
```

## Running the Project

1. Run on an Emulator or Physical Device

Ensure an emulator is running or a device is connected.

Execute:
```
flutter run
```
2. Build the App (For production/testing)
```
flutter build apk  # For Android
flutter build ios  # For iOS (macOS required)
```
