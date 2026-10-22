import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/themes.dart';
import '../../services/location/state/last_update_counter.dart';
import '../../services/location/types/location.dart';

final class const LastUpdateCounter({
  super.key,
  required final Location? location,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (location == null) return const SizedBox();

    return _lastUpdateCounterBuilder(ref.watch(forecastLastUpdateCounter(location!)));
  }
}

Widget _lastUpdateCounterBuilder(AsyncValue<int> counter) {
  return counter.when(
    data: (data) => _lastUpdateText(data),
    loading: () => Text('loading ...', style: AppTextStyles.textSmall),
    error: (err, stack) => Text('Error: $err', style: AppTextStyles.textSmall),
  );
}

Widget _lastUpdateText(int lastUpdate) {
  final textColor = Colors.white;
  final date = DateTime(2026, 1, 1, 0, 0, lastUpdate);
  final hour = date.hour;
  if (hour != 0) return Text('last update: $hour hours ago', style: AppTextStyles.textSmall);
  final minute = date.minute;
  if (minute != 0) return Text('last update: $minute minutes ago', style: AppTextStyles.textSmall);
  final second = date.second;
  return Text('last update for: $second seconds ago', style: AppTextStyles.textSmall);
}
