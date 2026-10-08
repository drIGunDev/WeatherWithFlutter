import 'package:flutter/material.dart';
import 'package:weather_with_flutter/services/open_weather_service/types/forecast_types.dart';

import '../../app/themes.dart';
import '../../l10n/l10n_context.dart';
import '../../services/location/types/location.dart';
import '../../services/open_weather_service/types/event.dart';
import '../../services/open_weather_service/types/weather_item.dart';
import '../formatters/weathers_labels.dart';

class const TodaySummary({
  super.key,
  required final DaysForecast _forecast,
  required final Location? _location,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todayForecast = _forecast.first;
    final currentWeather = _getCurrentWeather(todayForecast);
    final weatherEmoji = currentWeather != null ? _getWeatherEmoji(currentWeather) : null;
    final (min, max) = _getMinMaxTemperature(todayForecast);
    final weatherType = currentWeather != null ? WeatherLabels.name(context.l10n, currentWeather.item.type) : null;
    final temperature = currentWeather != null ? currentWeather.item.temperature.temperature.toString() : '';
    return Column(
      children: [
        const SizedBox(height: 20),
        if (_location != null) ...[
          Text(
            _location.name,
            style: TextStyle(fontSize: AppFontSizes.extraLarge, fontWeight: FontWeight.bold),
          ),
        ],
        const SizedBox(height: 10),
        if (weatherEmoji != null) ...[
          Text(
            weatherEmoji,
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
          ),
        ],
        const SizedBox(height: 10),
        if (currentWeather != null) ...[
          Text(
            weatherType ?? currentWeather.item.type.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
        const SizedBox(height: 10),
        if (currentWeather != null) ...[
          Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                '$temperature°',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    'min: $min°',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'max: $max°',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  Event<WeatherItem>? _getCurrentWeather(DayForecast day) {
    if (day.hoursForecast.isEmpty) return null;
    final currentHour = DateTime.now().hour;
    var item = day.hoursForecast.first;
    for (var i = 1; i < day.hoursForecast.length; i++) {
      final hour = day.hoursForecast[i];
      if (hour.start.hour > currentHour) {
        item = day.hoursForecast[i - 1];
        break;
      }
    }
    return item;
  }

  String _getWeatherEmoji(Event<WeatherItem> item) {
    final weatherType = item.item.type;
    final date = item.start;
    return WeatherLabels.emojiForHour(weatherType, date.hour);
  }

  (double, double) _getMinMaxTemperature(DayForecast day) {
    final min = day.hoursForecast.fold(
      double.maxFinite,
      (prev, element) => element.item.temperature.temperature < prev ? element.item.temperature.temperature : prev,
    );
    final max = day.hoursForecast.fold(
      double.minPositive,
      (prev, element) => element.item.temperature.temperature > prev ? element.item.temperature.temperature : prev,
    );
    return (min, max);
  }
}
