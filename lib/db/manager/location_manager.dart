import '../../services/location/types/location.dart';

typedef Locations = List<Location>;

abstract interface class LocationManager {
  Future<void> addate({required Location location});

  Future<void> deleteLocation({required Location location});

  Future<void> setLocationActive({required Location location});

  Future<Location?> findActiveLocation();

  Future<Location?> findLocationById(String locationId);

  Future<Locations> fetchAllLocation();
}
