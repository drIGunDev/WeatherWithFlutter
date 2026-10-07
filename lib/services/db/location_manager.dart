import '../location/types/location.dart';

typedef Locations = List<Location>;

abstract interface class LocationManager {
  Future<void> addLocation({required Location location, bool activate = true});

  Future<void> remove({required Location location});

  Future<void> setActive({required Location location});

  Future<Location?> findActive();

  Future<Location?> findLocationById(String locationId);

  Future<Locations> fetchAll();
}
