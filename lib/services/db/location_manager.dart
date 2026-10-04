import '../location/types/location.dart';

typedef Locations = List<Location>;

abstract interface class LocationManager {
  Future<void> add({required Location location});

  Future<void> remove({required Location location});

  Future<void> setActive({required Location location});

  Future<Location?> findActive();

  Future<Locations> fetchAll();
}
