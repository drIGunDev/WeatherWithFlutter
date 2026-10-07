import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/types/location.dart';

final forecastLastUpdateCounter = StreamProvider.family<int, Location>((ref, location) {
  return Stream.periodic(const Duration(seconds: 1), (count) {
    final lastUpdateTime = location.weatherUpdatedAt;
    if (lastUpdateTime == null) return 0;
    final diff = DateTime.now().difference(lastUpdateTime).inSeconds;
    return diff;
  });
});

final class const LastUpdateCounter({
  super.key,
  required final Location? location,
  required final Widget Function(AsyncValue<int> counter) builder,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (location == null) return const SizedBox();
    return builder(ref.watch(forecastLastUpdateCounter(location!)));
  }
}

///
/// test last update counter
///
final berlin = Location(
  id: '1',
  name: 'Berlin',
  latitude: 0,
  longitude: 0,
  country: '',
  countryCode: '',
  city: '',
  timezone: '',
  weatherUpdatedAt: DateTime.now(),
);

void main() => runApp(
  ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: Center(
          child: LastUpdateCounter(
            location: berlin,
            builder: (counter) => counter.when(
              data: (data) => Text(data.toString()),
              loading: () => Text('Loading...'),
              error: (err, stack) => Text(''),
            ),
          ),
        ),
      ),
    ),
  ),
);
