import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_storage.dart';

import '../../app/app_state.dart';
import '../../app/main.dart';
import '../../services/db/di.dart';
import '../../services/open_weather_service/di.dart';
import '../../services/open_weather_service/weather_service.dart';
import '../widgets/location_row.dart';

class WeatherForecast extends ConsumerStatefulWidget {
  const WeatherForecast({super.key});

  @override
  ConsumerState<WeatherForecast> createState() => _WeatherForecast();
}

class _WeatherForecast extends ConsumerState<WeatherForecast> {
  @override
  void initState() {
    ref.read(locationManagerProvider).findActive().then((activeLocation) {
      if (activeLocation != null) {
        ref.read(appProvider.notifier).setLocation(activeLocation);
        ref.read(meteoProvider.notifier).fetchForecast(MeteoFetchParameters(location: activeLocation));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
