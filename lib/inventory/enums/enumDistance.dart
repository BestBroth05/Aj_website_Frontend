enum DistanceUnit {
  mm,
  inch,
}

extension DistanceExtension on DistanceUnit {
  String get unit {
    String u = this.toString().split('.')[1];
    return u;
  }
}

extension DistanceConvertion on DistanceUnit {
  double? convertTo(double? value, DistanceUnit unit) {
    if (value == null) {
      return null;
    }
    switch (unit) {
      case DistanceUnit.mm:
        value *= 25.4;
        break;
      case DistanceUnit.inch:
        break;
    }
    return value;
  }

  double convertFrom(double value, DistanceUnit unit) {
    switch (unit) {
      case DistanceUnit.mm:
        value /= 25.4;
        break;
      case DistanceUnit.inch:
        break;
    }

    return value;
  }

  DistanceUnit? parse(String str) {
    for (DistanceUnit unit in DistanceUnit.values) {
      if (unit.toString() == str) {
        return unit;
      }
    }
    return null;
  }
}
