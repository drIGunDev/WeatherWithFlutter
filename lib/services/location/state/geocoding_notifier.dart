import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../geocoding_service.dart';

class const GeocodingState({required final GeocodingResult result});

final class GeocodingNotifier extends AsyncNotifier<GeocodingState> {
  @override
  FutureOr<GeocodingState> build() {
    return Future.value(GeocodingState(result: []));
  }

  Future<void> fetchLocations({required GeocodingFetchParameters params}) async {
    if (params.name.isEmpty) {
      state = const AsyncValue.data(GeocodingState(result: []));
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(geocodingServiceComponent);
      final results = GeocodingState(result: await service.fetchLocations(params: params));
      return results;
    });
  }

  Future<void> reset() async {
    state = const AsyncValue.data(GeocodingState(result: []));
  }
}
