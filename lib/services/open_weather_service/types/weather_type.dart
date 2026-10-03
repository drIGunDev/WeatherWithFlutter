enum WeatherType {
  clearSky(0),
  mainlyClear(1),
  partlyCloudy(2),
  overcast(3),
  fog(45),
  depositingRimeFog(48),
  lightDrizzle(51),
  moderateDrizzle(53),
  denseDrizzle(55),
  lightFreezingDrizzle(56),
  moderateOrDenseFreezingDrizzle(57),
  lightRain(61),
  moderateRain(63),
  heavyRain(65),
  lightFreezingRain(66),
  moderateOrHeavyFreezingRain(67),
  slightSnowfall(71),
  moderateSnowfall(73),
  heavySnowfall(75),
  snowGrains(77),
  slightRainShowers(80),
  moderateRainShowers(81),
  heavyRainShowers(82),
  slightSnowShowers(85),
  heavySnowShowers(86),
  thunderstormSlightOrModerate(95),
  thunderstormStrong(96),
  thunderstormHeavy(99);

  final int type;

  const WeatherType(this.type);

  static List<int> toInt() => WeatherType.values.map((e) => e.type).toList();

  static WeatherType fromCode(int code) {
    return WeatherType.values.firstWhere(
          (value) => value.type == code,
      orElse: () => throw StateError(
        'Unknown weather type code: $code',
      ),
    );
  }
}
