import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/app/di.dart';
import 'package:weather_with_flutter/services/location/geocoding_service.dart';
import 'package:weather_with_flutter/tools/logger/log.dart';

void main() {
  test('test geocoding provider', () async {
    final container = ProviderContainer.test();
    final geocoding = container.read(geocodingServiceComponent);
    final locations = await geocoding.fetchLocations(params: GeocodingFetchParameters(name: 'London'));
    if (kDebugMode) {
      Log.d(locations);
    }
    assert(locations.isNotEmpty);
  });
}
