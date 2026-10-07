import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../presentation/screens/location_selecting.dart';
import '../presentation/screens/weather_forecast.dart';
import '../services/db/di.dart';
import '../services/open_weather_service/di.dart';
import '../services/open_weather_service/weather_service.dart';

abstract interface class NavigationPaths {
  static const String root = '/';
  static const String locationStorage = '/location_storage';
  static const String selectLocation = '/select_location';
}

abstract interface class AppParams {
  static const int updateIntervalSec = 60 * 60;
}

Future<void> initializing(WidgetRef ref) async {
  final activeLocation = await ref.read(locationDatabaseProvider).findActive();
  if (activeLocation != null) {
    await ref.read(meteoProvider.notifier).fetchForecast(params: MeteoFetchParameters(location: activeLocation));
  }
}

void main() => runApp(
  ProviderScope(
    child: Consumer(
      builder: (context, ref, _) {
        initializing(ref);
        return MaterialApp(
          initialRoute: NavigationPaths.root,
          routes: {
            NavigationPaths.root: (context) => WeatherForecast(),
            NavigationPaths.locationStorage: (context) => LocationStorage(),
            NavigationPaths.selectLocation: (context) => LocationSelecting(),
          },
        );
      },
    ),
  ),
);
