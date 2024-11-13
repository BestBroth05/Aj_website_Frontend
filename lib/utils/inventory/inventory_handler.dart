import 'package:guadalajarav2/inventory/enums/enumDielectricType.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

String getValues(String key, dynamic value) {
  switch (key) {
    case 'status':
      return ProductStatus.values[value].name;
    case 'mounting':
      return Mounting.values[value].name;
    case 'dielectricType':
      return DielectricType.values[value].name;

    default:
      return value.toString();
  }
}
