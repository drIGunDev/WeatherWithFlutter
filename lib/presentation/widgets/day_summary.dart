import 'package:flutter/material.dart';

import '../../l10n/l10n_context.dart';
import '../../services/open_weather_service/types/forecast_types.dart';
import '../formatters/date_time_format.dart';
import '../formatters/weathers_labels.dart';
import 'weather_emoji.dart';

class const DaySummary({
  super.key,
  required final DayForecast day,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: double.infinity,
        padding: .all(5),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        color: Colors.transparent,
        child: _DayRow(day: day),
      ),
    );
  }
}

class const _DayRow({
  super.key,
  required final DayForecast day,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final date = day.hoursForecast.first.start;
    final inferior = day.inferior();
    final weatherType = WeatherLabels.name(context.l10n, inferior.type);
    final minTemperature = day.minTemperature();
    final maxTemperature = day.maxTemperature();
    final minWind = day.minWind();
    final maxWind = day.maxWind();
    final textStyle = TextStyle(fontSize: 14, fontWeight: .bold, color: Colors.white);
    return Row(
      children: [
        Column(
          children: [
            Text(DateTimeFormat.dayShort(context.l10n, date), style: TextStyle(fontSize: 14, fontWeight: .bold)),
            WeatherEmoji(type: inferior.type, date: date, size: 40),
            Text('${inferior.precipitation.amountMm} %', style: textStyle),
            Text(weatherType, style: textStyle),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 120,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '🌡️ min: ${minTemperature.temperature}°, max: ${maxTemperature.temperature}°',
                  style: textStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  '༄ min: ${minWind.toStringAsFixed(1)} km/h, max: ${maxWind.toStringAsFixed(1)} km/h',
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
