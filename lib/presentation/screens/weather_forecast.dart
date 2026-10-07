import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../../app/di.dart';
import '../../app/main.dart';
import '../../db/state/last_update_counter.dart';
import '../../tools/logger/log.dart';
import '../widgets/location_row.dart';

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
          child: Column(
            children: [
              LocationRow(
                location: weather.value!.location,
                onTap: () {
                  Navigator.pushNamed(context, NavigationPaths.selectLocation);
                },
              ),
              const Divider(),
              Text('active location ${weather.value?.location?.weatherUpdatedAt?.toString() ?? 'no active location'}'),
              LastUpdateCounter(
                location: weather.value!.location,
                builder: (counter) => counter.when(
                  data: (data) {
                    final date = DateTime(2026, 1, 1, 0, 0, data);
                    final hour = date.hour;
                    final minute = date.minute;
                    final second = date.second;
                    return Text('last update for: $hour:$minute:$second');
                  },
                  loading: () => Text('Loading...'),
                  error: (err, stack) => Text(''),
                ),
              ),
              Expanded(
                child: weather.when(
                  data: (data) {
                    Log.d('data length: ${data.forecast.length} ${(data.forecast.isNotEmpty) ? data.forecast.first : ''}');
                    return ListView.builder(
                      itemBuilder: (context, i) {
                        return Center(child: Text('${data.forecast[i].start} ${data.forecast[i].item.type.name}'));
                      },
                      itemCount: data.forecast.length,
                    );
                  },
                  loading: () => Column(
                    children: [
                      CircularProgressIndicator(),
                      Spacer(),
                    ],
                  ),
                  error: (err, stack) => Text('Error: $err'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Day extends StatelessWidget {
  final Widget _child;

  const Day({super.key, required this._child});

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
