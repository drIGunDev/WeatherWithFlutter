/// Minimal Open-Meteo `/v1/forecast` payload with [hours] consecutive hourly rows.
Map<String, dynamic> forecastJson({int hours = 2, int utcOffsetSeconds = 3600}) {
  List<T> column<T>(T Function(int i) value) => List.generate(hours, value);

  return {
    'utc_offset_seconds': utcOffsetSeconds,
    'hourly': {
      'time': column((i) => '2026-01-01T${i.toString().padLeft(2, '0')}:00'),
      'temperature_2m': column((i) => 10.0 + i),
      'apparent_temperature': column((i) => 8.0 + i),
      'rain': column((_) => 0.0),
      'precipitation': column((_) => 0.0),
      'precipitation_probability': column((_) => 5),
      'weather_code': column((_) => 3),
      'wind_speed_10m': column((_) => 12.0),
      'wind_gusts_10m': column((_) => 20.0),
      'wind_direction_10m': column((_) => 180),
    },
  };
}
