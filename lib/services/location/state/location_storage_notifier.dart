import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../../../db/manager/location_manager.dart';
import '../types/location.dart';

final class LocationsStorageState({
  required final Locations locations,
  required final Location? activeLocation,
});

class LocationStorageNotifier extends AsyncNotifier<LocationsStorageState> {
  @override
  Future<LocationsStorageState> build() async {
    return LocationsStorageState(
      locations: await ref.read(locationManagerComponent).fetchAllLocation(),
      activeLocation: await ref.read(locationManagerComponent).findActiveLocation(),
    );
  }

  Future<int> addate({required Location location}) async {
    await ref.read(locationManagerComponent).addate(location: location);
    return await _refresh();
  }

  Future<int> setLocationActive({required Location location}) async {
    await ref.read(locationManagerComponent).setLocationActive(location: location);
    return await _refresh();
  }

  Future<int> remove({required Location location}) async {
    await ref.read(locationManagerComponent).deleteLocation(location: location);
    return await _refresh();
  }

  Future<int> _refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final manager = ref.read(locationManagerComponent);
      return LocationsStorageState(
        locations: await manager.fetchAllLocation(),
        activeLocation: await manager.findActiveLocation(),
      );
    });
    return state.value?.locations.length ?? 0;
  }
}

final locationStorageProvider = AsyncNotifierProvider<LocationStorageNotifier, LocationsStorageState>(LocationStorageNotifier.new);