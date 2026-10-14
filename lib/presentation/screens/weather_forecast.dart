import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../../app/di.dart';
import '../../services/location/state/last_update_counter.dart';
import '../widgets/day_compose.dart';
import '../widgets/weather_now.dart';

class WeatherForecast extends ConsumerWidget {
  const WeatherForecast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherForecastProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather with flutter"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: LocationStorage(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: weather.when(
            data: (data) {
              return ListView(
                children: [
                  WeatherNow(
                    forecast: data.forecast,
                    location: weather.value!.location,
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: LastUpdateCounter(
                        location: weather.value!.location,
                        builder: (counter) => counter.when(
                          data: (data) => _lastUpdateText(data),
                          loading: () => Text('loading ...', style: TextStyle(fontSize: 10)),
                          error: (err, stack) => Text('Error: $err', style: TextStyle(fontSize: 10)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < data.forecast.length; i++) ...[DayCompose(day: data.forecast[i])],
                ],
              );
            },
            loading: () => Column(
              children: [
                Text('loading ...', style: TextStyle(fontSize: 13)),
              ],
            ),
            error: (err, stack) => Text('Error: $err'),
          ),
        ),
      ),
    );
  }

  Widget _lastUpdateText(int lastUpdate) {
    final date = DateTime(2026, 1, 1, 0, 0, lastUpdate);
    final hour = date.hour;
    if (hour != 0) return Text('last update: $hour hours ago', style: TextStyle(fontSize: 10));
    final minute = date.minute;
    if (minute != 0) return Text('last update: $minute minutes ago', style: TextStyle(fontSize: 10));
    final second = date.second;
    return Text('last update for: $second seconds ago', style: TextStyle(fontSize: 10));
  }
}
