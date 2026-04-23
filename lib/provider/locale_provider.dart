import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class for managing the application's locale.
///
/// This class extends [ChangeNotifier] to allow widgets to listen for
/// changes in the locale and rebuild accordingly.
class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'selected_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  /// Loads the saved locale from local storage.
  ///
  /// If no locale is saved, the app continues using the default locale.
  Future<void> loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);

      if (savedLocale == null || savedLocale.isEmpty) return;

      final parts = savedLocale.split('_');

      _locale = parts.length > 1 && parts[1].isNotEmpty
          ? Locale(parts[0], parts[1])
          : Locale(parts[0]);

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }
  }

  /// Sets the application's locale and saves it locally.
  ///
  /// When the locale is changed, it notifies all listening widgets to rebuild.
  Future<void> setLocale(Locale newLocale) async {
    try {
      _locale = newLocale;

      final prefs = await SharedPreferences.getInstance();
      final localeString = newLocale.countryCode != null &&
              newLocale.countryCode!.isNotEmpty
          ? '${newLocale.languageCode}_${newLocale.countryCode}'
          : newLocale.languageCode;

      await prefs.setString(_localeKey, localeString);

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  /// Resets the locale to the app's default locale (English)
  /// and clears any saved locale preference.
  Future<void> clearLocale() async {
    try {
      _locale = const Locale('en');

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localeKey);

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing locale: $e');
    }
  }
}