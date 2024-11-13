import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumDielectricType.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';
import 'package:guadalajarav2/inventory/enums/enumValueUnit.dart';

class Capacitor extends Product {
  double? voltage;
  Mounting? mounting;
  String? package;
  double? value;
  ValueUnit? valueUnit = ValueUnit.farad;
  double? tolerance;
  DielectricType? dielectricType;
  String? material;

  Capacitor(
    Category category,
    String description,
    double unitPrice,
    String mpn,
    String manufacturer,
    int quantity,
    ProductStatus status,
    DateTime lastEdited,
    this.voltage,
    this.mounting,
    this.package,
    this.value,
    this.tolerance,
    this.dielectricType,
    this.material,
  ) : super(category, description, unitPrice, mpn, manufacturer, quantity,
            status, lastEdited);
  @override
  List<String> getAllAttributes() {
    return [
      description.toString(),
      unitPrice.toString(),
      mpn.toString(),
      manufacturer.toString(),
      quantity.toString(),
      status!.name.toString(),
      voltage.toString(),
      mounting!.name.toString(),
      package.toString(),
      value.toString(),
      tolerance.toString(),
      dielectricType!.name.toString(),
      material.toString(),
    ];
  }

  Map<String, dynamic> toJson() => {
        'mpn': mpn,
        'description': description,
        'unitPrice': unitPrice,
        'manufacturer': manufacturer,
        'quantity': quantity,
        'status': ProductStatus.values.indexOf(status!),
        'voltage': voltage,
        'mounting': Mounting.values.indexOf(mounting!),
        'package': package,
        'value': value,
        'tolerance': tolerance,
        'dielectricType': DielectricType.values.indexOf(dielectricType!),
        'material': material,
        'lastEdited': lastEdited.toString()
      };
  Capacitor.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.category = Category.capacitors;
    this.description = json['description'];
    this.unitPrice = json['unitPrice'];
    this.mpn = json['mpn'];
    this.manufacturer = json['manufacturer'];
    this.quantity = json['quantity'];
    this.status = ProductStatus.values[json['status']];
    this.voltage = json['voltage'];
    this.mounting = Mounting.values[json['mounting']];
    this.package = json['package'];
    this.value = json['value'];
    this.tolerance = json['tolerance'];
    this.dielectricType = DielectricType.values[json['dielectricType']];
    if (dielectricType == DielectricType.electrolytic) {
      this.material = 'N/A';
    } else {
      this.material = json['material'];
    }
    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
  }
}
