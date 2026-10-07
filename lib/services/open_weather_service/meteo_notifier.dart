import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/open_weather_service/di.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';

import '../../app/main.dart';
import '../db/di.dart';
import '../location/types/location.dart';

final class const MeteoForecastState({
  required final MeteoForecast forecast,
  required final Location? location,
}) {
  static const MeteoForecastState empty = MeteoForecastState(forecast: [], location: null);
}

final class MeteoNotifier extends AsyncNotifier<MeteoForecastState> {
  @override
  FutureOr<MeteoForecastState> build() {
    return Future.value(.empty);
  }

  Future<void> fetchForecast({required MeteoFetchParameters params}) async {
    final forecastProvider = ref.read(forecastDatabaseProvider);
    final haveToUpdate = await forecastProvider.haveToUpdateForecast(locationId: params.location.id, updateIntervalSec: AppParams.updateIntervalSec);

    if (haveToUpdate) {
      if (params.location.latitude == 0 && params.location.longitude == 0) {
        state = const AsyncValue.data(.empty);
        return;
      }
      state = AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final provider = ref.read(meteoServiceProvider);
        final forecast = await provider.fetchForecast(params: params);
        await forecastProvider.updateForecast(location: params.location, forecast: forecast);
        return MeteoForecastState(forecast: forecast, location: params.location.copyWith(DateTime.now()));
      });
    } else {
      state = AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final locationManager = ref.read(locationDatabaseProvider);
        final forecast = await forecastProvider.fetchForecast(location: params.location);
        final location = await locationManager.findLocationById(params.location.id);
        return MeteoForecastState(forecast: forecast, location: location);
      });
    }
  }

  Future<void> clear({required Location location}) async {
    state = AsyncValue.data(.empty);
    final forecastProvider = ref.read(forecastDatabaseProvider);
    await forecastProvider.deleteForecast(location: location);
  }
}
