import 'package:guadalajarav2/enums/subCategories.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumFuseType.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

class ProtectionCircuit extends Product {
  double? voltage;
  Mounting? mounting;
  String? package;
  double? current;
  double? power;
  double? voltageBreakdown;
  double? voltageReverse;
  double? voltageClamping;
  String? channelType;
  FuseType? fuseType;
  double? currentTrip;
  double? timeTrip;
  ProtectionCircuit(
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
    this.current,
    this.power,
    this.voltageBreakdown,
    this.voltageReverse,
    this.voltageClamping,
    this.channelType,
    SubCategory subCategory, {
    this.fuseType,
    this.currentTrip,
    this.timeTrip,
  }) : super(
          category,
          description,
          unitPrice,
          mpn,
          manufacturer,
          quantity,
          status,
          lastEdited,
          subCategory: subCategory,
        );
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
      current.toString(),
      power.toString(),
      voltageBreakdown.toString(),
      voltageReverse.toString(),
      voltageClamping.toString(),
      channelType.toString(),
      subCategory!.toString(),
      fuseType.toString(),
      currentTrip.toString(),
      timeTrip.toString(),
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
        'current': current,
        'power': power,
        'voltageBreakdown': voltageBreakdown,
        'voltageReverse': voltageReverse,
        'voltageClamping': voltageClamping,
        'channelType': channelType,
        'lastEdited': lastEdited.toString(),
        'subCategory': subCategory != null ? subCategory!.index : null,
        'fuseType': fuseType != null ? fuseType!.index : null,
        'currentTrip': currentTrip,
        'timeTrip': timeTrip,
      };
  ProtectionCircuit.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.category = Category.protection_circuits;
    this.description = json['description'];
    this.unitPrice = json['unitPrice'];
    this.mpn = json['mpn'];
    this.manufacturer = json['manufacturer'];
    this.quantity = json['quantity'];
    this.status = ProductStatus.values[json['status']];
    this.voltage = json['voltage'];
    this.mounting = Mounting.values[json['mounting']];
    this.package = json['package'];
    this.current = json['current'];
    this.power = json['power'];
    this.voltageBreakdown = json['voltageBreakdown'];
    this.voltageReverse = json['voltageReverse'];
    this.voltageClamping = json['voltageClamping'];
    this.channelType = json['channelType'];

    this.fuseType =
        json['fuseType'] != null ? FuseType.values[json['fuseType']!] : null;
    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
    this.subCategory = json['subCategory'] != null
        ? SubCategory.values[json['subCategory']!]
        : null;

    this.currentTrip = json['currentTrip'];
    this.timeTrip = json['timeTrip'];
  }
}
