import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../services/location/types/location.dart';
import '../../services/open_weather_service/di.dart';
import 'select_location.dart';

class WeatherForecast extends ConsumerWidget {
  const WeatherForecast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final weather = ref.watch(meteoProvider);

    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Riverpod Demo"),
          ),
          body: Center(
            child: _SelectBlock(
              location: state.location,
              child: Expanded(
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
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectBlock extends StatelessWidget {
  final Widget _child;
  final Location _location;

  const _SelectBlock({super.key, required this._location, required this._child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("name: ${_location.name}, country: ${_location.country}, city: ${_location.city}"),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectLocation(),
            ),
          ),
          child: Text('Select location'),
        ),
        SizedBox(height: 20),
        _child,
      ],
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
