import 'package:uuid/uuid.dart';

abstract interface class IdGenerator {
  String generate();

  /// A stable id derived from [name].
  ///
  /// For entities the app does not invent but recognises — a place returned by
  /// a geocoder, say. The same [name] always yields the same id, so picking
  /// Berlin twice, or on two devices, produces one entity rather than two.
  String generateFrom({required String name});

  const IdGenerator();
}

class UuidIdGenerator implements IdGenerator {
  @override
  String generate() => const Uuid().v4();

  @override
  String generateFrom({required String name}) => const Uuid().v5(Namespace.url.value, name);

  const UuidIdGenerator();
}
