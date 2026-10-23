import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/tools/location_time.dart';

void main() {
  // Same instant seen from three places: the wall clock must follow the location, not the device.
  final instant = DateTime.utc(2026, 1, 1, 12, 30);

  test('unknown offset falls back to the given time', () {
    final device = DateTime(2026, 1, 1, 9, 15);
    expect(locationNow(null, now: device), device);
  });

  test('positive offset (Sydney, UTC+11)', () {
    expect(locationNow(11 * 3600, now: instant), DateTime(2026, 1, 1, 23, 30));
  });

  test('negative offset (Los Angeles, UTC-8)', () {
    expect(locationNow(-8 * 3600, now: instant), DateTime(2026, 1, 1, 4, 30));
  });

  test('crosses midnight into the next day', () {
    expect(locationNow(13 * 3600, now: instant), DateTime(2026, 1, 2, 1, 30));
  });

  test('result is independent of the device zone the instant was built in', () {
    expect(locationNow(3600, now: instant.toLocal()), locationNow(3600, now: instant));
  });
}
