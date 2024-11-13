import 'dart:math';

enum HenryUnit { h, mh, uh, nh }

extension CurrentUnitExtension on HenryUnit {
  double convertToHenry(double value) {
    int index = HenryUnit.values.indexOf(this);

    int exp = index * 3;

    value /= pow(10, exp);

    return value;
  }

  double? convertTo(double? value, HenryUnit newUnit) {
    if (value == null) {
      return null;
    }
    int index = HenryUnit.values.indexOf(this);
    int index2 = HenryUnit.values.indexOf(newUnit);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  double convertFrom(double value, HenryUnit unit) {
    int index = HenryUnit.values.indexOf(unit);
    int index2 = HenryUnit.values.indexOf(this);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);
    value = double.parse((value).toStringAsFixed(9));

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
