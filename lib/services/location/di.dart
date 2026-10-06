import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../http/di.dart';
import 'geocoding_service.dart';
import 'open_meteo_geocoding_service_impl.dart';
import 'geocoding_notifier.dart';

final geocodingServiceProvider = Provider<GeocodingService>((ref) {
  final geocodingService = OpenMeteoGeocodingServiceImpl(client: ref.read(httpClientProvider));
  return geocodingService;
});

final geocodingProvider = AsyncNotifierProvider<GeocodingNotifier, GeocodingState>(GeocodingNotifier.new);
