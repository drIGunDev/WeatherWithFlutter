import '../location/types/location.dart';
import 'types/event.dart';
import 'types/weather_item.dart';

typedef MeteoForecast = List<Event<WeatherItem>>;

final class MeteoFetchParameters({
  required final Location location,
  final int forecastDays = 10,
  final int pastDays = 0,
});

abstract interface class WeatherService {
  Future<MeteoForecast> fetchForecast({required MeteoFetchParameters params});
}
