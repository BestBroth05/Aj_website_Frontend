import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

class IntegratedCircuit extends Product {
  double? voltage;
  Mounting? mounting;
  String? package;
  double? current;
  double? power;
  double? speed;
  int? pinCount;
  double? flash;
  double? ram;
  IntegratedCircuit(
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
    this.speed,
    this.pinCount,
    this.flash,
    this.ram,
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
      current.toString(),
      power.toString(),
      speed.toString(),
      pinCount.toString(),
      flash.toString(),
      ram.toString(),
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
        'speed': speed,
        'pinCount': pinCount,
        'flash': flash,
        'ram': ram,
        'lastEdited': lastEdited.toString()
      };
  IntegratedCircuit.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.category = Category.integrated_circuits;
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
    this.speed = json['speed'];
    this.pinCount = json['pinCount'];
    this.flash = json['flash'];
    this.ram = json['ram'];
    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
  }
}
