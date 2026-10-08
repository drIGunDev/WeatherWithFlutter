import '../../app/main.dart';
import '../location/types/location.dart';
import 'types/forecast_types.dart';

final class WeatherForecastFetchParameters({
  required final Location location,
  final int forecastDays = AppParams.forecastDays,
  final int pastDays = AppParams.pastDays,
});

abstract interface class WeatherService {
  Future<ForecastList> fetchForecast({required WeatherForecastFetchParameters params});
}
