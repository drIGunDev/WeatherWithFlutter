import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/presentation/formatters/last_update_format.dart';

void main() {
  group('formatLastUpdate', () {
    final cases = <Duration, String>{
      Duration.zero: 'last update: 0 seconds ago',
      const Duration(seconds: 1): 'last update: 1 second ago',
      const Duration(seconds: 59): 'last update: 59 seconds ago',
      const Duration(minutes: 1): 'last update: 1 minute ago',
      const Duration(minutes: 59, seconds: 59): 'last update: 59 minutes ago',
      const Duration(hours: 1): 'last update: 1 hour ago',
      const Duration(hours: 23, minutes: 59): 'last update: 23 hours ago',
      // Regression: the old DateTime-based formatting wrapped around after 24h.
      const Duration(hours: 24): 'last update: 1 day ago',
      const Duration(hours: 25): 'last update: 1 day ago',
      const Duration(days: 3): 'last update: 3 days ago',
    };

    cases.forEach((age, expected) {
      test('$age -> $expected', () => expect(formatLastUpdate(age), expected));
    });
  });
}
