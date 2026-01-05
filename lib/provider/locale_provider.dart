import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class for managing the application's locale.
///
/// This class extends [ChangeNotifier] to allow widgets to listen for
/// changes in the locale and rebuild accordingly.
class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'app_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  /// Loads the saved locale from local storage (SharedPreferences).
  /// Call this once when the provider is created.
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);

    if (code == null || code.isEmpty) return;

    _locale = Locale(code);
    notifyListeners();
  }

  /// Sets the application's locale and persists it.
  ///
  /// When the locale is changed, it notifies all listening widgets to rebuild.
  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);

    notifyListeners();
  }

  /// Optional: Reset to system/default behavior.
  /// Use this if you provide a "System Default" option in UI.
  Future<void> clearLocale() async {
    _locale = const Locale('en'); // or set to null if your app supports null locale

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);

    notifyListeners();
  }
}
