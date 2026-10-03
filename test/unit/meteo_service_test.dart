import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:weather_with_flutter/services/location/types/location.dart';
import 'package:weather_with_flutter/services/open_weather_service/open_meteo_weather_service_impl.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';
import 'package:weather_with_flutter/tools/logger/log.dart';

void main() {
  test('test meteo service', () async {
    final client = http.Client();
    final WeatherService service = OpenMeteoWeatherServiceImpl(client: client);
    final result = await service.fetchForecast(
      params: MeteoFetchParameters(
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
