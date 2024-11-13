import 'package:guadalajarav2/utils/dates_utils.dart';

extension DTExt on DateTime {
  String get dateFormatted {
    return '${this.year}-${this.month}-${this.day}';
  }

  String get readableFormat {
    return '${this.day} ${monthsInit[this.month - 1]} ${this.year}';
  }

  String get timeFormatted {
    return '${this.hour}:${this.minute}:${this.second}';
  }

  String get time {
    return '${this.hour}:${this.minute}';
  }

  String get birthdayFormat {
    return '${this.day}/${this.month}/${this.year}';
  }
}
