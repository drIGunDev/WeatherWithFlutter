import 'types/location.dart';

typedef GeocodingResults = List<Location>;

final class GeocodingFetchParameters({
  required final String name,
  final int count = 10,
  final String language = 'en',
});

abstract interface class GeocodingService {
  Future<GeocodingResults> fetchLocations({required GeocodingFetchParameters params});
}
