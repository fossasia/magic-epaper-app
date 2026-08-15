import 'dart:convert';

import 'package:magicepaperapp/card_templates/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentCitiesStore {
  static const _key = 'weather_recent_cities';
  static const _maxEntries = 5;

  Future<List<GeoResult>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const <GeoResult>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <GeoResult>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_fromJson)
          .whereType<GeoResult>()
          .toList();
    } catch (_) {
      return const <GeoResult>[];
    }
  }

  Future<List<GeoResult>> add(GeoResult city) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    final next = <GeoResult>[
      city,
      ...current.where((c) => c.displayName != city.displayName),
    ].take(_maxEntries).toList();
    await prefs.setString(_key, jsonEncode(next.map(_toJson).toList()));
    return next;
  }

  Future<List<GeoResult>> remove(GeoResult city) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    final next =
        current.where((c) => c.displayName != city.displayName).toList();
    await prefs.setString(_key, jsonEncode(next.map(_toJson).toList()));
    return next;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Map<String, dynamic> _toJson(GeoResult c) => {
        'name': c.displayName,
        'lat': c.latitude,
        'lon': c.longitude,
      };

  static GeoResult? _fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final lat = json['lat'];
    final lon = json['lon'];
    if (name is! String || lat is! num || lon is! num) return null;
    return GeoResult(
      displayName: name,
      latitude: lat.toDouble(),
      longitude: lon.toDouble(),
    );
  }
}
