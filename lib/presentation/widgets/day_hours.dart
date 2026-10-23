import 'package:flutter/material.dart';
import 'package:weather_with_flutter/app/themes.dart';

import '../../services/open_weather_service/types/forecast_types.dart';
import '../../tools/location_time.dart';
import 'hour_row.dart';

class const DayHours({
  super.key,
  required final DayForecast day,
  required final int? utcOffsetSeconds,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = locationNow(utcOffsetSeconds);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.lightBlueAccent,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: _tableHeader(),
          ),
        ),
        for (var i = 0; i < day.hoursForecast.length; i++) ...[
          if (day.hoursForecast[i].start.millisecondsSinceEpoch >= now.millisecondsSinceEpoch - 3600000) ...[
            HourRow(event: day.hoursForecast[i]),
            if (i < day.hoursForecast.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Divider(thickness: 0.5),
              ),
          ],
        ],

        const SizedBox(height: 15),
      ],
    );
  }

  Widget _tableHeader() {
    final headerTextStyle = AppTextStyles.textMedium.copyWith(fontWeight: .bold);
    return Row(
      mainAxisAlignment: .spaceAround,
      children: [
        Text('Time', style: headerTextStyle),
        Text('Weather', style: headerTextStyle),
        Text('Temp.', style: headerTextStyle),
        Text('Wind', style: headerTextStyle),
      ],
    );
  }
}
