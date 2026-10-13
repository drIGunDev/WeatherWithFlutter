import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../../app/di.dart';
import '../../app/main.dart';
import '../../services/location/state/last_update_counter.dart';
import '../../tools/logger/log.dart';
import '../widgets/location_row.dart';
import '../widgets/day_row.dart';
import '../widgets/today_summary.dart';

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
        child: SingleChildScrollView(
          child: Center(
            child: weather.when(
              data: (data) {
                return Column(
                  children: [
                    TodaySummary(
                      forecast: data.forecast,
                      location: weather.value!.location,
                    ),
            
                    const SizedBox(height: 5),
            
                    LastUpdateCounter(
                      location: weather.value!.location,
                      builder: (counter) => counter.when(
                        data: (data) => _lastUpdateText(data),
                        loading: () => Text('loading ...'),
                        error: (err, stack) => Text('Error: $err'),
                      ),
                    ),
            
                    const SizedBox(height: 10),
            
                    // Expanded(
                    //   child:
                    //   ListView.builder(
                    //     itemBuilder: (context, i) {
                    //       return RowDay(day: data.forecast[i]);
                    //     },
                    //     itemCount: data.forecast.length,
                    //   ),
                    // ),
                    for (var i = 0; i < data.forecast.length; i++) ...[DayRow(day: data.forecast[i])],
                  ],
                );
              },
              loading: () => Column(
                children: [
                  Text('loading ...', style: TextStyle(fontSize: 13)),
                  // Spacer(),
                ],
              ),
              error: (err, stack) => Text('Error: $err'),
            ),
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
