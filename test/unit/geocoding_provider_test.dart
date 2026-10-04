import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/services/location/di.dart';
import 'package:weather_with_flutter/services/location/geocoding_service.dart';

void main() {
  test('test geocoding provider', () async {
    final container = ProviderContainer.test();
    final geocoding = container.read(geocodingServiceProvider);
    final locations = await geocoding.fetchLocations(params: GeocodingFetchParameters(name: 'London'));
    if (kDebugMode) {
      print(locations);
    }
    assert(locations.isNotEmpty);
  });
}
