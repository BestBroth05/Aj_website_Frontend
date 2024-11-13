import 'dart:math';

enum HertzUnit {
  hz,
  khz,
  mhz,
}

extension HertzExt on HertzUnit {
  String get unit {
    String value = this.toString().split('.')[1];
    return value.substring(0, value.length - 1).toUpperCase() +
        value[value.length - 1];
  }

  double convertToHz(double value) {
    switch (this) {
      case HertzUnit.hz:
        break;
      case HertzUnit.khz:
        value /= 1000;
        break;
      case HertzUnit.mhz:
        value /= 1000000;
        break;
    }

    return value;
  }

  double? convertTo(double? value, HertzUnit unit) {
    if (value == null) {
      return null;
    }
    int index = HertzUnit.values.indexOf(this);
    int index2 = HertzUnit.values.indexOf(unit);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  double convertFrom(double value, HertzUnit unit) {
    int index = HertzUnit.values.indexOf(unit);
    int index2 = HertzUnit.values.indexOf(this);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }
}
