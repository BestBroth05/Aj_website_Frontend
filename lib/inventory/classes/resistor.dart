import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';
import 'package:guadalajarav2/inventory/enums/enumValueUnit.dart';

class Resistor extends Product {
  double? voltage;
  Mounting? mounting;
  String? package;
  double? power;
  ValueUnit? valueUnit = ValueUnit.ohm;
  double? value;
  double? tolerance;
  Resistor(
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
    this.power,
    this.value,
    this.tolerance,
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
      power.toString(),
      value.toString(),
      tolerance.toString(),
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
        'power': power,
        'value': value,
        'tolerance': tolerance,
        'lastEdited': lastEdited.toString()
      };
  Resistor.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.category = Category.resistors;
    this.description = json['description'];
    this.unitPrice = json['unitPrice'];
    this.mpn = json['mpn'];
    this.manufacturer = json['manufacturer'];
    this.quantity = json['quantity'];
    this.status = ProductStatus.values[json['status']];
    this.voltage = json['voltage'];
    this.mounting = Mounting.values[json['mounting']];
    this.package = json['package'];
    this.power = json['power'];
    this.value = json['value'];
    this.tolerance = json['tolerance'];
    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
  }
}
