import 'dart:math';

enum OhmUnit { megaOhm, kohm, ohm, mohm }

extension OhmUnitExtension on OhmUnit {
  double convertToOhm(double value) {
    switch (this) {
      case OhmUnit.ohm:
        break;
      case OhmUnit.kohm:
        value *= 1000;
        break;
      case OhmUnit.mohm:
        value /= 1000;
        break;
      case OhmUnit.megaOhm:
        value *= 1000000;
        break;
    }

    return value;
  }

  double convertFrom(double value, OhmUnit unit) {
    int index = OhmUnit.values.indexOf(unit);
    int index2 = OhmUnit.values.indexOf(this);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  double? convertTo(double? value, OhmUnit newUnit) {
    if (value == null) {
      return null;
    }
    int index = OhmUnit.values.indexOf(this);
    int index2 = OhmUnit.values.indexOf(newUnit);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  String get unit {
    String u = this.toString().split('.')[1];
    if (u.length > 3) {
      return u.substring(0, 1) +
          u.substring(1, 2).toUpperCase() +
          u.substring(2);
    } else {
      return u.substring(0, 2).toUpperCase() + u.substring(2);
    }
  }
}
