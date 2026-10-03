final class Precipitation {
  final double probabilityPercent;
  final double amountMm;
  final double rain;

  const Precipitation({
    required this.probabilityPercent,
    required this.amountMm,
    required this.rain,
  });

  @override
  String toString() {
    return 'Precipitation{probabilityPercent: $probabilityPercent, amountMm: $amountMm, rain: $rain}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Precipitation && other.probabilityPercent == probabilityPercent && other.amountMm == amountMm && other.rain == rain;
  }

  @override
  int get hashCode => probabilityPercent.hashCode ^ amountMm.hashCode ^ rain.hashCode;
}
