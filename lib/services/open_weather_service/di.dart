import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../http/di.dart';
import 'open_meteo_weather_service_impl.dart';
import 'state.dart';
import 'weather_service.dart';

final meteoServiceProvider = Provider<WeatherService>((ref) {
  final meteoService = OpenMeteoWeatherServiceImpl(client: ref.read(httpClientProvider));
  return meteoService;
});

final meteoProvider = AsyncNotifierProvider<MeteoNotifier, MeteoForecast>(MeteoNotifier.new);
