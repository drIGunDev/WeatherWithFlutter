import 'package:drift/drift.dart';
import 'package:weather_with_flutter/services/location/types/location.dart';

import '../../services/open_weather_service/types/event.dart';
import '../../services/open_weather_service/types/forecast_types.dart';
import '../../services/open_weather_service/types/precipitation.dart';
import '../../services/open_weather_service/types/temperature.dart';
import '../../services/open_weather_service/types/weather_item.dart';
import '../../services/open_weather_service/types/weather_type.dart';
import '../../services/open_weather_service/types/wind.dart';
import '../../tools/wrapped.dart';
import '../weather_db.dart';
import 'forecast_manager.dart';
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
      weatherUpdatedAt: Value(weatherUpdatedAt),
      // A location picked from the geocoder has no offset yet; don't wipe a known one.
      utcOffsetSeconds: Value.absentIfNull(utcOffsetSeconds),
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
      weatherUpdatedAt: weatherUpdatedAt,
      utcOffsetSeconds: utcOffsetSeconds,
    );
  }
}

extension _ToWeatherItem on WeatherTableData {
  WeatherItem toWeatherItem(Location location) {
    return WeatherItem(
      type: WeatherType.fromCode(type),
      temperature: Temperature.fromCelsius(temperature),
      apparentTemperature: Temperature.fromCelsius(apparentTemperature),
      wind: Wind(
        forceKmPerHour: windForce,
        gustsKmPerHour: windGusts,
        directionGrad: windDirectionGrad,
      ),
      location: location,
      precipitation: Precipitation(
        probabilityPercent: precipitationPercent,
        amountMm: precipitationAmountMm,
        rain: rain,
      ),
    );
  }
}

extension _ToEvent on WeatherTableData {
  Event<WeatherItem> toEvent(Location location) {
    return Event(
      start: start,
      end: end,
      item: toWeatherItem(location),
    );
  }
}

extension _ToWeatherItemCompanion on WeatherItem {
  WeatherTableCompanion toCompanion(Time start, Time end, Location location) {
    return WeatherTableCompanion.insert(
      start: start,
      end: end,
      type: type.type,
      temperature: temperature.celsius,
      apparentTemperature: apparentTemperature.celsius,
      windForce: wind.forceKmPerHour,
      windGusts: wind.gustsKmPerHour,
      windDirectionGrad: wind.directionGrad,
      precipitationPercent: precipitation.probabilityPercent,
      precipitationAmountMm: precipitation.amountMm,
      rain: precipitation.rain,
      locationId: location.id,
    );
  }
}

///
/// Implementation of [LocationManager] and [ForecastManager]
///
final class DatabaseManagerImpl({
  required final WeatherDatabase _database,
}) implements LocationManager, ForecastManager {
  @override
  Future<void> addate({required Location location}) async {
    await _database.transaction(() async {
      final existing = await _find(id: location.id);
      if (existing == null) {
        await _database.into(_database.locationTable).insert(location.toCompanion());
      } else {
        await _updateLocation(location: location);
      }
      if (location.isActive) {
        await setLocationActive(location: location);
      }
    });
  }

  Future<void> _updateLocation({required Location location}) async {
    await (_database.update(
      _database.locationTable,
    )..where((tbl) => tbl.id.equals(location.id))).write(
      location.toCompanion(),
    );
  }

  @override
  Future<void> deleteLocation({required Location location}) async {
    await _database.transaction(() async {
      final allLocations = await fetchAllLocation();
      if (allLocations.isEmpty) return;

      final activeLocation = await findActiveLocation();
      if (activeLocation == location) {
        final nextActiveLocation = await _findNextActiveTo(location);
        if (nextActiveLocation != null) {
          await setLocationActive(location: nextActiveLocation);
        }
      }
      await deleteForecast(location: location);
      await (_database.delete(_database.locationTable)..where((tbl) => tbl.id.equals(location.id))).go();
    });
  }

  @override
  Future<void> setLocationActive({required Location location}) {
    return _database.transaction(() async {
      final realLocation = await _find(id: location.id);
      if (realLocation == null) return;
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
  Future<Location?> findActiveLocation() async {
    final location = await (_database.select(
      _database.locationTable,
    )..where((tbl) => tbl.isActive.equals(true))).getSingleOrNull();
    return location?.toLocation();
  }

  @override
  Future<Locations> fetchAllLocation() {
    return _database.select(_database.locationTable).get().then((value) => value.map((e) => e.toLocation()).toList());
  }

  Future<Location?> _find({required String id}) async {
    final location = await (_database.select(
      _database.locationTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return location?.toLocation();
  }

  Future<Location?> _findNextActiveTo(Location activeLocation) async {
    final allLocations = await fetchAllLocation();
    if (allLocations.isEmpty || allLocations.length == 1) return .empty;

    final index = allLocations.indexOf(activeLocation);
    return (index == 0) ? allLocations[1] : allLocations[index - 1];
  }

  @override
  Future<void> updateForecast({required Location location, required ForecastList forecast}) async {
    await _database.transaction(() async {
      await addate(location: location.copyWith(weatherUpdatedAt: Wrapped.value(DateTime.now())));
      await deleteForecast(location: location);
      await _database.batch((batch) {
        for (final e in forecast) {
          batch.insert(
            _database.weatherTable,
            e.item.toCompanion(e.start, e.end, location),
          );
        }
      });
    });
  }

  @override
  Future<ForecastList> fetchForecast({required Location location}) async {
    final list = await _fetchForecast(location);
    return list.map((e) => e.toEvent(location)).toList();
  }

  @override
  Future<bool> haveToUpdateForecast({required String locationId, required int updateIntervalSec}) async {
    final location = await findLocationById(locationId);
    if (location == null) return true;
    final forecast = await _fetchForecast(location);
    if (forecast.isEmpty) return true;
    if (location.weatherUpdatedAt == null) return true;
    return DateTime.now().difference(location.weatherUpdatedAt!).inSeconds > updateIntervalSec;
  }

  @override
  Future<void> deleteForecast({required Location location}) {
    return _database.transaction(() async {
      await (_database.delete(
        _database.weatherTable,
      )..where((tbl) => tbl.locationId.equals(location.id))).go();
    });
  }

  @override
  Future<Location?> findLocationById(String locationId) async {
    final item = await (_database.select(
      _database.locationTable,
    )..where((tbl) => tbl.id.equals(locationId))).getSingleOrNull();
    if (item == null) return null;
    return item.toLocation();
  }

  Future<List<WeatherTableData>> _fetchForecast(Location location) {
    return (_database.select(_database.weatherTable)
          ..where((tbl) => tbl.locationId.equals(location.id))
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.asc),
          ]))
        .get();
  }
}
