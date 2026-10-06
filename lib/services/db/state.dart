import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/types/location.dart';
import 'di.dart';
import 'location_manager.dart';

final class LocationsStorageState({
  required final Locations locations,
  required final Location? activeLocation,
});

class LocationStorageNotifier extends AsyncNotifier<LocationsStorageState> {
  @override
  Future<LocationsStorageState> build() async {
    return LocationsStorageState(
      locations: await ref.read(locationManagerProvider).fetchAll(),
      activeLocation: await ref.read(locationManagerProvider).findActive(),
    );
  }

  Future<int> add({required Location location, bool activate = true}) async {
    await ref.read(locationManagerProvider).add(location: location, activate: true);
    return await _refresh();
  }

  Future<int> remove({required Location location}) async {
    await ref.read(locationManagerProvider).remove(location: location);
    return await _refresh();
  }

  Future<int> setActive({required Location location}) async {
    await ref.read(locationManagerProvider).setActive(location: location);
    return await _refresh();
  }

  Future<int> _refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final manager = ref.read(locationManagerProvider);
      return LocationsStorageState(
        locations: await manager.fetchAll(),
        activeLocation: await manager.findActive(),
      );
    });
    return state.value?.locations.length ?? 0;
  }
}
