import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../app/main.dart';
import '../../services/db/di.dart';
import '../../services/location/di.dart';
import '../../services/location/geocoding_service.dart';
import '../../app/themes.dart';
import '../../services/open_weather_service/di.dart';
import '../../services/open_weather_service/weather_service.dart';
import '../widgets/location_row.dart';

class SelectLocation extends ConsumerStatefulWidget {
  const SelectLocation({super.key});

  @override
  ConsumerState<SelectLocation> createState() => _GeocodingState();
}

class _GeocodingState extends ConsumerState<SelectLocation> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set location',
          style: TextStyle(fontSize: AppFontSizes.extraLarge, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.large),
          children: [
            Text(
              'Search city or place',
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: FontWeight.normal,
                color: AppColors.descriptionText,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _query,
              decoration: const InputDecoration(
                hintText: 'City',
              ),
              autofocus: true,
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final name = _query.text;
                ref.read(geocodingProvider.notifier).fetchLocations(GeocodingFetchParameters(name: name, count: 20));
              },
              child: Text('Search'),
            ),

            const SizedBox(height: 25),

            Builder(
              builder: (context) {
                final locations = ref.watch(geocodingProvider);
                return locations.when(
                  data: (data) {
                    return Column(
                      crossAxisAlignment: .start,
                      children: [
                        if (data.result.isNotEmpty)
                          Text(
                            'Select a location'.toUpperCase(),
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColors.descriptionText,
                            ),
                          ),

                        const SizedBox(height: 16),

                        for (final location in data.result) ...[LocationRow(location: location,
                          onTap: () {
                            ref.read(locationStorageProvider.notifier).add(location: location);
                            ref.read(meteoProvider.notifier).fetchForecast(MeteoFetchParameters(location: location));
                            ref.read(appProvider.notifier).setLocation(location);

                            Navigator.pushReplacementNamed(context, NavigationPaths.root);

                            ref.read(geocodingProvider.notifier).reset();
                          },)
                        ],
                      ],
                    );
                  },
                  loading: () => Center(child: const CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

///
/// Test geocoding service
///
void main() => runApp(
  ProviderScope(
    child: MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgSurface,
      ),
      home: const SelectLocation(),
    ),
  ),
);
