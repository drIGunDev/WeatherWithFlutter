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
    final buff = StringBuffer()
      ..write('WeatherItem(type: $type, ')
      ..write('temperature: $temperature, ')
      ..write('apparentTemperature: $apparentTemperature, ')
      ..write('precipitation: $precipitation, ')
      ..write('wind: $wind, ')
      ..write('location: $location)');
    return buff.toString();
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
