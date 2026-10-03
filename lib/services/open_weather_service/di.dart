import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di.dart';
import 'meteo_service.dart';
import 'open_meteo_weather_service_impl.dart';

final meteoServiceProvider = Provider<MeteoService>((ref) {
  final meteoService = OpenWeatherServiceImpl(client: ref.read(httpClientProvider));
  return meteoService;
});
