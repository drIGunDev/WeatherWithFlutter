import '../../app/app_config.dart';
import '../location/types/location.dart';
import 'types/forecast_types.dart';

final class WeatherForecastFetchParameters({
  required final Location location,
  final int forecastDays = AppParams.forecastDays,
  final int pastDays = AppParams.pastDays,
});

final class CommunicationError([final String? message]) implements Exception {
  @override
  String toString() {
    return 'CommunicationError: $message';
  }
}

abstract interface class WeatherService {
  Future<ForecastList> fetchForecast({required WeatherForecastFetchParameters params});
}
