import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

class Pcb extends Product {
  Pcb(
    Category category,
    String description,
    double unitPrice,
    String mpn,
    String manufacturer,
    int quantity,
    ProductStatus status,
    DateTime lastEdited,
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
    ];
  }

  Map<String, dynamic> toJson() => {
        'mpn': mpn,
        'description': description,
        'unitPrice': unitPrice,
        'manufacturer': manufacturer,
        'quantity': quantity,
        'status': ProductStatus.values.indexOf(status!),
        'lastEdited': lastEdited.toString()
      };
  Pcb.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.category = Category.pcbs;
    this.description = json['description'];
    this.unitPrice = json['unitPrice'];
    this.mpn = json['mpn'];
    this.manufacturer = json['manufacturer'];
    this.quantity = json['quantity'];
    this.status = ProductStatus.values[json['status']];
    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
  }
}
