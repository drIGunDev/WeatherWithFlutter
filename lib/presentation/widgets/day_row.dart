import 'package:flutter/material.dart';
import 'package:weather_with_flutter/services/open_weather_service/types/forecast_types.dart';

import '../formatters/weathers_labels.dart';
import 'day_header.dart';

final class const DayRow({
  super.key,
  required final DayForecast day,
}) extends StatefulWidget {
  @override
  State<DayRow> createState() => _DayRowState();
}

class _DayRowState extends State<DayRow> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: DayHeader(day: widget.day),
              ),
              if (_isExpanded)
                for (var i = 0; i < widget.day.hoursForecast.length; i++) ...[
                  Text('hallo'),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
