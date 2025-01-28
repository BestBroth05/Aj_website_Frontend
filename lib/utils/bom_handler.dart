import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/bom_part.dart';
import 'package:guadalajarav2/classes/mpn.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/enums/subCategories.dart';
import 'package:guadalajarav2/extensions/excel_extension.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/utils/excel_handler.dart';
import 'package:guadalajarav2/views/bom_view/bom_selection_dialog.dart';
import 'package:guadalajarav2/views/dialogs/loading_dialog.dart';

Future<List<BomPart>?> uploadBomFile(BuildContext context) async {
  Excel? excel;
  try {
    excel = await pickExcelFile();
  } on Exception {
    return null;
  }
  if (excel != null) {
    try {
      List<List<Data?>>? table = excel.table;
      if (table != null) {
        Map<String, String> mpns = {};
        List<BomPart> parts = [];
        for (List<Data?> row in table) {
          BomPart part = BomPart(values: row.sublist(1));
          parts.add(part);
          for (Mpn? mpn in part.allMPN) {
            if (mpn != null) {
              mpns.putIfAbsent(mpn.mpn, () => mpn.mpn);
            }
          }
        }

        Map<String, Map<String, dynamic>> dbData =
            await searchProductsByBOMSInDatabase(mpns);
        int i = 0;
        for (BomPart part in parts) {
          part.mpn = searchMpnInData(part.mpn.mpn, dbData)!;
          List<Product?> alternatives = [];
          if (dbData[part.mpn.mpn] != null) {
            List<Product> components =
                await searchProductByMPNInDatabase(part.mpn.mpn);
            if (components.length == 1) {
              Product component = components[0];
              Map<String, dynamic> data = component.toJson();
              alternatives =
                  await searchSimilarParts(component.category!, data);
            }
          }
          if (part.alternative1 != null) {
            part.alternative1 = searchMpnInData(part.alternative1!.mpn, dbData);
          }
          if (part.alternative2 != null) {
            part.alternative2 = searchMpnInData(part.alternative2!.mpn, dbData);
          }

          if (alternatives.length > 0) {
            if (part.alternative1 == null) {
              Product alt = alternatives.removeAt(0)!;
              part.alternative1 = Mpn(mpn: alt.mpn!)
                ..quantity = alt.quantity
                ..unitPrice = alt.unitPrice;
            }
            if (alternatives.length > 0) {
              if (part.alternative2 == null) {
                Product alt = alternatives.removeAt(0)!;
                part.alternative2 = Mpn(mpn: alt.mpn!)
                  ..quantity = alt.quantity
                  ..unitPrice = alt.unitPrice;
              }
            }
          }
          i += 1;
          print('completed $i of ${parts.length}');
          // print(part);
        }
        return parts;
      }
    } on Exception catch (e) {
      print(e);
    }
  }
  return null;
}

Future<Map<String, Map<String, dynamic>>> getValuesFromBoms(
  Map<int, Map<String, dynamic>?> boms,
) async {
  Map<String, Map<String, dynamic>> components = {};
  for (Map<String, dynamic>? bom in BomSelectionDialog.boms.values) {
    if (bom == null) {
      continue;
    } else {
      bom['times'] =
          int.tryParse(BomSelectionDialog.controllers[bom['key']]!.text) ?? 1;
      Excel excel = Excel.decodeBytes(bom['data']);

      List<Map<String, dynamic>> componentsInExcel =
          await getValuesFromExcel(excel, true);

      componentsInExcel.forEach((element) {
        element['required'] *= bom['times'];
        element['designators'] = {
          bom['key']: element['designator'].split(', ')
        };

        if (components.containsKey(element['mpn'])) {
          components[element['mpn']]!['required'] += element['required'];
          if (components[element['mpn']]!['designators'][bom['key']] != null) {
            (components[element['mpn']]!['designators'][bom['key']] as List)
                .addAll(element['designator'].split(', '));
          } else {
            components[element['mpn']]!['designators'][bom['key']] =
                element['designator'].split(', ');
          }
          // print(element['mpn'] + ' repeated');
        } else {
          components[element['mpn']] = element;
          // print(element['mpn'] + ' not repeated');
        }
      });
    }
  }

  Map<String, Map<String, dynamic>> dbData =
      await searchProductsByBOMSInDatabase(
    components.map(
      (key, value) => MapEntry<String, String>(key, key),
    ),
  );

  // components.forEach((key, value) => print(key));

  dbData.forEach((key, value) {
    // print('$key $value');
    key = key.replaceAll(' ', '');

    value.forEach((key2, value2) {
      components[key]![key2] = value2;
    });
  });
  // components.forEach((key, value) {print(key)})

  return components;
}

Future<List<Map<String, dynamic>>> getValuesFromExcel(
  Excel excel,
  bool alreadyAlt,
) async {
  try {
    List<String> headers = [
      'designator',
      'description',
      'mounting_type',
      'package',
      'manufacturer',
      'mpn',
      'alt1',
      'alt2',
      'required',
    ];

    List<List<Data?>>? table = excel.table;
    if (table != null) {
      List<Map<String, dynamic>> parts = [];
      for (List<Data?> row in table) {
        Map<String, dynamic> part = {};
        int i = 0;
        for (Data? cell in row.sublist(1)) {
          if (cell == null || cell.value.toString().isEmpty) {
            part[headers[i]] = null;
          } else {
            if (i == 5) {
              part[headers[i]] = cell.value.toString();
            } else if ((i == 6 || i == 7) && alreadyAlt) {
              List<Product> p = await searchProductByMPNInDatabase(
                cell.value.toString(),
              );
              if (p.length > 0) {
                part[headers[i]] = p.first.toJson();
                part[headers[i]]['controller'] = TextEditingController();
              }
            } else {
              part[headers[i]] = cell.value;
            }
          }
          i += 1;
          if (i == headers.length) {
            break;
          }
        }

        parts.add(part);
      }
      // print(parts);
      return parts;
    } else {}
  } on Exception catch (e) {
    print(e);
  }
  return [];
}

Future<List<Map<String, dynamic>>> getAllValuesFromDatabase(
  List<String> mpns,
) async {
  List<Map<String, dynamic>> values = [];

  for (String mpn in mpns) {
    List<Product> products = await searchProductByMPNInDatabase(mpn);
    Map<String, dynamic> productValues = {'mpn': mpn};
    if (products.length == 1) {
      Product product = products[0];
      productValues['unit_price'] = product.unitPrice;
      productValues['unitPrice'] = product.unitPrice;
      productValues['quantity'] = product.quantity;
      // print(product.toJson());
      List<Product?> alternatives = await searchSimilarParts(
        product.category!,
        product.toJson(),
      );
      int i = 0;

      for (Product? alternative in alternatives) {
        if (alternative != null) {
          i += 1;
          if (i == 2) {
            if (alternative.mpn != productValues['alt1']) {
              productValues['alt$i'] = alternative.mpn;
              productValues['alt${i}_quantity'] = alternative.quantity;
              productValues['alt${i}_unit_price'] = alternative.unitPrice;
              productValues['alternative$i'] = alternative.toJson();
            }
          } else {
            productValues['alt$i'] = alternative.mpn;
            productValues['alt${i}_quantity'] = alternative.quantity;
            productValues['alt${i}_unit_price'] = alternative.unitPrice;
            productValues['alternative$i'] = alternative.toJson();
          }
        }
      }
    }
    values.add(productValues);
    LoadingDialog.value += 1;
  }

  print(values);

  return values;
}

// Future<List<BomPart>?> uploadBomFile(BuildContext context) async {
//   Excel? excel;
//   try {
//     excel = await pickExcelFile();
//   } on Exception catch (e) {
//     return null;
//   }
//   if (excel != null) {
//     try {
//       List<List<Data?>>? table = excel.table;
//       if (table != null) {
//         Map<String, String> mpns = {};
//         List<BomPart> parts = [];
//         for (List<Data?> row in table) {
//           BomPart part = BomPart(values: row.sublist(1));
//           parts.add(part);
//           for (Mpn? mpn in part.allMPN) {
//             if (mpn != null) {
//               mpns.putIfAbsent(mpn.mpn, () => mpn.mpn);
//             }
//           }
//         }

//         Map<String, Map<String, dynamic>> dbData =
//             await searchProductsByBOMSInDatabase(mpns);
//         int i = 0;
//         for (BomPart part in parts) {
//           part.mpn = searchMpnInData(part.mpn.mpn, dbData)!;
//           List<Mpn?> alternatives = [];
//           if (dbData[part.mpn.mpn] != null) {
//             List<Product> components =
//                 await searchProductByMPNInDatabase(part.mpn.mpn);
//             if (components.length == 1) {
//               Product component = components[0];
//               Map<String, dynamic> data = component.toJson();
//               alternatives =
//                   await searchSimilarParts(component.category!, data);
//             }
//           }
//           if (part.alternative1 != null) {
//             part.alternative1 = searchMpnInData(part.alternative1!.mpn, dbData);
//           }
//           if (part.alternative2 != null) {
//             part.alternative2 = searchMpnInData(part.alternative2!.mpn, dbData);
//           }

//           if (alternatives.length > 0) {
//             if (part.alternative1 == null) {
//               part.alternative1 = alternatives.removeAt(0);
//             }
//             if (alternatives.length > 0) {
//               if (part.alternative2 == null) {
//                 part.alternative2 = alternatives.removeAt(0);
//               }
//             }
//           }
//           i += 1;
//           print('completed $i of ${parts.length}');
//           // print(part);
//         }
//         return parts;
//       }
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
//   return null;
// }

Mpn? searchMpnInData(String mpnString, Map<String, Map<String, dynamic>> data) {
  Map<String, dynamic>? entry = data[mpnString];
  Mpn mpn = Mpn(mpn: mpnString);
  if (entry != null) {
    mpn.quantity = entry['quantity'];
    mpn.unitPrice = entry['unitPrice'];
  }
  return mpn;
}

Future<List<Product?>> searchSimilarParts(
  Category category,
  Map<String, dynamic> data,
) async {
  int? subCategoryIndex = data['subCategory'];

  SubCategory? subCategory =
      subCategoryIndex != null ? SubCategory.values[subCategoryIndex] : null;

  Map<String, String>? filtersTypes = category.getFilters(
    subCategory: subCategory,
    params: data,
  );

  if (filtersTypes == null) return [];

  Map<String, dynamic> filters = {};

  filtersTypes.forEach((key, value) {
    filters[key] = {'value': data[key], 'type': value};
  });

  List<Product> alternatives =
      await searchProductsByFiltersInDatabase(category, filters);

  alternatives.removeWhere(
    (element) => element.mpn == data['mpn'],
  );

  // print('$data $alternatives');
  return alternatives.length > 2 ? alternatives.sublist(0, 2) : alternatives;
}
