/// The languages the product speaks — the app's UI and the server's push copy.
///
/// English is the reference and the fallback: anything the device asks for that
/// is not listed here is served in English. Kept as a plain enum in this
/// package (no Flutter, no `intl`) because the server needs it too; the app's
/// own interface strings are `gen-l10n` ARB files, the vocabulary that has to
/// read the same on both sides lives in the `*Labels` classes next to this.
enum AppLanguage {
  en,
  de,
  ru;

  /// The language for a locale code such as `de`, `de_DE`, `de-AT` or `ru-RU`;
  /// [en] for null, empty or an unsupported language.
  static AppLanguage fromCode(String? code) {
    if (code == null || code.isEmpty) return en;
    final primary = code.split(RegExp('[_-]')).first.toLowerCase();
    for (final language in values) {
      if (language.name == primary) return language;
    }
    return en;
  }
}
