typedef TemperatureValue = double;

enum TemperatureUnit { celsius, fahrenheit }

final class Temperature {
  final TemperatureValue _value;
  final TemperatureUnit _unit;

  const Temperature._(this._value, this._unit);

  Temperature.fromCelsius(double value) : this._(value, TemperatureUnit.celsius);

  Temperature.fromFahrenheit(double value) : this._(value, TemperatureUnit.fahrenheit);

  double get temperature {
    return _value;
  }

  double get celsius {
    switch (_unit) {
      case .fahrenheit:
        return (_value - 32) / 1.8;
      default:
        return _value;
    }
  }

  double get fahrenheit {
    switch (_unit) {
      case .celsius:
        return _value * 1.8 + 32;
      default:
        return _value;
    }
  }

  @override
  String toString() {
    switch (_unit) {
      case .celsius:
        return '$_value°C';
      case .fahrenheit:
        return '$_value°F';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Temperature && other._value == _value && other._unit == _unit;
  }

  @override
  int get hashCode => _value.hashCode ^ _unit.hashCode;
}
