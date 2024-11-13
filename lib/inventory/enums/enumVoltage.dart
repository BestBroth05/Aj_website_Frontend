import 'dart:math';

enum VoltageUnit { v, mv, uv }

extension VoltageExtension on VoltageUnit {
  String get unit {
    String u = this.toString().split('.')[1];
    if (u.length > 1) {
      return u.substring(0, 1) + u.substring(1).toUpperCase();
    } else {
      return u.toUpperCase();
    }
  }
}

extension VoltageConvertion on VoltageUnit {
  double convertToVolt(double value) {
    switch (this) {
      case VoltageUnit.v:
        break;
      case VoltageUnit.mv:
        value /= 1000;
        break;
      case VoltageUnit.uv:
        value /= 1000000;
        break;
    }

    return value;
  }

  double? convertTo(double? value, VoltageUnit voltageUnit) {
    if (value == null) {
      return null;
    }
    int index = VoltageUnit.values.indexOf(this);
    int index2 = VoltageUnit.values.indexOf(voltageUnit);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  double convertFrom(double value, VoltageUnit unit) {
    int index = VoltageUnit.values.indexOf(unit);
    int index2 = VoltageUnit.values.indexOf(this);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  VoltageUnit? parse(String str) {
    for (VoltageUnit unit in VoltageUnit.values) {
      if (unit.toString() == str) {
        return unit;
      }
    }
    return null;
  }
}
