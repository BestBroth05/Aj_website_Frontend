import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';

enum ValueUnit { farad, ohm, henry }

extension ValueUnitExtension on ValueUnit {
  List<dynamic> get units {
    switch (this) {
      case ValueUnit.farad:
        return FaradsUnit.values;
      case ValueUnit.ohm:
        return OhmUnit.values;
      case ValueUnit.henry:
        return HenryUnit.values;
      default:
        return [];
    }
  }

  String get name {
    return this.toString().split('.')[1];
  }
}
