import '../../open_weather_service/types/id_generator.dart';

typedef LocationId = String;

abstract interface class GeoLocatable {
  Location get location;
}

final class Location {
  final LocationId id;
  final double latitude;
  final double longitude;
  final String name;
  final String country;
  final String countryCode;
  final String city;
  final String timezone;

  /// Sync bookkeeping, deliberately outside [operator ==].
  ///
  /// A place is the same place whichever revision described it last. Counting
  /// it here made every cached forecast vanish the moment the location's
  /// revision moved — the Timeline keeps only events whose location equals the
  /// active one, and those events carry the location as it was when they were
  /// fetched.
  final int revisionId;

  /// The one location the replica plans for.
  ///
  /// Part of the replica rather than a device setting: a second device has to
  /// open on the same place, without asking again.
  ///
  /// Deliberately outside [operator ==]: this is replica state, not what makes
  /// a place that place. Two copies of Berlin differing only in the flag are
  /// the same Berlin — and the Timeline filters its events by comparing
  /// locations, so counting the flag would have hidden every forecast the
  /// moment a location became active.
  final bool isActive;

  Location({
    LocationId? id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.country,
    required this.countryCode,
    required this.city,
    required this.timezone,
    this.revisionId = 0,
    this.isActive = false,
  }) : id = id ?? const UuidIdGenerator().generate();

  factory Location.short({
    required double latitude,
    required double longitude,
    required String name,
    int revisionId = 0,
    bool isActive = false,
  }) {
    return Location(
      id: null,
      latitude: latitude,
      longitude: longitude,
      name: name,
      country: '',
      countryCode: '',
      city: '',
      timezone: '',
      revisionId: revisionId,
      isActive: isActive,
    );
  }

  @override
  String toString() {
    return 'Location{id: $id, latitude: $latitude, longitude: $longitude, name: $name, country: $country, countryCode: $countryCode, city: $city, timezone: $timezone, revisionId: $revisionId, isActive: $isActive}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          id == other.id &&
          name == other.name &&
          country == other.country &&
          countryCode == other.countryCode &&
          city == other.city &&
          timezone == other.timezone;

  @override
  int get hashCode => id.hashCode;
}
