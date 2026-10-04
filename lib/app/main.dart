import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/screens/weather_forecast.dart';

void main() => runApp(
  ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: WeatherForecast(),
      ),
    ),
  ),
);
