import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/location_selection.dart';
import 'package:weather_with_flutter/presentation/widgets/location_row.dart';

import '../../app/di.dart';
import '../../app/main.dart';
import '../../services/location/state/location_storage_notifier.dart';
import '../../services/open_weather_service/state/forecast_notifier.dart';
import '../../services/open_weather_service/weather_service.dart';

class const LocationStorage({super.key}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationStorageProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, NavigationPaths.selectLocation),
              child: const Text('Add location'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: locations.when(
                data: (data) {
                  return ListView(
                    children: data.locations.map((location) {
                      return LocationRow(
                        location: location,
                        onTap: () async {
                          Navigator.pushReplacementNamed(context, NavigationPaths.root);

                          await ref.read(locationStorageProvider.notifier).setLocationActive(location: location);
                          await ref.read(weatherForecastProvider.notifier).fetchForecast(params: WeatherForecastFetchParameters(location: location));
                        },
                        onDelete: () async {
                          await ref.read(locationStorageProvider.notifier).remove(location: location);
                          final results = await ref.read(locationStorageProvider.future);
                          if (results.locations.isEmpty) {
                            await ref.read(weatherForecastProvider.notifier).delete(location: location);
                            return;
                          }
                          final activeLocation = results.activeLocation;
                          if (activeLocation != null) {
                            await ref
                                .read(weatherForecastProvider.notifier)
                                .fetchForecast(params: WeatherForecastFetchParameters(location: activeLocation));
                          }
                        },
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// test location storage
///
void main() => runApp(
  ProviderScope(
    child: MaterialApp(
      initialRoute: NavigationPaths.root,
      routes: {
        NavigationPaths.root: (context) => _prepareLocationStorage(),
        NavigationPaths.locationStorage: (context) => _prepareLocationStorage(),
        NavigationPaths.selectLocation: (context) => LocationSelection(),
      },
    ),
  ),
);

Widget _prepareLocationStorage() {
  return Scaffold(
    body: LocationStorage(),
  );
}
