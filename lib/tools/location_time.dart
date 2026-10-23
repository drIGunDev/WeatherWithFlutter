/// Current wall-clock time at a location whose local time is [utcOffsetSeconds] from UTC.
///
/// Forecast timestamps are the location's wall-clock time parsed as a plain (device-local)
/// [DateTime], so "now" must be expressed the same way to be comparable with them.
/// Falls back to the device time while the offset is still unknown.
DateTime locationNow(int? utcOffsetSeconds, {DateTime? now}) {
  final current = now ?? DateTime.now();
  if (utcOffsetSeconds == null) return current;
  final at = current.toUtc().add(Duration(seconds: utcOffsetSeconds));
  return DateTime(at.year, at.month, at.day, at.hour, at.minute, at.second);
}
