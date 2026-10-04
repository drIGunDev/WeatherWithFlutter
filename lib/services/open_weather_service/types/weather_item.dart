import '../../location/types/location.dart';
import 'precipitation.dart';
import 'temperature.dart';
import 'weather_type.dart';
import 'wind.dart';

final class const WeatherItem({
  required final WeatherType type,
  required final Temperature temperature,
  required final Temperature apparentTemperature,
  required final Precipitation precipitation,
  required final Wind wind,
  @override required final location,
}) implements GeoLocatable {
  @override
  String toString() {
    return 'WeatherItem{type: $type, temperature: $temperature, apparentTemperature: $apparentTemperature, precipitation: $precipitation, wind: $wind location: $location}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherItem &&
        other.type == type &&
        other.temperature == temperature &&
        other.apparentTemperature == apparentTemperature &&
        other.precipitation == precipitation &&
        other.wind == wind &&
        other.location == location;
  }

  @override
  int get hashCode {
    return type.hashCode ^ temperature.hashCode ^ apparentTemperature.hashCode ^ precipitation.hashCode ^ wind.hashCode ^ location.hashCode;
  }
}
