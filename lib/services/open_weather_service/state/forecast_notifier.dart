import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';

import '../../../app/di.dart';
import '../../../app/main.dart';
import '../../../tools/wrapped.dart';
import '../../location/types/location.dart';
import '../types/forecast_types.dart';

final class const WeatherForecastState({
  required final DaysForecast forecast,
  required final Location? location,
}) {
  static const WeatherForecastState empty = WeatherForecastState(forecast: [], location: null);
}

final class ForecastNotifier extends AsyncNotifier<WeatherForecastState> {
  @override
  FutureOr<WeatherForecastState> build() {
    return Future.value(.empty);
  }

  Future<void> fetchForecast({required WeatherForecastFetchParameters params}) async {
    state = AsyncValue.loading();

    final forecastManager = ref.read(forecastManagerComponent);
    final haveToUpdate = await forecastManager.haveToUpdateForecast(locationId: params.location.id, updateIntervalSec: AppParams.updateIntervalSec);

    if (haveToUpdate) {
      if (params.location.latitude == 0 && params.location.longitude == 0) {
        state = const AsyncValue.data(.empty);
        return;
      }

      state = await AsyncValue.guard(() async {
        final meteoService = ref.read(meteoServiceComponent);
        final forecast = await meteoService.fetchForecast(params: params);
        final updatedLocation = params.location.copyWith(weatherUpdatedAt: Wrapped.value(DateTime.now()), isActive: true);
        await forecastManager.updateForecast(location: updatedLocation, forecast: forecast);
        return WeatherForecastState(forecast: forecast.toDaysForecast(), location: updatedLocation);
      });
    } else {
      state = await AsyncValue.guard(() async {
        final manager = ref.read(locationManagerComponent);
        final forecast = await forecastManager.fetchForecast(location: params.location);
        final location = await manager.findLocationById(params.location.id);
        return WeatherForecastState(forecast: forecast.toDaysForecast(), location: location);
      });
    }
  }

  Future<void> delete({required Location location}) async {
    state = AsyncValue.data(.empty);
    final forecastProvider = ref.read(forecastManagerComponent);
    await forecastProvider.deleteForecast(location: location);
    final locationManager = ref.read(locationManagerComponent);
    await locationManager.deleteLocation(location: location);
  }
}

final weatherForecastProvider = AsyncNotifierProvider<ForecastNotifier, WeatherForecastState>(ForecastNotifier.new);
