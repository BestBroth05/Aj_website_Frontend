import 'dart:math';

enum FaradsUnit { f, mf, uf, nf, pf }

extension ConvertionFarads on FaradsUnit {
  double convertToFarad(double value) {
    switch (this) {
      case FaradsUnit.f:
        break;
      case FaradsUnit.mf:
        value /= 1000;
        break;
      case FaradsUnit.uf:
        value /= 1000000;
        break;
      case FaradsUnit.nf:
        value /= 1000000000;
        break;
      case FaradsUnit.pf:
        value /= 1000000000000;
        break;
    }
    return value;
  }

  double? convertTo(double? value, FaradsUnit unit) {
    if (value == null) {
      return null;
    }
    int index = FaradsUnit.values.indexOf(this);
    int index2 = FaradsUnit.values.indexOf(unit);

    int dif = index2 - index;

    int exp = dif * 3;

    num power = pow(10, exp);

    value *= power;

    //0.000001
    //0.00000100000001

    return value;
  }

  double convertFrom(double value, FaradsUnit unit) {
    int index = FaradsUnit.values.indexOf(unit);
    int index2 = FaradsUnit.values.indexOf(this);

    int dif = index - index2;

    int exp = dif * 3;

    // num power = pow(10, exp);

    for (int i = 0; i < exp; i++) {
      value /= 10;
    }

    value = double.parse((value).toStringAsFixed(12));

    return value;
  }

  String get unit {
    String u = this.toString().split('.')[1];
    if (u.length > 1) {
      return u.substring(0, 1) + u.substring(1).toUpperCase();
    } else {
      return u.toUpperCase();
    }
  }
}
