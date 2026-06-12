import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class for managing the application's locale.
///
/// This class extends [ChangeNotifier] to allow widgets to listen for
/// changes in the locale and rebuild accordingly.
class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  static const Locale defaultLocale = Locale('en');

  Locale _locale = defaultLocale;

  Locale get locale => _locale;

  /// Loads the saved locale from local storage.
  ///
  /// If no locale is saved, the app continues using the default locale.
  Future<void> loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);

      if (savedLocale == null || savedLocale.isEmpty) return;

      _locale = _localeFromLanguageTag(savedLocale);
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading saved locale: $error');
    }
  }

  /// Sets the application's locale and saves it locally.
  ///
  /// When the locale is changed, it notifies all listening widgets to rebuild.
  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale.toLanguageTag());
    } catch (error) {
      debugPrint('Error saving locale: $error');
    }
  }

  /// Resets the locale to the app's default locale and clears any saved locale preference.
  Future<void> clearLocale() async {
    _locale = defaultLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localeKey);
    } catch (error) {
      debugPrint('Error clearing locale: $error');
    }
  }

  Locale _localeFromLanguageTag(String languageTag) {
    final parts = languageTag.split('-');

    if (parts.isEmpty || parts.first.isEmpty) {
      return defaultLocale;
    }

    if (parts.length == 1) {
      return Locale(parts[0]);
    }

    if (parts.length == 2) {
      return Locale.fromSubtags(
        languageCode: parts[0],
        countryCode: parts[1],
      );
    }

    return Locale.fromSubtags(
      languageCode: parts[0],
      scriptCode: parts[1],
      countryCode: parts[2],
    );
  }
}
