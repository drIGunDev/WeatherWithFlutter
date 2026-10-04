import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/types/location.dart';
import 'di.dart';
import 'location_manager.dart';

class LocationStorageNotifier extends AsyncNotifier<Locations> {
  @override
  FutureOr<Locations> build() {
    return ref.read(locationManagerProvider).fetchAll();
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

  Future<void> _refresh() async{
    final manager = ref.read(locationManagerProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await manager.fetchAll());
  }
}