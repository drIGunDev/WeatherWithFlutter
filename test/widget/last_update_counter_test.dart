import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_with_flutter/presentation/widgets/last_update_counter.dart';
import 'package:weather_with_flutter/services/location/state/last_update_counter.dart';

import 'support/widget_helpers.dart';

void main() {
  testWidgets('shows the age of the forecast', (tester) async {
    await pumpApp(
      tester,
      LastUpdateCounter(location: sydney),
      // The real provider ticks every second via a Timer; a fixed stream keeps the test deterministic.
      overrides: [forecastLastUpdateCounter.overrideWith((ref, location) => Stream.value(125))],
    );
    await tester.pump(); // let the stream deliver its value

    expect(find.text('last update: 2 minutes ago'), findsOneWidget);
  });

  testWidgets('renders nothing without a location', (tester) async {
    await pumpApp(tester, const LastUpdateCounter(location: null));

    expect(find.byType(Text), findsNothing);
  });
}
