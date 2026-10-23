/// Human-readable age of the cached forecast, e.g. `last update: 5 minutes ago`.
String formatLastUpdate(Duration age) {
  final (value, unit) = switch (age) {
    Duration(inDays: > 0) => (age.inDays, 'day'),
    Duration(inHours: > 0) => (age.inHours, 'hour'),
    Duration(inMinutes: > 0) => (age.inMinutes, 'minute'),
    _ => (age.inSeconds, 'second'),
  };
  return 'last update: $value $unit${value == 1 ? '' : 's'} ago';
}
