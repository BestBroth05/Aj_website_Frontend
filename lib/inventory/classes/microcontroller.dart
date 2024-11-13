import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

class Microcontroller extends Product {
  double? voltage;
  Mounting? mounting;
  String? package;
  double? speed;
  int? pinCount;
  double? flash;
  double? ram;
  Microcontroller(
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
        'speed': speed,
        'pinCount': pinCount,
        'flash': flash,
        'ram': ram,
        'lastEdited': lastEdited.toString()
      };
  Microcontroller.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.category = Category.microcontrollers;
    this.description = json['description'];
    this.unitPrice = json['unitPrice'];
    this.mpn = json['mpn'];
    this.manufacturer = json['manufacturer'];
    this.quantity = json['quantity'];
    this.status = ProductStatus.values[json['status']];
    this.voltage = json['voltage'];
    this.mounting = Mounting.values[json['mounting']];
    this.package = json['package'];
    this.speed = json['speed'];
    this.pinCount = json['pinCount'];
    this.flash = json['flash'];
    this.ram = json['ram'];
    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
  }
}
