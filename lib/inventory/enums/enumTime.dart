import 'dart:math';

enum TimeUnit {
  ms,
  s,
}

extension TimeUnitExt on TimeUnit {
  String get unit {
    return this.toString().split('.')[1];
  }

  double convertToMs(double value) {
    switch (this) {
      case TimeUnit.ms:
        break;
      case TimeUnit.s:
        value *= 1000;
        break;
    }

    return value;
  }

  double? convertTo(double? value, TimeUnit unit) {
    if (value == null) {
      return null;
    }
    int index = TimeUnit.values.indexOf(this);
    int index2 = TimeUnit.values.indexOf(unit);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }

  double convertFrom(double value, TimeUnit unit) {
    int index = TimeUnit.values.indexOf(unit);
    int index2 = TimeUnit.values.indexOf(this);

    int dif = index2 - index;

    int exp = dif * 3;

    value *= pow(10, exp);

    return value;
  }
}
