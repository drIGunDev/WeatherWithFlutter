import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:weather_with_flutter/services/location/types/location.dart';
import 'package:weather_with_flutter/services/open_weather_service/open_meteo_weather_service_impl.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';

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

  Future<dynamic> fetch(http.Client client) {
    final WeatherService service = OpenMeteoWeatherServiceImpl(client: client);
    return service.fetchForecast(params: WeatherForecastFetchParameters(location: berlin));
  }

  test('parses a 200 response into hourly events', () async {
    late Uri requested;
    final client = MockClient((request) async {
      requested = request.url;
      return http.Response(jsonEncode(forecastJson(hours: 3)), 200);
    });

    final forecast = await fetch(client);

    expect(forecast, hasLength(3));
    expect(forecast.first.item.temperature.celsius, 10.0);
    expect(forecast.first.end.difference(forecast.first.start), const Duration(hours: 1));
    expect(forecast.first.item.location, berlin);
    expect(requested.host, 'api.open-meteo.com');
    expect(requested.queryParameters['latitude'], '52.52');
    expect(requested.queryParameters['longitude'], '13.405');
  });

  test('keeps the location UTC offset reported by the API', () async {
    final client = MockClient((_) async => http.Response(jsonEncode(forecastJson(utcOffsetSeconds: 43200)), 200));

    final forecast = await fetch(client);

    expect(forecast.first.item.location.utcOffsetSeconds, 43200);
  });

  test('HTTP 500 is reported as CommunicationError', () async {
    final client = MockClient((_) async => http.Response('boom', 500));

    await expectLater(fetch(client), throwsA(isA<CommunicationError>()));
  });

  test('SocketException (offline) is reported as CommunicationError', () async {
    final client = MockClient((_) async => throw const SocketException('Failed host lookup'));

    await expectLater(fetch(client), throwsA(isA<CommunicationError>()));
  });

  test('http.ClientException is reported as CommunicationError', () async {
    final client = MockClient((_) async => throw http.ClientException('connection closed'));

    await expectLater(fetch(client), throwsA(isA<CommunicationError>()));
  });

  test('TimeoutException is reported as CommunicationError', () async {
    final client = MockClient((_) async => throw TimeoutException('too slow'));

    await expectLater(fetch(client), throwsA(isA<CommunicationError>()));
  });

  test('malformed body is a FormatException, not a CommunicationError', () async {
    final client = MockClient((_) async => http.Response('[]', 200));

    await expectLater(fetch(client), throwsA(isA<FormatException>()));
  });
}
