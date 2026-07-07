import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/provider/image_loader.dart';
import 'package:magicepaperapp/provider/locale_provider.dart';
import 'package:magicepaperapp/view/about_us_screen.dart';
import 'package:magicepaperapp/view/buy_badge_screen.dart';
import 'package:magicepaperapp/view/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:magicepaperapp/ndef_screen/nfc_read_screen.dart';
import 'package:magicepaperapp/ndef_screen/nfc_write_screen.dart';
import 'package:magicepaperapp/view/display_selection_screen.dart';
import 'package:magicepaperapp/src/rust/frb_generated.dart';
import 'package:magicepaperapp/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RustLib.init();

  setupLocator();

  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageLoader()),
        ChangeNotifierProvider(create: (_) => ImageLibraryProvider()),
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'Magic ePaper',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeProvider.locale,
          builder: (context, child) {
            registerAppLocalizations(AppLocalizations.of(context)!);
            return child!;
          },
          initialRoute: '/',
          routes: {
            '/': (context) => const DisplaySelectionScreen(),
            '/aboutUs': (context) => const AboutUsScreen(),
            '/buyBadge': (context) => const BuyBadgeScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/nfcReadScreen': (context) => const NFCReadScreen(),
            '/nfcWriteScreen': (context) => const NFCWriteScreen(),
          },
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
