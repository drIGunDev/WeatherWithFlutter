typedef WindStrength = double;
typedef WindDirectionGrad = double;

final class const Wind({
  required final WindStrength forceKmPerHour,
  required final WindStrength gustsKmPerHour,
  required final WindDirectionGrad directionGrad,
}) {
  @override
  String toString() {
    return 'Wind{forceKmPerHour: $forceKmPerHour, gustsKmPerHour: $gustsKmPerHour, directionGrad: $directionGrad}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wind && other.forceKmPerHour == forceKmPerHour && other.gustsKmPerHour == gustsKmPerHour && other.directionGrad == directionGrad;
  }

  @override
  int get hashCode => forceKmPerHour.hashCode ^ gustsKmPerHour.hashCode ^ directionGrad.hashCode;
}

enum WindBeaufortEnum {
  calm(0, 'calm'),
  lightAir(1, 'light air'),
  lightBreeze(2, 'light breeze'),
  gentleBreeze(3, 'gentle breeze'),
  moderateBreeze(4, 'moderate breeze'),
  freshBreeze(5, 'fresh breeze'),
  strongBreeze(6, 'strong breeze'),
  moderateGale(7, 'moderate gale'),
  freshGale(8, 'fresh gale'),
  strongGale(9, 'strong gale'),
  wholeGale(10, 'whole gale'),
  storm(11, 'storm'),
  hurricane(12, 'hurricane');

  final WindStrength strength;
  final String name;

  const WindBeaufortEnum(this.strength, this.name);

  static WindBeaufortEnum toBeaufort({required WindStrength forceKmPerHour}) {
    return switch (forceKmPerHour) {
      == 0 => .calm,
      > 0 && <= 6 => .lightAir,
      > 6 && <= 12 => .lightBreeze,
      > 12 && <= 20 => .gentleBreeze,
      > 20 && <= 30 => .moderateBreeze,
      > 30 && <= 40 => .freshBreeze,
      > 40 && <= 50 => .strongBreeze,
      > 50 && <= 60 => .moderateGale,
      > 60 && <= 74 => .freshGale,
      > 74 && <= 89 => .strongGale,
      > 89 && <= 104 => .wholeGale,
      > 104 && <= 120 => .storm,
      > 120 => .hurricane,
      _ => .calm,
    };
  }
}
