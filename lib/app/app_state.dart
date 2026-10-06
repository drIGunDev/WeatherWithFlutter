import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_with_flutter/services/location/types/location.dart';

class AppState({required final Location? location}) {
  AppState copyWith({Location? location}) {
    return AppState(
      location: location ?? this.location,
    );
  }
}

class AppNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return AppState(location: null);
  }

  void setLocation({Location? location}) {
    state = AppState(location: location);
  }
}

final appProvider = NotifierProvider<AppNotifier, AppState>(AppNotifier.new);
