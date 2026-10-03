import 'types/location.dart';

typedef GeocodingResult = List<Location>;

final class GeocodingFetchParameters({
  required final String name,
  final int count = 10,
  final String language = 'en',
});

abstract interface class GeocodingService {
  Future<GeocodingResult> fetchLocations({required GeocodingFetchParameters params});
}
