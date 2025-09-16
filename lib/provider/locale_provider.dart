import 'package:flutter/material.dart';

/// A provider class for managing the application's locale.
///
/// This class extends [ChangeNotifier] to allow widgets to listen for
/// changes in the locale and rebuild accordingly.
class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  /// Sets the application's locale.
  ///
  /// When the locale is changed, it notifies all listening widgets to rebuild.
  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
