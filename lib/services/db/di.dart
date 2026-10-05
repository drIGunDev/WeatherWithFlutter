import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/db/state.dart';

import 'location_db.dart';
import 'location_manager.dart';
import 'location_manager_impl.dart';

final locationDatabaseProvider = Provider<LocationDatabase>((ref) {
  return LocationDatabase();
});

final locationManagerProvider = Provider<LocationManager>((ref) {
  return LocationManagerImpl(database: ref.read(locationDatabaseProvider));
});

final locationStorageProvider = AsyncNotifierProvider<LocationStorageNotifier, LocationsStorageState>(LocationStorageNotifier.new);
