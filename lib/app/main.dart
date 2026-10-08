import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../l10n/app_localizations.dart';
import '../presentation/screens/location_selecting.dart';
import '../presentation/screens/weather_forecast.dart';
import '../services/open_weather_service/weather_service.dart';
import 'di.dart';

abstract interface class NavigationPaths {
  static const String root = '/';
  static const String locationStorage = '/location_storage';
  static const String selectLocation = '/select_location';
}

abstract interface class AppParams {
  static const int updateIntervalSec = 60 * 60;
  static const int forecastDays = 10;
  static const int pastDays = 0;
}

Future<void> initializing(WidgetRef ref) async {
  final locationManager = ref.read(locationDatabaseProvider);
  final activeLocation = await locationManager.findActiveLocation();
  if (activeLocation != null) {
    final forecastProvider = ref.read(weatherForecastProvider.notifier);
    await forecastProvider.fetchForecast(params: WeatherForecastFetchParameters(location: activeLocation));
  }
}

void main() => runApp(
  ProviderScope(
    child: Consumer(
      builder: (context, ref, _) {
        unawaited(initializing(ref));
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
