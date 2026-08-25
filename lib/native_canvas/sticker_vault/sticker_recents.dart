import 'package:shared_preferences/shared_preferences.dart';

class StickerRecents {
  static const String _key = 'sticker_vault_recents';
  static const int _max = 24;

  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? const [];
  }

  Future<List<String>> add(String iconName) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    list.remove(iconName);
    list.insert(0, iconName);
    if (list.length > _max) list.removeRange(_max, list.length);
    await prefs.setStringList(_key, list);
    return list;
  }

  Future<List<String>> remove(String iconName) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    list.remove(iconName);
    await prefs.setStringList(_key, list);
    return list;
  }

  Future<List<String>> insertAt(String iconName, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    list.remove(iconName);
    list.insert(index.clamp(0, list.length), iconName);
    if (list.length > _max) list.removeRange(_max, list.length);
    await prefs.setStringList(_key, list);
    return list;
  }
}
