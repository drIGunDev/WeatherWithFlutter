import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../types/location.dart';

final forecastLastUpdateCounter = StreamProvider.family<int, Location>((ref, location) {
  return Stream.periodic(const Duration(seconds: 1), (count) {
    final lastUpdateTime = location.weatherUpdatedAt;
    if (lastUpdateTime == null) return 0;
    final diff = DateTime.now().difference(lastUpdateTime).inSeconds;
    return diff;
  });
});
