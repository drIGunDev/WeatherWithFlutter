import '../../app/main.dart';
import '../location/types/location.dart';
import 'types/event.dart';
import 'types/weather_item.dart';

typedef ForecastList = List<Event<WeatherItem>>;

final class WeatherForecastFetchParameters({
  required final Location location,
  final int forecastDays = AppParams.forecastDays,
  final int pastDays = AppParams.pastDays,
});

abstract interface class WeatherService {
  Future<ForecastList> fetchForecast({required WeatherForecastFetchParameters params});
}
