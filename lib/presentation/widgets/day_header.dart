import 'package:flutter/material.dart';

import '../../services/open_weather_service/types/forecast_types.dart';
import '../formatters/weathers_labels.dart';

class const DayHeader({
  super.key,
  required final DayForecast day,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final date = day.hoursForecast.first.start;
    final weatherType = day.hoursForecast.first.item.type;
    final weatherEmoji = WeatherLabels.emojiForHour(weatherType, date.hour);
    return Container(
      width: double.infinity,
      height: 50,
      padding: .all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('$weatherEmoji!: ${day.hoursForecast[0].start} ${day.hoursForecast[0].item.type.name}'),
    );
  }
}
