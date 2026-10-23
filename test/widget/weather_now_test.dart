import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/presentation/widgets/weather_now.dart';
import 'package:weather_with_flutter/tools/location_time.dart';

import 'support/widget_helpers.dart';

void main() {
  testWidgets('shows the location name and the day min/max', (tester) async {
    final day = dayOf(DateTime(2026, 1, 1));

    await pumpApp(tester, WeatherNow(forecast: [day], location: sydney));

    expect(find.text('Sydney'), findsOneWidget);
    expect(find.text('min: 0.5°'), findsOneWidget);
    expect(find.text('max: 23.5°'), findsOneWidget);
  });

  // Regression test for the "weather follows the phone's clock" bug: the same device
  // instant must give different "current" hours for locations in different time zones.
  testWidgets('current temperature follows the time at the location, not on the device', (tester) async {
    for (final offsetHours in [11, -8]) {
      final location = sydney.copyWith(utcOffsetSeconds: offsetHours * 3600);
      final hourAtLocation = locationNow(location.utcOffsetSeconds).hour;

      await pumpApp(tester, WeatherNow(forecast: [dayOf(DateTime(2026, 1, 1), location: location)], location: location));

      // Hour `h` has temperature `h + 0.5`; the widget must pick the hour that is "now" at the location.
      expect(find.text('${hourAtLocation + 0.5}°'), findsOneWidget, reason: 'UTC${offsetHours >= 0 ? '+' : ''}$offsetHours');
    }
  });
}
