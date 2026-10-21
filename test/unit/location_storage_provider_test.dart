import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/app/di.dart';
import 'package:weather_with_flutter/db/weather_db.dart';
import 'package:weather_with_flutter/services/location/state/location_storage_notifier.dart';
import 'package:weather_with_flutter/services/location/types/location.dart';
import 'package:weather_with_flutter/tools/logger/log.dart';

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

  final london = Location(
    id: 'london',
    name: 'London',
    latitude: 51.51,
    longitude: 0.12,
    country: 'GB',
    countryCode: 'GB',
    city: 'London',
    timezone: 'Europe/London',
  );

  test('test location storage provider', () async {

    final container = ProviderContainer.test(
      overrides: [
        weatherDatabaseComponent.overrideWithValue(WeatherDatabase(NativeDatabase.memory())),
      ],
    );

    final storage = container.read(locationStorageProvider.notifier);
    await storage.addate(location: berlin.copyWith(isActive: true));
    await storage.addate(location: london);
    var state = await container.read(locationStorageProvider.future);
    Log.d(state);
    assert(state.locations.isNotEmpty);
    final activeLocation = state.locations.firstWhere((element) => element.isActive);
    assert(activeLocation.id == berlin.id);
    assert(activeLocation.id != london.id);
    await storage.remove(location: berlin);
    await storage.remove(location: london);
    state = await container.read(locationStorageProvider.future);
    assert(state.locations.isEmpty);
  });
}
