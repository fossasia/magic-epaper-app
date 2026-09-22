import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:magicepaperapp/card_templates/weather_badge.dart';
import 'package:magicepaperapp/card_templates/weather_card_widget.dart';
import 'package:magicepaperapp/card_templates/weather_model.dart';
import 'package:magicepaperapp/card_templates/weather_service.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';

WeatherData _sample({int code = 61, bool isDay = true}) => WeatherData(
      cityName: 'London, England, United Kingdom',
      temperatureC: 17.4,
      apparentTemperatureC: 15.9,
      tempMaxC: 20.1,
      tempMinC: 11.2,
      humidity: 72,
      windSpeedKmh: 14.6,
      weatherCode: code,
      isDay: isDay,
      time: DateTime(2026, 8, 2, 12),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppLocalizations>()) {
      getIt.unregister<AppLocalizations>();
    }
    getIt.registerSingleton<AppLocalizations>(l10n);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  group('WMO code mapping', () {
    test('maps representative codes to conditions', () {
      expect(conditionForCode(0), WeatherCondition.clear);
      expect(conditionForCode(2), WeatherCondition.partlyCloudy);
      expect(conditionForCode(3), WeatherCondition.overcast);
      expect(conditionForCode(48), WeatherCondition.fog);
      expect(conditionForCode(55), WeatherCondition.drizzle);
      expect(conditionForCode(65), WeatherCondition.rain);
      expect(conditionForCode(75), WeatherCondition.snow);
      expect(conditionForCode(82), WeatherCondition.rainShowers);
      expect(conditionForCode(95), WeatherCondition.thunderstorm);
      expect(conditionForCode(9999), WeatherCondition.clear);
    });

    test('clear condition icon depends on day/night', () {
      final day = weatherIconFor(WeatherCondition.clear, true);
      final night = weatherIconFor(WeatherCondition.clear, false);
      expect(day, isNot(equals(night)));
    });
  });

  group('temperature conversion', () {
    test('converts celsius to fahrenheit', () {
      final data = _sample();
      expect(data.temperatureIn(TemperatureUnit.celsius), 17.4);
      expect(
        data.temperatureIn(TemperatureUnit.fahrenheit),
        closeTo(63.32, 0.001),
      );
    });
  });

  group('WeatherService', () {
    MockClient buildClient() {
      return MockClient((request) async {
        if (request.url.host.contains('geocoding')) {
          return http.Response(
            jsonEncode({
              'results': [
                {
                  'name': 'London',
                  'admin1': 'England',
                  'country': 'United Kingdom',
                  'latitude': 51.5074,
                  'longitude': -0.1278,
                }
              ]
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'current': {
              'time': '2026-08-02T12:00',
              'temperature_2m': 17.4,
              'relative_humidity_2m': 72,
              'apparent_temperature': 15.9,
              'is_day': 1,
              'weather_code': 61,
              'wind_speed_10m': 14.6,
            },
            'daily': {
              'temperature_2m_max': [20.1],
              'temperature_2m_min': [11.2],
            },
          }),
          200,
        );
      });
    }

    test('fetchByCity parses geocode + forecast', () async {
      final service = WeatherService(client: buildClient());
      final data = await service.fetchByCity('London');
      expect(data.cityName, 'London, England, United Kingdom');
      expect(data.temperatureC, 17.4);
      expect(data.humidity, 72);
      expect(data.tempMaxC, 20.1);
      expect(data.tempMinC, 11.2);
      expect(data.condition, WeatherCondition.rain);
      expect(data.isDay, isTrue);
    });

    test('empty city throws before any request', () async {
      final service = WeatherService(client: buildClient());
      expect(
        () => service.fetchByCity('   '),
        throwsA(isA<WeatherException>()),
      );
    });

    test('city not found throws', () async {
      final service = WeatherService(
        client: MockClient((_) async => http.Response('{"results":[]}', 200)),
      );
      await expectLater(
        service.fetchByCity('Nowhereville'),
        throwsA(isA<WeatherException>()),
      );
    });

    test('non-200 maps to network error', () async {
      final service = WeatherService(
        client: MockClient((_) async => http.Response('oops', 500)),
      );
      await expectLater(
        service.fetchByCity('London'),
        throwsA(predicate((e) =>
            e is WeatherException && e.messageKey == 'weatherErrorNetwork')),
      );
    });
  });

  group('WeatherBadge rendering', () {
    Future<void> pumpBadge(WidgetTester tester, Size size,
        {TemperatureUnit unit = TemperatureUnit.celsius}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: WeatherBadge(data: _sample(), unit: unit),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('renders landscape 296x128 without overflow', (tester) async {
      await pumpBadge(tester, const Size(296, 128));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders portrait 128x296 without overflow', (tester) async {
      await pumpBadge(tester, const Size(128, 296));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders fahrenheit at small size', (tester) async {
      await pumpBadge(tester, const Size(250, 122),
          unit: TemperatureUnit.fahrenheit);
      expect(tester.takeException(), isNull);
    });

    testWidgets('card widget shows placeholder when no data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherCardWidget(
              data: null,
              unit: TemperatureUnit.celsius,
              width: 296,
              height: 128,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.cloud_outlined), findsOneWidget);
    });
  });
}
