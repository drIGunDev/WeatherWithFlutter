import 'package:flutter/material.dart';

import '../../services/open_weather_service/types/forecast_types.dart';
import 'hour_row.dart';

class const DayHours({
  super.key,
  required final DayForecast day,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final headerTextStyle = TextStyle(fontSize: 14, fontWeight: .bold, color: Colors.white);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.lightBlueAccent,
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: .spaceAround,
              children: [
                Text('Time', style: headerTextStyle),
                Text('Weather', style: headerTextStyle),
                Text('Temperature°', style: headerTextStyle),
                Text('Wind km/h', style: headerTextStyle),
              ],
            ),
          ),
        ),
        for (var i = 0; i < day.hoursForecast.length; i++) ...[
          HourRow(event: day.hoursForecast[i]),
          if (i < day.hoursForecast.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.grey.shade300),
            ),
        ],
      ],
    );
  }
}
