import 'package:flutter/widgets.dart';

import 'app_language.dart';
import 'app_localizations.dart';

/// `context.l10n.settingsTitle` instead of `AppLocalizations.of(context)`.
extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  // /// The language the interface is in, in the vocabulary the shared `*Labels`
  // /// classes (activity and condition names) understand. Always one of the
  // /// supported ones: the locale resolves to English when the device's language
  // /// is not.
  AppLanguage get language => AppLanguage.fromCode(Localizations.localeOf(this).languageCode);
}
