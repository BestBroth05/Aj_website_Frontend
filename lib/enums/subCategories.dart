import 'package:guadalajarav2/utils/tools.dart';

enum SubCategory {
  diode,
  crystal,
  transistor,
  mosfet,
  protectionCircuits,
  fuses,
}

extension SubCategoryExt on SubCategory {
  String get name {
    return separateWords(this.toString().split('.')[1]).toLowerCase();
  }
}
