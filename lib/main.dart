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
import 'package:magicepaperapp/ndef_screen/nfc_read_screen.dart';
import 'package:magicepaperapp/ndef_screen/nfc_write_screen.dart';
import 'package:magicepaperapp/view/display_selection_screen.dart';

void main() {
  /// Sets up the GetIt service locator for dependency injection.
  setupLocator();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ImageLoader()),
      ChangeNotifierProvider(create: (_) => ImageLibraryProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic ePaper',

      /// Delegates for handling localization.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      builder: (context, child) {
        /// Registers the AppLocalizations instance with the service locator
        /// to make it accessible throughout the app without a BuildContext.
        registerAppLocalizations(AppLocalizations.of(context)!);
        return child!;
      },

      initialRoute: '/',

      routes: {
        '/': (context) => const DisplaySelectionScreen(),
        '/aboutUs': (context) => const AboutUsScreen(),
        '/buyBadge': (context) => const BuyBadgeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/ndefScreen': (context) => const NDEFScreen(),
        '/nfcReadScreen': (context) => const NFCReadScreen(),
        '/nfcWriteScreen': (context) => const NFCWriteScreen(),
      },

      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
