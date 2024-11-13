enum MoneyUnit {
  usDollar,
  mexicanPeso,
  euro,
}

extension MoneyExtension on MoneyUnit {
  String get symbol {
    switch (this) {
      case MoneyUnit.usDollar:
      case MoneyUnit.mexicanPeso:
        return '\$';
      case MoneyUnit.euro:
        return String.fromCharCode(8364);
      default:
        return '';
    }
  }

  String get unit {
    switch (this) {
      case MoneyUnit.usDollar:
        return 'US Dollar';
      case MoneyUnit.mexicanPeso:
        return 'MX Peso';
      case MoneyUnit.euro:
        return 'Euro';
      default:
        return '';
    }
  }

  MoneyUnit? parse(String str) {
    for (MoneyUnit moneyUnit in MoneyUnit.values) {
      if (moneyUnit.toString() == str) {
        return moneyUnit;
      }
    }
    return null;
  }

  double? convertTo(double value, MoneyUnit unit) {
    switch (unit) {
      case MoneyUnit.usDollar:
        return value;
      case MoneyUnit.mexicanPeso:
        return value * 20.09;
      case MoneyUnit.euro:
        return value * 0.85;
    }
  }
}
