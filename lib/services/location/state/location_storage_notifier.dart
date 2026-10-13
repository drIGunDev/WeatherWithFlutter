import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../types/location.dart';
import '../../../db/manager/location_manager.dart';

final class LocationsStorageState({
  required final Locations locations,
  required final Location? activeLocation,
});

class LocationStorageNotifier extends AsyncNotifier<LocationsStorageState> {
  @override
  Future<LocationsStorageState> build() async {
    return LocationsStorageState(
      locations: await ref.read(locationDatabaseProvider).fetchAllLocation(),
      activeLocation: await ref.read(locationDatabaseProvider).findActiveLocation(),
    );
  }

  Future<int> addate({required Location location}) async {
    await ref.read(locationDatabaseProvider).addate(location: location);
    return await _refresh();
  }

  Future<int> setLocationActive({required Location location}) async {
    await ref.read(locationDatabaseProvider).setLocationActive(location: location);
    return await _refresh();
  }

  Future<int> remove({required Location location}) async {
    await ref.read(locationDatabaseProvider).deleteLocation(location: location);
    return await _refresh();
  }

  Future<int> _refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final manager = ref.read(locationDatabaseProvider);
      return LocationsStorageState(
        locations: await manager.fetchAllLocation(),
        activeLocation: await manager.findActiveLocation(),
      );
    });
    return state.value?.locations.length ?? 0;
  }
}
