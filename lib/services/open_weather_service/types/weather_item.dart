import '../../location/types/location.dart';
import 'precipitation.dart';
import 'temperature.dart';
import 'weather_type.dart';
import 'wind.dart';

final class WeatherItem implements GeoLocatable {
  final WeatherType type;
  final Temperature temperature;
  final Temperature apparentTemperature;
  final Precipitation precipitation;
  final Wind wind;

  @override
  final Location location;

  const WeatherItem({
    required this.type,
    required this.temperature,
    required this.apparentTemperature,
    required this.precipitation,
    required this.wind,
    required this.location,
  });

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
