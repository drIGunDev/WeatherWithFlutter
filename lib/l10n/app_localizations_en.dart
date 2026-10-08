// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get aboutTitle => 'About';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get weatherClearSky => 'Clear sky';

  @override
  String get weatherMainlyClear => 'Mainly clear';

  @override
  String get weatherPartlyCloudy => 'Partly cloudy';

  @override
  String get weatherOvercast => 'Overcast';

  @override
  String get weatherFog => 'Fog';

  @override
  String get weatherRimeFog => 'Rime fog';

  @override
  String get weatherLightDrizzle => 'Light drizzle';

  @override
  String get weatherDrizzle => 'Drizzle';

  @override
  String get weatherDenseDrizzle => 'Dense drizzle';

  @override
  String get weatherLightFreezingDrizzle => 'Light freezing drizzle';

  @override
  String get weatherFreezingDrizzle => 'Freezing drizzle';

  @override
  String get weatherLightRain => 'Light rain';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherHeavyRain => 'Heavy rain';

  @override
  String get weatherLightFreezingRain => 'Light freezing rain';

  @override
  String get weatherFreezingRain => 'Freezing rain';

  @override
  String get weatherLightSnow => 'Light snow';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherHeavySnow => 'Heavy snow';

  @override
  String get weatherSnowGrains => 'Snow grains';

  @override
  String get weatherLightRainShowers => 'Light rain showers';

  @override
  String get weatherRainShowers => 'Rain showers';

  @override
  String get weatherHeavyRainShowers => 'Heavy rain showers';

  @override
  String get weatherLightSnowShowers => 'Light snow showers';

  @override
  String get weatherSnowShowers => 'Snow showers';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get weatherStrongThunderstorm => 'Strong thunderstorm';

  @override
  String get weatherHeavyThunderstorm => 'Heavy thunderstorm';
}
