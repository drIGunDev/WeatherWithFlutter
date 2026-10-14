import 'event.dart';
import 'temperature.dart';
import 'weather_item.dart';

typedef ForecastList = List<Event<WeatherItem>>;

final class DayForecast({
  required final ForecastList hoursForecast,
});

typedef DaysForecast = List<DayForecast>;

extension Infarior on DayForecast {
  WeatherItem inferior() => hoursForecast.reduce((value, element) => value.item.type.type > element.item.type.type ? value : element).item;

  Temperature minTemperature() =>
      hoursForecast.reduce((value, element) => value.item.temperature.celsius < element.item.temperature.celsius ? value : element).item.temperature;

  Temperature maxTemperature() =>
      hoursForecast.reduce((value, element) => value.item.temperature.celsius > element.item.temperature.celsius ? value : element).item.temperature;
}

extension ToDaysForecast on ForecastList {
  DaysForecast toDaysForecast() {
    if (isEmpty) {
      return [];
    }

    final result = DaysForecast.empty(growable: true);
    var hours = ForecastList.empty(growable: true);
    DateTime? yesterday;

    for (var i = 0; i < length; i++) {
      final event = this[i];
      final day = event.start.day;
      if (yesterday == null) {
        yesterday = event.start;
        hours.add(event);
      } else if (yesterday.day == day) {
        hours.add(event);
      } else {
        result.add(DayForecast(hoursForecast: hours));
        hours = ForecastList.empty(growable: true);
        yesterday = event.start;
        hours.add(event);
      }
      if (i == length - 1) {
        if (hours.isNotEmpty) result.add(DayForecast(hoursForecast: hours.toList()));
      }
    }
    return result;
  }
}
