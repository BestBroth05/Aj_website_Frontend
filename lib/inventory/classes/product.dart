import 'package:guadalajarav2/enums/subCategories.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';

abstract class Product {
  Category? category;
  String? description;
  double? unitPrice;
  String? mpn;
  String? manufacturer;
  int? quantity;
  ProductStatus? status;
  DateTime? lastEdited;
  SubCategory? subCategory;
  Product(
    this.category,
    this.description,
    this.unitPrice,
    this.mpn,
    this.manufacturer,
    this.quantity,
    this.status,
    this.lastEdited, {
    this.subCategory,
  });

  List<String> getAllAttributes();
  Map<String, dynamic> toJson();
  Product.fromJson(Map<String, dynamic> json);
}
