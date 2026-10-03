import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/open_weather_service/di.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';

final class MeteoNotifier extends AsyncNotifier<MeteoResult> {
  @override
  FutureOr<MeteoResult> build() {
    return Future.value([]);
  }

  Future<void> fetchForecast(MeteoFetchParameters params) async {
    if (params.location.latitude == 0 && params.location.longitude == 0) {
      state = const AsyncValue.data([]);
      return;
    }
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final provider = ref.read(meteoServiceProvider);
      return await provider.fetchForecast(params: params);
    });
  }
}
