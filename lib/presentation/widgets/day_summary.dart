import 'package:flutter/material.dart';
import 'package:weather_with_flutter/app/themes.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(DateTimeFormat.dayShort(context.l10n, day.hoursForecast.first.start), style: AppTextStyles.textLarge.copyWith(fontWeight: .bold, color: AppColors.bgScaffold)),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              if (day.superior.start.millisecondsSinceEpoch < day.inferior.start.millisecondsSinceEpoch) ...[
                _supremeWeather('superior', day.superior),

                const SizedBox(height: 20),

                _supremeWeather('inferior', day.inferior),
              ] else ...[
                _supremeWeather('inferior', day.inferior),

                const SizedBox(height: 20),

                _supremeWeather('superior', day.superior),
              ],
            ],
          ),

          const SizedBox(height: 20),

          _stat(),
        ],
      ),
    );
  }

  Widget _supremeWeather(String title, Event<WeatherItem> event) {
    final item = event.item;
    final textStyle = AppTextStyles.textMedium.copyWith(fontWeight: .bold);
    return Builder(
      builder: (context) {
        final inferiorWeatherType = WeatherLabels.name(context.l10n, item.type);
        return Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Text(title, style: textStyle),

            const SizedBox(height: 5),

            Text(DateTimeFormat.time(event.start), style: textStyle),

            const SizedBox(height: 5),

            Text('${item.temperature.temperature}°', style: textStyle.copyWith(fontSize: 20)),
            WeatherEmoji(type: item.type, date: event.start, size: 40),
            item.precipitation.probabilityPercent > 0 ? Text('${item.precipitation.probabilityPercent} %', style: textStyle) : Text(''),

            const SizedBox(height: 5),

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
    final textStyle = AppTextStyles.textMedium;
    return Row(
      mainAxisAlignment: .spaceAround,
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              Text(
                '🌡️ ${minTemperature.temperature} --- ${maxTemperature.temperature}°C',
                style: textStyle,
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              Text(
                '࿐ ${minWind.toStringAsFixed(1)} --- ${maxWind.toStringAsFixed(1)} km/h',
                style: textStyle,
              ),

              const SizedBox(height: 10),

              Text(
                '༄ ${minGusts.toStringAsFixed(1)} --- ${maxGusts.toStringAsFixed(1)} km/h',
                style: textStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
