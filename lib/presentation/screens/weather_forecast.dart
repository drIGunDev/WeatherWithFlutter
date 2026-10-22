import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../../services/open_weather_service/state/forecast_notifier.dart';
import '../widgets/day_compose.dart';
import '../widgets/last_update_counter.dart';
import '../widgets/weather_now.dart';

class WeatherForecast extends ConsumerWidget {
  const WeatherForecast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherForecastProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather forecast with flutter", style: TextStyle(fontSize: 18, fontWeight: .normal),),
        backgroundColor: Colors.amber,
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
      backgroundColor: Colors.lightBlue,
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < data.forecast.length; i++) DayCompose(day: data.forecast[i]),
                ],
              );
            },
            loading: () => Column(
              children: [
                Text('loading ...', style: TextStyle(fontSize: 13)),
              ],
            ),
            error: (err, _) => Text('Error: $err'),
          ),
        ),
      ),
    );
  }
}
