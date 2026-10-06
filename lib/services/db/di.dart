import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/db/state.dart';

import 'database_manager_impl.dart';
import 'forecast_manager.dart';
import 'location_manager.dart';
import 'weather_db.dart';

final weatherDatabaseProvider = Provider<WeatherDatabase>((ref) {
  return WeatherDatabase();
});

final locationDatabaseProvider = Provider<LocationManager>((ref) {
  return DatabaseManagerImpl(database: ref.read(weatherDatabaseProvider));
});

final locationStorageProvider = AsyncNotifierProvider<LocationStorageNotifier, LocationsStorageState>(LocationStorageNotifier.new);

final forecastDatabaseProvider = Provider<ForecastManager>((ref) {
  return DatabaseManagerImpl(database: ref.read(weatherDatabaseProvider));
});