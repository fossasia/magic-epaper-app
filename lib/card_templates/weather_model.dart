import 'package:flutter/material.dart';

enum TemperatureUnit { celsius, fahrenheit }

enum WeatherCondition {
  clear,
  mainlyClear,
  partlyCloudy,
  overcast,
  fog,
  drizzle,
  freezingRain,
  rain,
  rainShowers,
  snow,
  snowGrains,
  snowShowers,
  thunderstorm,
}

class WeatherData {
  final String cityName;
  final double temperatureC;
  final double apparentTemperatureC;
  final double tempMaxC;
  final double tempMinC;
  final int humidity;
  final double windSpeedKmh;
  final int weatherCode;
  final bool isDay;
  final DateTime time;

  const WeatherData({
    required this.cityName,
    required this.temperatureC,
    required this.apparentTemperatureC,
    required this.tempMaxC,
    required this.tempMinC,
    required this.humidity,
    required this.windSpeedKmh,
    required this.weatherCode,
    required this.isDay,
    required this.time,
  });

  WeatherCondition get condition => conditionForCode(weatherCode);

  double temperatureIn(TemperatureUnit unit) => _convert(temperatureC, unit);

  double apparentTemperatureIn(TemperatureUnit unit) =>
      _convert(apparentTemperatureC, unit);

  double tempMaxIn(TemperatureUnit unit) => _convert(tempMaxC, unit);

  double tempMinIn(TemperatureUnit unit) => _convert(tempMinC, unit);

  static double _convert(double celsius, TemperatureUnit unit) =>
      unit == TemperatureUnit.fahrenheit ? celsius * 9 / 5 + 32 : celsius;

  Map<String, dynamic> toJson() => {
        'cityName': cityName,
        'temperatureC': temperatureC,
        'apparentTemperatureC': apparentTemperatureC,
        'tempMaxC': tempMaxC,
        'tempMinC': tempMinC,
        'humidity': humidity,
        'windSpeedKmh': windSpeedKmh,
        'weatherCode': weatherCode,
        'isDay': isDay,
        'time': time.toIso8601String(),
      };

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    double d(String key) => (json[key] as num?)?.toDouble() ?? 0;
    return WeatherData(
      cityName: json['cityName'] as String? ?? '',
      temperatureC: d('temperatureC'),
      apparentTemperatureC: d('apparentTemperatureC'),
      tempMaxC: d('tempMaxC'),
      tempMinC: d('tempMinC'),
      humidity: (json['humidity'] as num?)?.round() ?? 0,
      windSpeedKmh: d('windSpeedKmh'),
      weatherCode: (json['weatherCode'] as num?)?.toInt() ?? 0,
      isDay: json['isDay'] as bool? ?? true,
      time: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

WeatherCondition conditionForCode(int code) {
  switch (code) {
    case 0:
      return WeatherCondition.clear;
    case 1:
      return WeatherCondition.mainlyClear;
    case 2:
      return WeatherCondition.partlyCloudy;
    case 3:
      return WeatherCondition.overcast;
    case 45:
    case 48:
      return WeatherCondition.fog;
    case 51:
    case 53:
    case 55:
      return WeatherCondition.drizzle;
    case 56:
    case 57:
    case 66:
    case 67:
      return WeatherCondition.freezingRain;
    case 61:
    case 63:
    case 65:
      return WeatherCondition.rain;
    case 80:
    case 81:
    case 82:
      return WeatherCondition.rainShowers;
    case 71:
    case 73:
    case 75:
      return WeatherCondition.snow;
    case 77:
      return WeatherCondition.snowGrains;
    case 85:
    case 86:
      return WeatherCondition.snowShowers;
    case 95:
    case 96:
    case 99:
      return WeatherCondition.thunderstorm;
    default:
      return WeatherCondition.clear;
  }
}

IconData weatherIconFor(WeatherCondition condition, bool isDay) {
  switch (condition) {
    case WeatherCondition.clear:
    case WeatherCondition.mainlyClear:
      return isDay ? Icons.wb_sunny : Icons.nightlight_round;
    case WeatherCondition.partlyCloudy:
      return isDay ? Icons.wb_cloudy : Icons.cloud;
    case WeatherCondition.overcast:
      return Icons.cloud;
    case WeatherCondition.fog:
      return Icons.foggy;
    case WeatherCondition.drizzle:
      return Icons.grain;
    case WeatherCondition.rain:
      return Icons.water_drop;
    case WeatherCondition.rainShowers:
      return Icons.umbrella;
    case WeatherCondition.freezingRain:
      return Icons.severe_cold;
    case WeatherCondition.snow:
    case WeatherCondition.snowGrains:
    case WeatherCondition.snowShowers:
      return Icons.ac_unit;
    case WeatherCondition.thunderstorm:
      return Icons.thunderstorm;
  }
}
