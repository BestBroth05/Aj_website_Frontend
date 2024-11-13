import 'package:guadalajarav2/enums/subCategories.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

class DiscreteSemiconductor extends Product {
  double? voltage;
  Mounting? mounting;
  String? package;
  double? current;
  double? speed;
  double? voltageBreakdown;
  double? voltageReverse;
  double? voltageClamping;
  double? loadCapacitance;
  String? channelType;
  double? voltageForward;
  double? frequency;
  int? vgs;
  DiscreteSemiconductor(
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
    this.speed,
    this.voltageBreakdown,
    this.voltageReverse,
    this.voltageClamping,
    this.loadCapacitance,
    this.channelType,
    SubCategory subCategory, {
    this.voltageForward,
    this.frequency,
    this.vgs,
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
      speed.toString(),
      voltageBreakdown.toString(),
      voltageReverse.toString(),
      voltageClamping.toString(),
      loadCapacitance.toString(),
      channelType.toString(),
      subCategory!.toString(),
      voltageForward!.toString(),
      frequency!.toString(),
      vgs!.toString(),
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
        'speed': speed,
        'voltageBreakdown': voltageBreakdown,
        'voltageReverse': voltageReverse,
        'voltageClamping': voltageClamping,
        'loadCapacitance': loadCapacitance,
        'channelType': channelType,
        'lastEdited': lastEdited.toString(),
        'subCategory': subCategory != null ? subCategory!.index : null,
        'voltageForward': voltageForward,
        'frequency': frequency,
        'vgs': vgs,
      };
  DiscreteSemiconductor.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.category = Category.discrete_semiconductors;
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
    this.speed = json['speed'];
    this.voltageBreakdown = json['voltageBreakdown'];
    this.voltageReverse = json['voltageReverse'];
    this.voltageClamping = json['voltageClamping'];
    this.loadCapacitance = json['loadCapacitance'];
    this.channelType = json['channelType'];

    this.voltageForward = json['voltageForward'];
    this.frequency = json['frequency'];
    this.vgs = json['vgs'];

    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
    this.subCategory = json['subCategory'] != null
        ? SubCategory.values[json['subCategory']!]
        : null;
  }
}
