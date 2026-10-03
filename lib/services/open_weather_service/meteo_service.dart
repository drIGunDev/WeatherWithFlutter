import 'types/event.dart';
import '../location/types/location.dart';
import 'types/weather_item.dart';

abstract interface class MeteoService {
  Future<List<Event<WeatherItem>>> fetchForecast({
    required Location location,
    required int forecastDays,
    required int pastDays,
  });
}
