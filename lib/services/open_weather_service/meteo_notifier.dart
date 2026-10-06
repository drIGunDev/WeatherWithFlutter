import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/open_weather_service/di.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';

import '../../app/main.dart';
import '../db/di.dart';
import '../location/types/location.dart';

final class MeteoNotifier extends AsyncNotifier<MeteoForecast> {
  @override
  FutureOr<MeteoForecast> build() {
    return Future.value([]);
  }

  Future<void> fetchForecast({required MeteoFetchParameters params}) async {
    final forecastProvider = ref.read(forecastDatabaseProvider);
    final haveToUpdate = await forecastProvider.haveToUpdateForecast(locationId: params.location.id, updateIntervalSec: AppParams.updateIntervalSec);

    if (haveToUpdate) {
      if (params.location.latitude == 0 && params.location.longitude == 0) {
        state = const AsyncValue.data([]);
        return;
      }
      state = AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final provider = ref.read(meteoServiceProvider);
        final forecast = await provider.fetchForecast(params: params);
        await forecastProvider.updateForecast(location: params.location, forecast: forecast);
        return forecast;
      });
    } else {
      state = AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        return await forecastProvider.fetchForecast(location: params.location);
      });
    }
  }

  Future<void> clear({required Location location}) async {
    state = const AsyncValue.data([]);
    final forecastProvider = ref.read(forecastDatabaseProvider);
    await forecastProvider.deleteForecast(location: location);
  }
}
