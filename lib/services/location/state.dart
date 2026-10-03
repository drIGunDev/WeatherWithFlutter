
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'di.dart';
import 'geocoding_service.dart';

final class GeocodingNotifier extends AsyncNotifier<GeocodingResult> {
  @override
  FutureOr<GeocodingResult> build() {
    return Future.value([]);
  }

  Future<void> fetchLocations(GeocodingFetchParameters params) async {
    if (params.name.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final provider = ref.read(geocodingServiceProvider);
      final results = await provider.fetchLocations(params: params);
      return results;
    });
  }
}
