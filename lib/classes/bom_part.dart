import 'package:excel/excel.dart';
import 'package:guadalajarav2/classes/mpn.dart';

class BomPart {
  int selected = 0;

  int _required = 1;
  int multiplier = 1;
  List<String>? designators;
  String? description;
  String? mountingType;
  String? packageCase;
  String? manufacturer;
  int goingToBeUsed = 0;

  late Mpn mpn;
  Mpn? alternative1;
  Mpn? alternative2;

  BomPart({
    required List<Data?> values,
  }) {
    String? mpnstring =
        values[5] != null ? values[5]!.value.toString() : 'null';
    designators =
        values[0] == null ? null : values[0]!.value.toString().split(',');
    description = values[1] == null ? null : values[1]!.value.toString();
    mountingType = values[2] == null ? null : values[2]!.value.toString();
    packageCase = values[3] == null ? null : values[3]!.value.toString();
    manufacturer = values[4] == null ? null : values[4]!.value.toString();
    mpn = Mpn(mpn: mpnstring);
    alternative1 = values[6] == null
        ? null
        : values[6]!.value.toString().isEmpty
            ? null
            : Mpn(mpn: values[6]!.value.toString());
    alternative2 = values[7] == null
        ? null
        : values[7]!.value.toString().isEmpty
            ? null
            : Mpn(mpn: values[7]!.value.toString());
    _required =
        (values[8] == null ? null : int.parse(values[8]!.value.toString()))!;
  }

  BomPart.empty() {
    designators = ['C1, C2'];
    description = 'alsbdouaysbdas';
    mountingType = 'alshdboayusd';
    packageCase = 'asdas';
    mpn = Mpn(mpn: 'abhsdias');
    manufacturer = 'akjbsndlasd';
  }

  Map<String, dynamic> toJson() => {
        'designators': designators,
        'description': description,
        'mountingType': mountingType,
        'packageCase': packageCase,
        'manufacturer': manufacturer,
        'quantity': mpn.quantity,
      };

  List<dynamic> get tableValues => [
        designators,
        mpn.mpn,
        description,
        manufacturer,
        mpn.quantityString,
        mpn.unitPriceString,
        alternative1,
        alternative2,
        required,
        goingToBeUsed,
        remaining,
        _costString,
      ];

  int get required => _required * multiplier;

  List<Mpn?> get allMPN {
    return [mpn, alternative1, alternative2];
  }

  double get cost {
    if (selected > 2 || selected < 0) {
      return 0;
    }
    double up = allMPN[selected]!.unitPrice;
    return goingToBeUsed * up;
  }

  int get remaining => selected > 2 || selected < 0
      ? allMPN[0]!.quantity
      : allMPN[selected]!.quantity - goingToBeUsed;

  String get _costString => '\$ ${cost.toStringAsFixed(2)}';

  void setFirstSelected({bool setGTBU = true}) {
    List<Mpn?> mpns = allMPN;

    for (int i = 0; i < 3; i++) {
      Mpn? _mpn = mpns[i];
      if (_mpn != null) {
        if (_mpn.quantity > 0) {
          selected = i;
          if (setGTBU) {
            if (_mpn.quantity >= required) {
              goingToBeUsed = required;
            } else {
              goingToBeUsed = 0;
              selected = -5;
            }
          }
          return;
        }
      }
    }
    selected = 3;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
