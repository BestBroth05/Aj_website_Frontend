enum TemperatureUnit { f, c }

extension TemperatureExtension on TemperatureUnit {
  double convertToCelcius(double value) {
    switch (this) {
      case TemperatureUnit.c:
        break;
      case TemperatureUnit.f:
        value = (value - 32) * 5 / 9;
    }

    return value;
  }

  double convertTo(double value, TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.f:
        value = (value * 9) / 5 + 32;
        break;
      case TemperatureUnit.c:
        break;
    }
    return value;
  }

  double convertFrom(double value, TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.f:
        value = (value - 32) * 5 / 9;
        break;
      case TemperatureUnit.c:
        break;
    }
    return value;
  }
}
