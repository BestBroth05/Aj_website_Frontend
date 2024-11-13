import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

class Connector extends Product {
  double? voltage;
  Mounting? mounting;
  double? current;
  int? pinCount;
  double? pitch;
  int? row;
  String? contactType;
  Connector(
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
    this.current,
    this.pinCount,
    this.pitch,
    this.row,
    this.contactType,
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
      current.toString(),
      pinCount.toString(),
      pitch.toString(),
      row.toString(),
      contactType.toString(),
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
        'current': current,
        'pinCount': pinCount,
        'pitch': pitch,
        'row': row,
        'contactType': contactType,
        'lastEdited': lastEdited.toString()
      };
  Connector.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.category = Category.connectors;

    this.description = json['description'];
    this.unitPrice = json['unitPrice'];
    this.mpn = json['mpn'];
    this.manufacturer = json['manufacturer'];
    this.quantity = json['quantity'];
    this.status = ProductStatus.values[json['status']];
    this.voltage = json['voltage'];
    this.mounting = Mounting.values[json['mounting']];
    this.current = json['current'];
    this.pinCount = json['pinCount'];
    this.pitch = json['pitch'];
    this.row = json['row'];
    this.contactType = json['contactType'];
    this.lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.tryParse(json['lastEdited']);
  }
}
