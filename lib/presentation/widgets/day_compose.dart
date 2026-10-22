import 'package:flutter/material.dart';
import 'package:weather_with_flutter/services/open_weather_service/types/forecast_types.dart';

import '../../app/themes.dart';
import 'day_hours.dart';
import 'day_summary.dart';

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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: Card(
          color: AppColors.bgWeatherCard,
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: Colors.blue,
                  splashColor: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: DaySummary(day: widget.day),
                ),
              ),
              if (_isExpanded) DayHours(day: widget.day),
            ],
          ),
        ),
      ),
    );
  }
}
