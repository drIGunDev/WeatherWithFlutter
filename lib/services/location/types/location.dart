import '../../../tools/wrapped.dart';
import '../../../tools/id_generator.dart';

typedef LocationId = String;

abstract interface class GeoLocatable {
  Location get location;
}

final class Location {
  static const Location? empty = null;

  final LocationId id;
  final double latitude;
  final double longitude;
  final String name;
  final String country;
  final String countryCode;
  final String city;
  final String timezone;
  final bool isActive;
  final DateTime? weatherUpdatedAt;

  Location({
    LocationId? id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.country,
    required this.countryCode,
    required this.city,
    required this.timezone,
    this.isActive = false,
    this.weatherUpdatedAt,
  }) : id = id ?? const UuidIdGenerator().generate();

  factory Location.short({
    required double latitude,
    required double longitude,
    required String name,
    int revisionId = 0,
    bool isActive = false,
    DateTime? weatherUpdatedAt,
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
      isActive: isActive,
      weatherUpdatedAt: weatherUpdatedAt,
    );
  }

  Location copyWith({
    Wrapped<DateTime?>? weatherUpdatedAt,
    bool? isActive,
  }) {
    return Location(
      id: id,
      latitude: latitude,
      longitude: longitude,
      name: name,
      country: country,
      countryCode: countryCode,
      city: city,
      timezone: timezone,
      isActive: isActive ?? this.isActive,
      weatherUpdatedAt: weatherUpdatedAt?.value ?? this.weatherUpdatedAt,
    );
  }

  @override
  String toString() {
    return 'Location{id: $id, latitude: $latitude, longitude: $longitude, name: $name, country: $country, countryCode: $countryCode, city: $city, timezone: $timezone, isActive: $isActive, weatherUpdatedAt: $weatherUpdatedAt}';
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
          weatherUpdatedAt == other.weatherUpdatedAt &&
          timezone == other.timezone;

  @override
  int get hashCode =>
      id.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      name.hashCode ^
      country.hashCode ^
      countryCode.hashCode ^
      city.hashCode ^
      timezone.hashCode ^
      weatherUpdatedAt.hashCode;
}
