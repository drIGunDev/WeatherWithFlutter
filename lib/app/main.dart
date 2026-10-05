import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../presentation/screens/select_location.dart';
import '../presentation/screens/weather_forecast.dart';

abstract interface class NavigationPaths {
  static const String root = '/';
  static const String locationStorage = '/location_storage';
  static const String selectLocation = '/select_location';
}

void main() => runApp(
  ProviderScope(
    child: MaterialApp(
      initialRoute: NavigationPaths.root,
      routes: {
        NavigationPaths.root : (context) => WeatherForecast(),
        NavigationPaths.locationStorage : (context) => LocationStorage(),
        NavigationPaths.selectLocation : (context) => SelectLocation(),
      },
    ),
  ),
);
