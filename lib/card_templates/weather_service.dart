import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:magicepaperapp/card_templates/weather_model.dart';

class WeatherException implements Exception {
  final String messageKey;
  WeatherException(this.messageKey);
}

class GeoResult {
  final String displayName;
  final double latitude;
  final double longitude;

  const GeoResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });
}

class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  static const _geocodeHost = 'geocoding-api.open-meteo.com';
  static const _forecastHost = 'api.open-meteo.com';

  Future<GeoResult> geocodeCity(String city) async {
    final name = city.trim();
    if (name.isEmpty) throw WeatherException('weatherErrorEmptyCity');

    final uri = Uri.https(_geocodeHost, '/v1/search', {
      'name': name,
      'count': '1',
      'language': 'en',
      'format': 'json',
    });

    final Map<String, dynamic> json = await _getJson(uri);
    final results = json['results'];
    if (results is! List || results.isEmpty) {
      throw WeatherException('weatherErrorCityNotFound');
    }

    return _geoFromJson(results.first as Map<String, dynamic>);
  }

  Future<List<GeoResult>> searchCities(String query, {int count = 6}) async {
    final name = query.trim();
    if (name.length < 2) return const <GeoResult>[];

    final uri = Uri.https(_geocodeHost, '/v1/search', {
      'name': name,
      'count': '$count',
      'language': 'en',
      'format': 'json',
    });

    final Map<String, dynamic> json = await _getJson(uri);
    final results = json['results'];
    if (results is! List) return const <GeoResult>[];
    return results.whereType<Map<String, dynamic>>().map(_geoFromJson).toList();
  }

  static GeoResult _geoFromJson(Map<String, dynamic> json) {
    final parts = <String>[
      if ((json['name'] as String?)?.isNotEmpty ?? false)
        json['name'] as String,
      if ((json['admin1'] as String?)?.isNotEmpty ?? false)
        json['admin1'] as String,
      if ((json['country'] as String?)?.isNotEmpty ?? false)
        json['country'] as String,
    ];

    return GeoResult(
      displayName: parts.join(', '),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Future<WeatherData> fetchByCity(String city) async {
    final geo = await geocodeCity(city);
    return fetchByCoordinates(
      latitude: geo.latitude,
      longitude: geo.longitude,
      displayName: geo.displayName,
    );
  }

  Future<WeatherData> fetchByCoordinates({
    required double latitude,
    required double longitude,
    required String displayName,
  }) async {
    final uri = Uri.https(_forecastHost, '/v1/forecast', {
      'latitude': latitude.toStringAsFixed(4),
      'longitude': longitude.toStringAsFixed(4),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m',
      'daily': 'temperature_2m_max,temperature_2m_min',
      'timezone': 'auto',
      'forecast_days': '1',
    });

    final Map<String, dynamic> json = await _getJson(uri);
    final current = json['current'];
    if (current is! Map<String, dynamic>) {
      throw WeatherException('weatherErrorGeneric');
    }
    final daily = json['daily'] is Map<String, dynamic>
        ? json['daily'] as Map<String, dynamic>
        : const <String, dynamic>{};

    double firstDaily(String key, double fallback) {
      final list = daily[key];
      if (list is List && list.isNotEmpty && list.first is num) {
        return (list.first as num).toDouble();
      }
      return fallback;
    }

    final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 0;

    return WeatherData(
      cityName: displayName,
      temperatureC: temp,
      apparentTemperatureC:
          (current['apparent_temperature'] as num?)?.toDouble() ?? temp,
      tempMaxC: firstDaily('temperature_2m_max', temp),
      tempMinC: firstDaily('temperature_2m_min', temp),
      humidity: (current['relative_humidity_2m'] as num?)?.round() ?? 0,
      windSpeedKmh: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0,
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      isDay: (current['is_day'] as num?)?.toInt() != 0,
      time:
          DateTime.tryParse(current['time'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 15));
    } catch (_) {
      throw WeatherException('weatherErrorNetwork');
    }

    if (response.statusCode != 200) {
      throw WeatherException('weatherErrorNetwork');
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw WeatherException('weatherErrorGeneric');
    } on WeatherException {
      rethrow;
    } catch (_) {
      throw WeatherException('weatherErrorGeneric');
    }
  }

  void dispose() => _client.close();
}
