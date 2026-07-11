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
import 'constants/color_constants.dart';

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
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            dialogTheme: DialogThemeData(
              backgroundColor: colorWhite,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              actionsPadding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingL, vertical: Dimens.spacingS),
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimens.fontSizeXl,
                color: colorBlack,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingL, vertical: Dimens.spacingM),
              floatingLabelStyle: const TextStyle(color: colorAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
                borderSide: const BorderSide(color: colorAccent, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(vertical: Dimens.spacingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorAccent,
                foregroundColor: colorWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radiusXl)),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingM, vertical: Dimens.spacingM),
                textStyle: const TextStyle(
                    fontSize: Dimens.fontSizeL, fontWeight: FontWeight.w600),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radiusXl)),
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingM, vertical: Dimens.spacingM),
                textStyle: const TextStyle(
                    fontSize: Dimens.fontSizeL, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }
}
