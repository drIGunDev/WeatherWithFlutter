import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:weather_with_flutter/app/di.dart';
import 'package:weather_with_flutter/db/weather_db.dart';
import 'package:weather_with_flutter/services/location/types/location.dart';
import 'package:weather_with_flutter/services/open_weather_service/state/forecast_notifier.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';
import 'package:weather_with_flutter/tools/wrapped.dart';

import 'support/forecast_fixtures.dart';

void main() {
  final berlin = Location(
    id: 'berlin',
    name: 'Berlin',
    latitude: 52.52,
    longitude: 13.405,
    country: 'Germany',
    countryCode: 'DE',
    city: 'Berlin',
    timezone: 'Europe/Berlin',
  );

  late WeatherDatabase db;
  late int requests;
  late bool online;
  late ProviderContainer container;

  setUp(() {
    requests = 0;
    online = true;
    db = WeatherDatabase(NativeDatabase.memory());
    container = ProviderContainer.test(
      overrides: [
        weatherDatabaseComponent.overrideWithValue(db),
        httpClientComponent.overrideWithValue(
          MockClient((_) async {
            requests++;
            if (!online) throw const SocketException('Failed host lookup');
            return http.Response(jsonEncode(forecastJson(hours: 3)), 200);
          }),
        ),
      ],
    );
  });

  tearDown(() => db.close());

  ForecastNotifier notifier() => container.read(weatherForecastProvider.notifier);
  WeatherForecastFetchParameters params() => WeatherForecastFetchParameters(location: berlin);

  /// Pretends the cached forecast was fetched [age] ago.
  Future<void> ageCache(Duration age) async {
    await container
        .read(locationManagerComponent)
        .addate(location: berlin.copyWith(weatherUpdatedAt: Wrapped.value(DateTime.now().subtract(age))));
  }

  test('empty cache: fetches from the network and stores the forecast', () async {
    await notifier().fetchForecast(params: params());

    final state = container.read(weatherForecastProvider);
    expect(state.hasError, isFalse);
    expect(state.requireValue.forecast, isNotEmpty);
    expect(state.requireValue.location?.weatherUpdatedAt, isNotNull);
    expect(requests, 1);
    expect(await container.read(forecastManagerComponent).fetchForecast(location: berlin), hasLength(3));
  });

  test('UTC offset survives the database round trip and is not wiped by a re-selected location', () async {
    await notifier().fetchForecast(params: params());
    final locations = container.read(locationManagerComponent);
    expect((await locations.findLocationById(berlin.id))?.utcOffsetSeconds, 3600);

    // The geocoder knows nothing about the offset; picking Berlin again must not erase it.
    await locations.addate(location: berlin);

    expect((await locations.findLocationById(berlin.id))?.utcOffsetSeconds, 3600);
  });

  test('fresh cache: served from the database without a network call', () async {
    await notifier().fetchForecast(params: params());
    requests = 0;

    await notifier().fetchForecast(params: params());

    expect(requests, 0);
    expect(container.read(weatherForecastProvider).requireValue.forecast, isNotEmpty);
  });

  test('stale cache + offline: falls back to the cached forecast with its real age', () async {
    await notifier().fetchForecast(params: params());
    await ageCache(const Duration(hours: 5));
    online = false;
    requests = 0;

    await notifier().fetchForecast(params: params());

    final state = container.read(weatherForecastProvider);
    expect(requests, 1, reason: 'stale cache must trigger a refresh attempt');
    expect(state.hasError, isFalse);
    expect(state.requireValue.forecast, isNotEmpty);
    final age = DateTime.now().difference(state.requireValue.location!.weatherUpdatedAt!);
    expect(age, greaterThan(const Duration(hours: 4)));
  });

  test('empty cache + offline: surfaces the communication error', () async {
    online = false;

    await notifier().fetchForecast(params: params());

    final state = container.read(weatherForecastProvider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<CommunicationError>());
  });
}
