import 'dart:math';

enum CurrentUnit { a, ma, ua }

extension CurrentUnitExtension on CurrentUnit {
  String get unit {
    String value = this.toString().split('.')[1];
    if (value.length > 1) {
      return value.split('')[0].toLowerCase() + 'A';
    } else {
      return value.toUpperCase();
    }
  }

  double convertToAmp(double value) {
    switch (this) {
      case CurrentUnit.a:
        break;
      case CurrentUnit.ma:
        value /= 1000;
        break;
      case CurrentUnit.ua:
        value /= 1000000;
        break;
    }

    return value;
  }

  double? convertTo(double? value, CurrentUnit unit) {
    if (value == null) {
      return null;
    }
    int index = CurrentUnit.values.indexOf(this);
    int index2 = CurrentUnit.values.indexOf(unit);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  double convertFrom(double value, CurrentUnit unit) {
    int index = CurrentUnit.values.indexOf(unit);
    int index2 = CurrentUnit.values.indexOf(this);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }
}
