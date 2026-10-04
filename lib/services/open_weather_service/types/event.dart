import '../../location/types/location.dart';

typedef Time = DateTime;

final class const Event<T extends GeoLocatable>({
  required final Time start,
  required final Time end,
  required final T item,
}) {
  Event<U> copyWith<U extends GeoLocatable>({
    Time? start,
    Time? end,
    U? item,
  }) {
    return Event(
      start: start ?? this.start,
      end: end ?? this.end,
      item: item ?? this.item as U,
    );
  }

  @override
  String toString() {
    return "Event(start: $start, end: $end, item: $item)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.start == start && other.end == end && other.item == item;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ item.hashCode;
}
