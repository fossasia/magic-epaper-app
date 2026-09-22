import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperOptionsProvider with ChangeNotifier {
  static const String _key = 'developer_options_enabled';

  bool _enabled = false;

  bool get enabled => _enabled;

  Future<void> loadSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = prefs.getBool(_key) ?? false;
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading developer options: $error');
    }
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, value);
    } catch (error) {
      debugPrint('Error saving developer options: $error');
    }
  }
}
