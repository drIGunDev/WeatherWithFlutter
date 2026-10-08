import '../../l10n/app_localizations.dart';
import '../../services/open_weather_service/types/weather_type.dart';

abstract final class WeatherLabels {
  static const int _nightEndsHour = 6;

  /// Hours at or after this are night again.
  static const int _nightStartsHour = 18;
  /// [emoji] for a given hour: at night nothing shows the sun — a clear sky
  /// becomes the moon, a sun behind cloud or rain just the cloud or rain.
  static String emojiForHour(WeatherType type, int hour) {
    final day = emoji(type);
    final isNight = hour <= _nightEndsHour || hour >= _nightStartsHour;
    if (!isNight) return day;
    return switch (day) {
      '☀️' || '🌤️' => '🌙',
      '⛅' => '☁️',
      '🌦️' => '🌧️',
      _ => day,
    };
  }

  /// The sky as an emoji — the experiment on branch test-new-weather-icons,
  /// in place of [icon]'s glyphs. Grouped the same way as [icon].
  static String emoji(WeatherType type) {
    switch (type) {
      case WeatherType.clearSky:
        return '☀️';
      case WeatherType.mainlyClear:
        return '🌤️';
      case WeatherType.partlyCloudy:
        return '⛅';
      case WeatherType.overcast:
        return '☁️';
      case WeatherType.fog:
      case WeatherType.depositingRimeFog:
        return '🌫️';
      case WeatherType.lightDrizzle:
      case WeatherType.moderateDrizzle:
      case WeatherType.denseDrizzle:
      case WeatherType.lightFreezingDrizzle:
      case WeatherType.moderateOrDenseFreezingDrizzle:
      case WeatherType.lightRain:
      case WeatherType.lightFreezingRain:
      case WeatherType.slightRainShowers:
        return '🌦️';
      case WeatherType.moderateRain:
      case WeatherType.moderateRainShowers:
      case WeatherType.heavyRain:
      case WeatherType.heavyRainShowers:
      case WeatherType.moderateOrHeavyFreezingRain:
        return '🌧️';
      case WeatherType.slightSnowfall:
      case WeatherType.moderateSnowfall:
      case WeatherType.snowGrains:
      case WeatherType.slightSnowShowers:
        return '🌨️';
      case WeatherType.heavySnowfall:
      case WeatherType.heavySnowShowers:
        return '❄️';
      case WeatherType.thunderstormSlightOrModerate:
      case WeatherType.thunderstormStrong:
      case WeatherType.thunderstormHeavy:
        return '⛈️';
    }
  }

  static String name(AppLocalizations l10n, WeatherType type) {
    switch (type) {
      case WeatherType.clearSky:
        return l10n.weatherClearSky;
      case WeatherType.mainlyClear:
        return l10n.weatherMainlyClear;
      case WeatherType.partlyCloudy:
        return l10n.weatherPartlyCloudy;
      case WeatherType.overcast:
        return l10n.weatherOvercast;
      case WeatherType.fog:
        return l10n.weatherFog;
      case WeatherType.depositingRimeFog:
        return l10n.weatherRimeFog;
      case WeatherType.lightDrizzle:
        return l10n.weatherLightDrizzle;
      case WeatherType.moderateDrizzle:
        return l10n.weatherDrizzle;
      case WeatherType.denseDrizzle:
        return l10n.weatherDenseDrizzle;
      case WeatherType.lightFreezingDrizzle:
        return l10n.weatherLightFreezingDrizzle;
      case WeatherType.moderateOrDenseFreezingDrizzle:
        return l10n.weatherFreezingDrizzle;
      case WeatherType.lightRain:
        return l10n.weatherLightRain;
      case WeatherType.moderateRain:
        return l10n.weatherRain;
      case WeatherType.heavyRain:
        return l10n.weatherHeavyRain;
      case WeatherType.lightFreezingRain:
        return l10n.weatherLightFreezingRain;
      case WeatherType.moderateOrHeavyFreezingRain:
        return l10n.weatherFreezingRain;
      case WeatherType.slightSnowfall:
        return l10n.weatherLightSnow;
      case WeatherType.moderateSnowfall:
        return l10n.weatherSnow;
      case WeatherType.heavySnowfall:
        return l10n.weatherHeavySnow;
      case WeatherType.snowGrains:
        return l10n.weatherSnowGrains;
      case WeatherType.slightRainShowers:
        return l10n.weatherLightRainShowers;
      case WeatherType.moderateRainShowers:
        return l10n.weatherRainShowers;
      case WeatherType.heavyRainShowers:
        return l10n.weatherHeavyRainShowers;
      case WeatherType.slightSnowShowers:
        return l10n.weatherLightSnowShowers;
      case WeatherType.heavySnowShowers:
        return l10n.weatherSnowShowers;
      case WeatherType.thunderstormSlightOrModerate:
        return l10n.weatherThunderstorm;
      case WeatherType.thunderstormStrong:
        return l10n.weatherStrongThunderstorm;
      case WeatherType.thunderstormHeavy:
        return l10n.weatherHeavyThunderstorm;
    }
  }
}
