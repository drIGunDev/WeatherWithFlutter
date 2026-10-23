import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../db/manager/database_manager_impl.dart';
import '../db/manager/forecast_manager.dart';
import '../db/manager/location_manager.dart';
import '../db/weather_db.dart';
import '../services/location/geocoding_service.dart';
import '../services/location/open_meteo_geocoding_service_impl.dart';
import '../services/location/state/geocoding_notifier.dart';
import '../services/open_weather_service/open_meteo_weather_service_impl.dart';
import '../services/open_weather_service/weather_service.dart';

///
/// Http client
///
final httpClientComponent = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(() => client.close());
  return client;
});

///
/// Geocoding service
///
final geocodingServiceComponent = Provider<GeocodingService>((ref) {
  return OpenMeteoGeocodingServiceImpl(client: ref.read(httpClientComponent));
});

final geocodingProvider = AsyncNotifierProvider<GeocodingNotifier, GeocodingState>(GeocodingNotifier.new);

///
/// Weather service
///
final meteoServiceComponent = Provider<WeatherService>((ref) {
  return OpenMeteoWeatherServiceImpl(client: ref.read(httpClientComponent));
});

///
/// Database
///
final weatherDatabaseComponent = Provider<WeatherDatabase>((ref) {
  final database = WeatherDatabase();
  ref.onDispose(() => database.close());
  return database;
});

final locationManagerComponent = Provider<LocationManager>((ref) {
  return DatabaseManagerImpl(database: ref.read(weatherDatabaseComponent));
});

final forecastManagerComponent = Provider<ForecastManager>((ref) {
  return DatabaseManagerImpl(database: ref.read(weatherDatabaseComponent));
});
