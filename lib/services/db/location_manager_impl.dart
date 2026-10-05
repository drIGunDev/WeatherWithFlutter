import 'package:drift/drift.dart';
import 'package:weather_with_flutter/services/location/types/location.dart';

import 'location_db.dart';
import 'location_manager.dart';

extension _ToCompanion on Location {
  LocationTableCompanion toCompanion() {
    return LocationTableCompanion.insert(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      country: country,
      countryCode: countryCode,
      city: city,
      timezone: timezone,
      isActive: Value(isActive),
    );
  }
}

extension _FromCompanion on LocationTableData {
  Location toLocation() {
    return Location(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      country: country,
      countryCode: countryCode,
      city: city,
      timezone: timezone,
      isActive: isActive,
    );
  }
}

final class LocationManagerImpl({
  required final LocationDatabase _database,
}) implements LocationManager {
  @override
  Future<void> add({required Location location}) async {
    final existing = await _find(id: location.id);
    if (existing == null) {
      await _database.into(_database.locationTable).insert(location.toCompanion());
    }
    await setActive(location: location);
  }

  @override
  Future<void> remove({required Location location}) async {
    await (_database.delete(_database.locationTable)..where((tbl) => tbl.id.equals(location.id))).go();
  }

  @override
  Future<void> setActive({required Location location}) {
    return _database.transaction(() async {
      await _database
          .update(
            _database.locationTable,
          )
          .write(
            LocationTableCompanion(isActive: Value(false)),
          );
      await (_database.update(
        _database.locationTable,
      )..where((tbl) => tbl.id.equals(location.id))).write(
        LocationTableCompanion(isActive: Value(true)),
      );
    });
  }

  @override
  Future<Location?> findActive() async {
    final location = await (_database.select(
      _database.locationTable,
    )..where((tbl) => tbl.isActive.equals(true))).getSingleOrNull();
    return location?.toLocation();
  }

  @override
  Future<Locations> fetchAll() {
    return _database.select(_database.locationTable).get().then((value) => value.map((e) => e.toLocation()).toList());
  }

  Future<Location?> _find({required String id}) async {
    final location = await (_database.select(
      _database.locationTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return location?.toLocation();
  }
}
