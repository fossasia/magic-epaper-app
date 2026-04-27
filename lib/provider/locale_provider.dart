import 'package:flutter/material.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';

/// A provider class for managing the application's locale.
///
/// This class extends [ChangeNotifier] to allow widgets to listen for
/// changes in the locale and rebuild accordingly.
///
/// [current] is a static accessor updated by the app's MaterialApp builder,
/// allowing service classes without BuildContext to access localized strings.
class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  /// The static accessor for the current AppLocalizations instance.
  /// Updated from the MaterialApp builder every time the locale changes.
  static AppLocalizations? current;

  Locale get locale => _locale;

  /// Sets the application's locale.
  ///
  /// When the locale is changed, it notifies all listening widgets to rebuild.
  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
