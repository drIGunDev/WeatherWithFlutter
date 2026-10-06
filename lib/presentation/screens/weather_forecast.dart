import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../../app/app_notifier.dart';
import '../../app/main.dart';
import '../../services/open_weather_service/di.dart';
import '../../tools/logger/log.dart';
import '../widgets/location_row.dart';

class WeatherForecast extends ConsumerWidget {
  const WeatherForecast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final weather = ref.watch(meteoProvider);

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
                location: state.location,
                onTap: () {
                  Navigator.pushNamed(context, NavigationPaths.selectLocation);
                },
              ),
              Expanded(
                child: weather.when(
                  data: (data) {
                    Log.d('data length: ${data.length} ${(data.isNotEmpty) ? data.first : ''}');
                    return ListView.builder(
                      itemBuilder: (context, i) {
                        return Center(child: Text('${data[i].start} ${data[i].item.type.name}'));
                      },
                      itemCount: data.length,
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
