import '../location/types/location.dart';
import 'types/event.dart';
import 'types/weather_item.dart';

typedef MeteoResult = List<Event<WeatherItem>>;

final class MeteoFetchParameters({
  required final Location location,
  final int forecastDays = 10,
  final int pastDays = 0,
});

abstract interface class WeatherService {
  Future<MeteoResult> fetchForecast({required MeteoFetchParameters params});
}
