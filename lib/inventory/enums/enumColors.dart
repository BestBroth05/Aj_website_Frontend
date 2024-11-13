import 'package:guadalajarav2/utils/tools.dart';

enum LedColor {
  yellow,
  red,
  green,
  blue,
  rgb,
  other,
}

extension LedColorsExtension on LedColor {
  String get name {
    return toTitle(this.toString().split('.')[1]);
  }
}
