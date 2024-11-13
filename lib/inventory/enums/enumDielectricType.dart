import 'package:guadalajarav2/utils/tools.dart';

enum DielectricType {
  ceramic,
  electrolytic,
}

extension DielectricTypeExtension on DielectricType {
  String get name {
    return toTitle(this.toString().split('.')[1]);
  }
}
