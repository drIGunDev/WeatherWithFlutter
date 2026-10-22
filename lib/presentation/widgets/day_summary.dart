import 'package:flutter/material.dart';

import '../../l10n/l10n_context.dart';
import '../../services/open_weather_service/types/event.dart';
import '../../services/open_weather_service/types/forecast_types.dart';
import '../../services/open_weather_service/types/weather_item.dart';
import '../formatters/date_time_format.dart';
import '../formatters/weathers_labels.dart';
import 'weather_emoji.dart';

class const DaySummary({
  super.key,
  required final DayForecast day,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 14, fontWeight: .bold, color: Colors.white);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(DateTimeFormat.dayShort(context.l10n, day.hoursForecast.first.start), style: textStyle),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              if (day.superior.start.millisecondsSinceEpoch < day.inferior.start.millisecondsSinceEpoch) ...[
                _supremeWeather(day.superior),
                const SizedBox(height: 20),
                _supremeWeather(day.inferior),
              ] else ...[
                _supremeWeather(day.inferior),
                const SizedBox(height: 20),
                _supremeWeather(day.superior),
              ],
            ],
          ),
          const SizedBox(height: 20),
          _stat(),
        ],
      ),
    );
  }

  Widget _supremeWeather(Event<WeatherItem> event) {
    final item = event.item;
    final textStyle = TextStyle(fontSize: 14, fontWeight: .bold, color: Colors.white);
    return Builder(
      builder: (context) {
        final inferiorWeatherType = WeatherLabels.name(context.l10n, item.type);
        return Column(
          children: [
            Text(DateTimeFormat.time(event.start), style: textStyle),
            WeatherEmoji(type: item.type, date: event.start, size: 40),
            if (item.precipitation.probabilityPercent > 0) Text('${item.precipitation.probabilityPercent} %', style: textStyle),
            Text(inferiorWeatherType, style: textStyle),
          ],
        );
      },
    );
  }

  Widget _stat() {
    final minTemperature = day.minTemperature;
    final maxTemperature = day.maxTemperature;
    final minWind = day.minWind;
    final maxWind = day.maxWind;
    final maxGusts = day.maxGusts;
    final minGusts = day.minGusts;
    final textStyle = TextStyle(fontSize: 11, color: Colors.white);
    return Row(
      mainAxisAlignment: .spaceAround,
      crossAxisAlignment: .start,
      children: [
        Column(
          children: [
            Text(
              '🌡️ min: ${minTemperature.temperature}°, max: ${maxTemperature.temperature}°',
              style: textStyle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              '࿐ min: ${minWind.toStringAsFixed(1)} km/h, max: ${maxWind.toStringAsFixed(1)} km/h',
              style: textStyle,
            ),
            const SizedBox(height: 10),
            Text(
              '༄ min: ${minGusts.toStringAsFixed(1)} km/h, max: ${maxGusts.toStringAsFixed(1)} km/h',
              style: textStyle,
            ),
          ],
        ),
      ],
    );
  }
}
