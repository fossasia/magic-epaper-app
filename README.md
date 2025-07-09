# Magic ePaper Badge
---

**Create and Transfer Customized Content to Tri-Color ePaper Badges via NFC**

## Features in Development

- **Content Creation**: Design badges with text, drawings, emojis, and imported images
- **Customization Options**: Apply effects (none, semi-transparent, block, portrait)
- **Text Formatting**: Choose fonts, sizes, and styles
- **Image Manipulation**: Adjust contrast, colors, and rotation
- **NFC Transfer**: Send your creations wirelessly to the badge
- **Battery-Free Operation**: Works with the badge's energy harvesting capabilities

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extensions
- For iOS development: Mac with [Xcode](https://developer.apple.com/xcode/) installed
- An Android or iOS device, or emulator/simulator

### Development Setup

1. Clone the repository
   ```
   git clone https://github.com/fossasia/magic-epaper-app.git
   ```

2. Navigate to the project directory
   ```
   cd magic-epaper-app
   ```

3. Get dependencies
   ```
   flutter pub get
   ```

4. Check your Flutter environment
   ```
   flutter doctor
   ```

### Running the App

#### Android

1. Connect Android device or start an emulator
   ```
   # To list available emulators
   flutter emulators
   
   # To launch an emulator
   flutter emulators --launch <emulator_id>
   ```

2. Run the app
   ```
   flutter run
   ```

3. Build APK 
   ```
   flutter build apk
   ```

#### iOS

1. Connect iOS device or start a simulator
   ```
   # To start iOS simulator
   open -a Simulator
   ```

2. Run the app
   ```
   flutter run
   ```

3. Build for iOS 
   ```
   flutter build ios
   ```
   Note: To deploy to an iOS device, you'll need an Apple Developer account and proper certificates.

## Permissions

* **NFC**: For transferring content to the badge

## Branch Policy

This project employs the following branch policy for development and app builds:

* **`main`**: All contributions should be submitted as Pull Requests (PRs) to the `main` branch. PRs targeting `main` must pass all Continuous Integration/Continuous Delivery (CI/CD) build checks.

* **`app`**: This branch exclusively contains automatically generated application builds upon the merging of a Pull Request to `main`. This includes builds for:
    * Android (APKs)
    * iOS
    * Desktop (platform-specific executables)
    * Other relevant build artifacts.

## Contributions Best Practices

Please take a moment to read FOSSASIA's [Best Practices](https://blog.fossasia.org/open-source-developer-guide-and-best-practices-at-fossasia/) before you start contributing. Following these guidelines helps everyone!

To make the review process smooth and ensure good code, let's keep these simple points in mind:

* **One Commit Per PR:** Each Pull Request (PR) should focus on a single change or feature.
* **Consistent Design:** Make sure your changes follow the same look and feel as the rest of the app.
* **Squash Your Commits:** Before your PR can be merged, if you have multiple small commits, please combine them into one. You (the author) need to do this, not the project maintainers.
* **Show Your Work (Frontend):** If your PR changes how the app looks, please include screenshots in the PR description.
* **Explore the App First:** Before you start coding, set up the project on your computer, run it, and try out all the features. Click all the buttons and see what happens! This helps you understand the app.
* **Claim Your Work:** If you want to work on a specific issue, leave a comment on it. If someone is already assigned but hasn't shown any activity, feel free to comment and start working on it.

## Troubleshooting

* **Flutter Version Issues**: If you encounter compatibility issues, make sure you're using the Flutter version specified in the `pubspec.yaml` file.
* **NFC Not Working**: Ensure your device has NFC capabilities and they are enabled in your device settings.
* **Build Errors**: Clear your build directory and run `flutter clean` followed by `flutter pub get`.

## LICENSE

The application is licensed under the [Apache License 2.0](https://github.com/fossasia/magic-epaper-app/blob/main/LICENSE.md). Copyright is owned by FOSSASIA and its contributors.
=======
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
