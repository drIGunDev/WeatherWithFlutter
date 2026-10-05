import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/presentation/screens/select_location.dart';
import 'package:weather_with_flutter/presentation/widgets/location_row.dart';

import '../../app/app_state.dart';
import '../../app/main.dart';
import '../../services/db/di.dart';
import '../../services/location/di.dart';
import '../../services/open_weather_service/di.dart';
import '../../services/open_weather_service/weather_service.dart';

class LocationStorage extends ConsumerStatefulWidget {
  const LocationStorage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationStorage();
}

class _LocationStorage extends ConsumerState<LocationStorage> {
  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationStorageProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Expanded(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/select_location'),
                child: const Text('Add location'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: locations.when(
                  data: (data) {
                    if (data.locations.isEmpty) {
                      return const Text('No locations');
                    }
                    return ListView(
                      children: data.locations.map((location) {
                        return LocationRow(
                          location: location,
                          onTap: () {
                            ref.read(locationStorageProvider.notifier).add(location: location);
                            ref.read(meteoProvider.notifier).fetchForecast(MeteoFetchParameters(location: location));
                            ref.read(appProvider.notifier).setLocation(location);
                            Navigator.pushReplacementNamed(context, NavigationPaths.root);
                          },
                          onDelete: () {
                            ref.read(locationStorageProvider.notifier).remove(location: location);
                            ref.read(geocodingProvider.notifier).reset();
                            if (data.locations.length == 1) {
                              ref.read(appProvider.notifier).setLocation(null);
                              ref.read(meteoProvider.notifier).reset();
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
        NavigationPaths.selectLocation: (context) => SelectLocation(),
      },
    ),
  ),
);

Widget _prepareLocationStorage() {
  return Scaffold(
    body: LocationStorage(),
  );
}
