import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/open_weather_service/weather_service.dart';

import '../../../app/di.dart';
import '../../../app/main.dart';
import '../../../tools/wrapped.dart';
import '../../location/types/location.dart';

final class const WeatherForecastState({
  required final ForecastList forecast,
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
        final updatedLocation = params.location.copyWith(weatherUpdatedAt: Wrapped.value(DateTime.now()), isActive: true);
        await forecastProvider.updateForecast(location: updatedLocation, forecast: forecast);
        return WeatherForecastState(forecast: forecast, location: updatedLocation);
      });
    } else {
      state = AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final locationManager = ref.read(locationDatabaseProvider);
        final forecast = await forecastProvider.fetchForecast(location: params.location);
        final location = await locationManager.findLocationById(params.location.id);
        return WeatherForecastState(forecast: forecast, location: location);
      });
    }
  }

  Future<void> clear({required Location location}) async {
    state = AsyncValue.data(.empty);
    final forecastProvider = ref.read(forecastDatabaseProvider);
    await forecastProvider.deleteForecast(location: location);
    final locationManager = ref.read(locationDatabaseProvider);
    await locationManager.deleteLocation(location: location);
  }
}
