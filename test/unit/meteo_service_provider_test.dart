import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/app/di.dart';
import 'package:weather_with_flutter/services/location/types/location.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';
import 'package:weather_with_flutter/tools/logger/log.dart';

void main() {
  test('test meteo provider', () async {
    final container = ProviderContainer.test();
    final meteo = container.read(meteoServiceComponent);
    final result = await meteo.fetchForecast(
      params: WeatherForecastFetchParameters(
        location: Location(
          id: 'berlin',
          name: 'Berlin',
          latitude: 52.52,
          longitude: 13.405,
          country: 'Germany',
          countryCode: 'DE',
          city: 'Berlin',
          timezone: 'Europe/Berlin',
        ),
      ),
    );
    Log.d(result);
    assert(result.isNotEmpty);
  });
}
