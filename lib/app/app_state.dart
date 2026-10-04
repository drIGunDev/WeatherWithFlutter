import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/location/types/location.dart';

class AppState {
  final Location location;

  const AppState({
    required this.location,
  });

  AppState copyWith({Location? location}) {
    return AppState(
      location: location ?? this.location,
    );
  }
}

class AppNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    final berlin = Location(
      id: 'berlin',
      name: 'Berlin',
      latitude: 52.52,
      longitude: 13.405,
      country: 'Germany',
      countryCode: 'DE',
      city: 'Berlin',
      timezone: 'Europe/Berlin',
    );
    return AppState(location: berlin);
  }

  void setLocation(Location location) {
    state = state.copyWith(location: location);
  }
}

final appProvider = NotifierProvider<AppNotifier, AppState>(AppNotifier.new);
