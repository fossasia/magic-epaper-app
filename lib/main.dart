import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/ndef_screen/ndef_screen.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/provider/image_loader.dart';
import 'package:magicepaperapp/view/about_us_screen.dart';
import 'package:magicepaperapp/view/buy_badge_screen.dart';
import 'package:magicepaperapp/view/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:magicepaperapp/ndef_screen/ndef_screen.dart';
import 'package:magicepaperapp/ndef_screen/nfc_read_screen.dart';
import 'package:magicepaperapp/ndef_screen/nfc_write_screen.dart';
import 'package:magicepaperapp/view/display_selection_screen.dart';

/// The main entry point of the application.
///
/// Initializes the service locator and runs the app with the necessary providers.
void main() {
  /// Sets up the GetIt service locator for dependency injection.
  setupLocator();
  runApp(
    /// Uses MultiProvider to provide multiple objects down the widget tree.
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ImageLoader()),
      ChangeNotifierProvider(create: (_) => ImageLibraryProvider()),
    ], child: const MyApp()),
  );
}

/// The root widget of the Magic Epaper application.
///
/// This widget sets up the overall structure of the app, including
/// theme, localization, and navigation routes.
class MyApp extends StatelessWidget {
  /// Creates the MyApp widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// The main application widget that configures the app's theme, routes,
    /// and localization.
    return MaterialApp(
      title: 'Magic ePaper',

      /// Delegates for handling localization.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      /// The builder is used for global setup that needs a BuildContext.
      builder: (context, child) {
        /// Registers the AppLocalizations instance with the service locator
        /// to make it accessible throughout the app without a BuildContext.
        registerAppLocalizations(AppLocalizations.of(context)!);
        return child!;
      },

      /// The initial route that the app will display.
      initialRoute: '/',

      /// Defines the named routes for navigation within the app.
      routes: {
        '/': (context) => const DisplaySelectionScreen(),
        '/aboutUs': (context) => const AboutUsScreen(),
        '/buyBadge': (context) => const BuyBadgeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/ndefScreen': (context) => const NDEFScreen(),
        '/nfcReadScreen': (context) => const NFCReadScreen(),
        '/nfcWriteScreen': (context) => const NFCWriteScreen(),
      },

      /// Sets the theme for the application.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
