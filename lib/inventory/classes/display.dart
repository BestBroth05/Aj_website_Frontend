import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

class Display extends Product {
  double? voltage;
  double? current;
  String? interface;
  String? resolution;
  Display(
    Category category,
    String description,
    double unitPrice,
    String mpn,
    String manufacturer,
    int quantity,
    ProductStatus status,
    DateTime lastEdited,
    this.voltage,
    this.current,
    this.interface,
    this.resolution,
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
      current.toString(),
      interface.toString(),
      resolution.toString(),
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
        'current': current,
        'interface': interface,
        'resolution': resolution,
        'lastEdited': lastEdited.toString()
      };
  Display.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.category = Category.displays;
    this.description = json['description'];
    this.unitPrice = json['unitPrice'];
    this.mpn = json['mpn'];
    this.manufacturer = json['manufacturer'];
    this.quantity = json['quantity'];
    this.status = ProductStatus.values[json['status']];
    this.voltage = json['voltage'];
    this.current = json['current'];
    this.interface = json['interface'];
    this.resolution = json['resolution'];
    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
  }
}
