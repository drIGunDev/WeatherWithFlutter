import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:weather_with_flutter/services/location/geocoding_service.dart';
import 'package:weather_with_flutter/services/location/open_meteo_geocoding_service_impl.dart';
import 'package:weather_with_flutter/tools/logger/log.dart';

void main() {
  test('test geocoding service', () async {
    final client = http.Client();
    final GeocodingService service = OpenMeteoGeocodingServiceImpl(client: client);
    final locations = await service.fetchLocations(params: GeocodingFetchParameters(name: 'London'));
    Log.d(locations);
    assert(locations.isNotEmpty);
  });
}
