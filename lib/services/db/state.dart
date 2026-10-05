import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/types/location.dart';
import 'di.dart';
import 'location_manager.dart';

final class LocationsStorageState({required final Locations locations});

class LocationStorageNotifier extends AsyncNotifier<LocationsStorageState> {
  @override
  Future<LocationsStorageState> build() async {
    return  LocationsStorageState(locations: await ref.read(locationManagerProvider).fetchAll()); //Future.value(LocationsStorageState(locations: [])); //
  }

  Future<void> add({required Location location}) async {
    await ref.read(locationManagerProvider).add(location: location);
    await _refresh();
  }

  Future<void> remove({required Location location}) async {
    await ref.read(locationManagerProvider).remove(location: location);
    await _refresh();
  }

  Future<void> setActive({required Location location}) async {
    await ref.read(locationManagerProvider).setActive(location: location);
    await _refresh();
  }

  Future<Location?> findActive() async {
    final location = await ref.read(locationManagerProvider).findActive();
    return location;
  }

  Future<void> _refresh() async{
    final manager = ref.read(locationManagerProvider);
    state = const AsyncValue.loading();
    final value = await AsyncValue.guard(() async => LocationsStorageState(locations: await manager.fetchAll()));
    state = value;
  }
}