import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../services/open_weather_service/types/event.dart';

abstract final class DateTimeFormat {
  static String _format(AppLocalizations l10n, String pattern, Time value) => DateFormat(pattern, l10n.localeName).format(value);

  static String _two(int value) => value.toString().padLeft(2, '0');

  static String time(Time value) => '${_two(value.hour)}:${_two(value.minute)}';

  static String dayShort(AppLocalizations l10n, Time value) => _format(l10n, 'E, d MMM', value);
}
