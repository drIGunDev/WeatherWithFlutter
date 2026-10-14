import 'package:flutter/material.dart';
import 'package:weather_with_flutter/services/open_weather_service/types/forecast_types.dart';

import 'day_summary.dart';
import 'hour_row.dart';

final class const DayCompose({
  super.key,
  required final DayForecast day,
}) extends StatefulWidget {
  @override
  State<DayCompose> createState() => _DayComposeState();
}

class _DayComposeState extends State<DayCompose> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = TextStyle(fontSize: 14, fontWeight: .bold, color: Colors.white);
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Column(
            children: [
              InkWell(
                // hoverColor: Colors.transparent,
                highlightColor: Colors.blue,
                splashColor: Colors.blue,
                // overlayColor: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(5),
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: DaySummary(day: widget.day),
              ),
              if (_isExpanded) ...[
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
              ],
              if (_isExpanded)
                for (var i = 0; i < widget.day.hoursForecast.length; i++) ...[
                  HourRow(event: widget.day.hoursForecast[i]),
                  if (i < widget.day.hoursForecast.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(color: Colors.grey.shade300),
                    ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
