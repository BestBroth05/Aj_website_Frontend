enum CalendarMonths {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

extension CalendarMonthsExt on CalendarMonths {
  String get name {
    return this.toString().split('.')[1];
  }

  int days(int year) {
    switch (this) {
      case CalendarMonths.january:
      case CalendarMonths.march:
      case CalendarMonths.may:
      case CalendarMonths.july:
      case CalendarMonths.august:
      case CalendarMonths.october:
      case CalendarMonths.december:
        return 31;
      case CalendarMonths.february:
        return year % 4 == 0 ? 29 : 28;
      case CalendarMonths.april:
      case CalendarMonths.june:
      case CalendarMonths.september:
      case CalendarMonths.november:
        return 30;
    }
  }
}

enum CalendarDays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension CalendarDaysExt on CalendarDays {
  String get name {
    return this.toString().split('.')[1];
  }
}

List<CalendarMonths> months = CalendarMonths.values;
List<CalendarDays> weekdays = CalendarDays.values;
