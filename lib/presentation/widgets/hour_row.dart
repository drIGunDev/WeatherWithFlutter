import 'package:flutter/material.dart';

import '../../l10n/l10n_context.dart';
import '../../services/open_weather_service/types/event.dart';
import '../../services/open_weather_service/types/weather_item.dart';
import '../formatters/date_time_format.dart';
import '../formatters/weathers_labels.dart';
import 'weather_emoji.dart';

class const HourRow({super.key, required final Event<WeatherItem> event}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = event.item;
    final weatherType = WeatherLabels.name(context.l10n, item.type);
    final textStyle = TextStyle(fontSize: 14, fontWeight: .bold, color: Colors.white);
    return Row(
      mainAxisAlignment: .spaceAround,
      children: [
        Text(DateTimeFormat.time(event.start), style: textStyle),
        Column(
          children: [
            WeatherEmoji(type: event.item.type, date: event.start, size: 40),
            if (item.precipitation.probabilityPercent > 0) Text('${item.precipitation.probabilityPercent} %', style: textStyle),
            Text(weatherType, style: textStyle),
          ],
        ),
        Text('${item.temperature.temperature}°', style: textStyle),
        Text('${item.wind.forceKmPerHour} km/h', style: textStyle),
      ],
    );
  }
}
