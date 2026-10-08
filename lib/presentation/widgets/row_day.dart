import 'package:flutter/material.dart';
import 'package:weather_with_flutter/services/open_weather_service/types/forecast_types.dart';

import '../formatters/weathers_labels.dart';

final class const RowDay({
  super.key,
  required final DayForecast day,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    day.hoursForecast[0].item.type;
    final date = day.hoursForecast.first.start;
    final weatherType = day.hoursForecast.first.item.type;
    final weatherEmoji = WeatherLabels.emojiForHour(weatherType, date.hour);
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Text('$weatherEmoji!: ${day.hoursForecast[0].start} ${day.hoursForecast[0].item.type.name}'),
      ),
    );
  }
}
