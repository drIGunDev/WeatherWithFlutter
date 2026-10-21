import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/db/manager/database_manager_impl.dart';
import 'package:weather_with_flutter/db/manager/location_manager.dart';
import 'package:weather_with_flutter/db/weather_db.dart';
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

  late final WeatherDatabase db;
  late final LocationManager manager;
  setUp(() async {
    db = WeatherDatabase(NativeDatabase.memory());
    manager = DatabaseManagerImpl(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('test location storage', () async {
    await manager.addate(location: berlin);
    await manager.addate(location: london);
    await manager.setLocationActive(location: berlin.copyWith(isActive: true));
    var locations = await manager.fetchAllLocation();
    Log.d(locations);
    assert(locations.isNotEmpty);
    assert(locations.contains(berlin), true);
    assert(locations.contains(london), true);
    final activeLocation = locations.firstWhere((element) => element.isActive);
    assert(activeLocation.id == berlin.id);
    assert(activeLocation.id != london.id);
    await manager.deleteLocation(location: berlin);
    await manager.deleteLocation(location: london);
    locations = await manager.fetchAllLocation();
    assert(locations.isEmpty);
  });
}
