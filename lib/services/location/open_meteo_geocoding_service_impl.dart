import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../tools/id_generator.dart';
import 'geocoding_service.dart';
import 'types/location.dart';

final class OpenMeteoGeocodingServiceImpl({required this._client}) implements GeocodingService {
  final http.Client _client;

  @override
  Future<GeocodingResult> fetchLocations({required GeocodingFetchParameters params}) async {
    final uri = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      {
        'name': params.name,
        'count': params.count.toString(),
        'language': params.language,
      },
    );
    final response = await _client.get(uri);

    return switch (response.statusCode) {
      200 => _transformToEvents(response.body),
      _ => throw Exception('HTTP ${response.statusCode}'),
    };
  }

  Future<List<Location>> _transformToEvents(String body) async {
    return (await _parseResponse(body))
        .map(
          (e) => Location(
            id: const UuidIdGenerator().generateFrom(
              name: 'open-meteo:geocoding:${e.id}',
            ),
            name: e.name,
            latitude: e.latitude,
            longitude: e.longitude,
            countryCode: e.countryCode,
            country: e.country,
            city: e.admin1,
            timezone: e.timezone,
          ),
        )
        .toList();
  }

  Future<List<_OpenMeteoGeocodingDTO>> _parseResponse(
    String responseBody,
  ) async {
    _OpenMeteoGeocodingDTO? tryParse(Map<String, dynamic> json) {
      try {
        return _OpenMeteoGeocodingDTO.fromJson(json);
      } catch (_) {
        return null;
      }
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object');
    }
    final json = decoded;
    // Open-Meteo omits `results` entirely when nothing matches.
    final results = json['results'];
    if (results is! List) return const [];

    final List<_OpenMeteoGeocodingDTO> list = results
        .map<_OpenMeteoGeocodingDTO?>((e) => tryParse(e))
        .whereType<_OpenMeteoGeocodingDTO>()
        .toList(growable: false);
    return list;
  }
}

final class _OpenMeteoGeocodingDTO {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String countryCode;
  final String country;
  final String admin1;
  final String timezone;

  const _OpenMeteoGeocodingDTO({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
    required this.country,
    required this.admin1,
    required this.timezone,
  });

  factory _OpenMeteoGeocodingDTO.fromJson(Map<String, dynamic> json) {
    return _OpenMeteoGeocodingDTO(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      countryCode: json['country_code'],
      country: json['country'],
      admin1: json['admin1'],
      timezone: json['timezone'],
    );
  }

  @override
  String toString() {
    return 'OpenMeteoGeocodingDTO{id: $id, name: $name, latitude: $latitude, longitude: $longitude, countryCode: $countryCode, country: $country, admin1: $admin1, timezone: $timezone}';
  }
}
