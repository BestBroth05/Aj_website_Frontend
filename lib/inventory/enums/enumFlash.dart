import 'dart:math';

enum FlashUnit {
  kb,
  mb,
}

extension FlashUnitExtension on FlashUnit {
  String get name {
    return this.toString().split('.')[1].split('')[0].toUpperCase() + 'b';
  }

  String get unit {
    return name.toUpperCase();
  }

  double convertToMB(double value) {
    int index = FlashUnit.values.indexOf(this);

    int exp = index * 3;

    value /= pow(10, exp);

    return value;
  }

  double convertFrom(double value, FlashUnit unit) {
    int index = FlashUnit.values.indexOf(unit);
    int index2 = FlashUnit.values.indexOf(this);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  double? convertTo(double? value, FlashUnit unit) {
    if (value == null) {
      return null;
    }
    int index = FlashUnit.values.indexOf(this);
    int indexTo = FlashUnit.values.indexOf(unit);

    int exp = (indexTo - index) * 3;

    value *= pow(10, exp);

    return value;
  }
}
