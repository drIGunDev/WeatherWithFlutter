import '../../location/types/location.dart';

typedef Time = DateTime;

enum Weekday {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  final int value;

  const Weekday(this.value);

  static Weekday map({required int value}) {
    for (final Weekday day in values) {
      if (day.value == value) {
        return day;
      }
    }
    throw Exception("Unknown recurrence frequency: $value");
  }
}

extension ToString on Set<Weekday> {
  String toRecurrenceRule() {
    if (isEmpty) return '';
    final results = map((e) => e.value.toString()).toList().join(',');
    return results;
  }
}

extension FromString on String {
  Set<Weekday> toRecurrenceRule() {
    if (isEmpty) return {};
    return split(',').map((e) => Weekday.map(value: int.parse(e))).toSet();
  }
}

extension WeekExtension on DateTime {
  Weekday get dayOfWeek => Weekday.values[weekday - 1];

  DateTime atWeekday(
      Weekday weekday,
      int week, {
        required int hour,
        required int minute,
      }) {
    final date = add(Duration(days: weekday.index + week * 7));

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }
}

extension DateTimeWeekExtension on DateTime {
  DateTime get startOfWeek {
    final d = DateTime(year, month, day);
    return d.subtract(Duration(days: weekday - DateTime.monday));
  }
}

extension SetOfWeekdayExtension<T> on Set<T> {
  Set<T> clone() {
    return Set.of(this);
  }
}

class RecurrenceRule {
  final Set<Weekday> weekdays;

  const RecurrenceRule({
    required this.weekdays,
  });

  bool isOnce() => weekdays.isEmpty;

  bool isDaily() => weekdays.length == 7;

  RecurrenceRule clone() {
    return RecurrenceRule(weekdays: weekdays.clone());
  }

  @override
  String toString() {
    return "RecurrenceRule(weekdays: $weekdays)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecurrenceRule && other.weekdays == weekdays;
  }

  @override
  int get hashCode => weekdays.hashCode;
}

final class Event<T extends GeoLocatable> {
  final Time start;
  final Time end;
  final RecurrenceRule recurrenceRule;
  final T item;

  const Event({
    required this.start,
    required this.end,
    this.recurrenceRule = const RecurrenceRule(weekdays: {}),
    required this.item,
  });

  Event<U> copyWith<U extends GeoLocatable>({
    Time? start,
    Time? end,
    RecurrenceRule? recurrenceRule,
    U? item,
  }) {
    return Event(
      start: start ?? this.start,
      end: end ?? this.end,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      item: item ?? this.item as U,
    );
  }

  @override
  String toString() {
    return "Event(start: $start, end: $end, recurrenceRule: $recurrenceRule, item: $item)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.start == start && other.end == end && other.recurrenceRule == recurrenceRule && other.item == item;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ item.hashCode ^ recurrenceRule.hashCode;
}
