import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/editProductDialog.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'package:guadalajarav2/inventory/productBOM.dart';
import 'package:guadalajarav2/inventory/searchMenu.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class SearchB extends StatefulWidget {
  @override
  _SearchBState createState() => _SearchBState();
}

class _SearchBState extends State<SearchB> {
  List<dynamic> iconValues = [
    Icon(Icons.search_rounded, color: white),
    Icon(
      Icons.file_upload_rounded,
      color: white,
    ),
  ];
  List<String> stringValues = ['text', 'file'];

  String selection = 'text';
  TextEditingController searchController = new TextEditingController();
  Widget cB = SizedBox();
  Widget? clearButton;

  @override
  void initState() {
    clearButton = TextButton(
      child: Center(
        child: Icon(
          Icons.close_rounded,
          color: gray,
          size: height * 0.02,
        ),
      ),
      onPressed: () {
        setState(
          () {
            searchController.text = '';
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.0225),
      child: Container(
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: searchOptionButton(),
            ),
            Expanded(
              flex: 8,
              child: Material(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: lightGrey,
                  focusColor: lightGrey,
                  splashColor: lightGrey,
                  onTap: () => null,
                  onHover: (bool isHovering) {
                    if (isHovering) {
                      setState(() {
                        cB = clearButton!;
                      });
                    } else {
                      setState(() {
                        cB = SizedBox();
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: searchTextField(searchController),
                      ),
                      Expanded(
                        flex: 1,
                        child: cB,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchOptionButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DropdownButton<String>(
        underline: SizedBox(),
        isExpanded: true,
        selectedItemBuilder: (BuildContext context) => iconValues
            .map(
              (dynamic value) => Container(
                decoration: BoxDecoration(
                  color: gray,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: value,
                ),
              ),
            )
            .toList(),
        icon: SizedBox(),
        items: stringValues
            .map(
              (String value) => DropdownMenuItem<String>(
                child: Center(
                  child: AutoSizeText(
                    value,
                    maxLines: 1,
                    minFontSize: 1,
                    style: informationEdit,
                  ),
                ),
                value: value,
              ),
            )
            .toList(),
        value: selection,
        onChanged: (String? value) async {
          setState(
            () {
              selection = value!;
            },
          );
          if (selection == 'file') {
            // bool kisWeb = true;
            // await FilePicker.platform;

            // print();
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              PlatformFile pFile = result.files.first;
              Uint8List bytes = pFile.bytes!;
              String csvInfo = String.fromCharCodes(bytes);
              List<List<dynamic>> rowsAsListOfValues =
                  const CsvToListConverter().convert(csvInfo);
              Map<String, Map<String, dynamic>> bomProducts = {};
              Map<String, int> bomQuantities = {};
              for (List<dynamic> l in rowsAsListOfValues.sublist(1)) {
                Map<String, dynamic> productValues = {};
                List<dynamic> product = l.sublist(1);
                if (product.length < 1) {
                  continue;
                }
                String description = product[0].toString();
                String manufacturer = product[2].toString();
                String mpn = product[3].toString();
                String mpn1 = product[4].toString();
                String mpn2 = product[5].toString();
                if (mpn.isEmpty) {
                  continue;
                } else {
                  int quantity = int.parse(product[6].toString());
                  productValues.putIfAbsent('description', () => description);
                  productValues.putIfAbsent('manufacturer', () => manufacturer);
                  productValues.putIfAbsent('mpn1', () => mpn1);
                  productValues.putIfAbsent('mpn2', () => mpn2);
                  // productValues.putIfAbsent('quantity', () => quantity);
                  bomProducts.putIfAbsent(mpn, () => productValues);
                  bomQuantities.putIfAbsent(mpn, () => quantity);
                  bomQuantities.putIfAbsent(mpn1, () => quantity);
                  bomQuantities.putIfAbsent(mpn2, () => quantity);
                }
              }

              Map<String, Map<String, dynamic>> dbQuantities =
                  await searchProductsByBOMSInDatabase(
                      bomQuantities.map((key, value) => MapEntry(key, key)));
              // print(dbQuantities);

              containerDialog(
                context,
                false,
                ProductBOMScreen(
                  bomProducts: bomProducts,
                  bomQuantities: bomQuantities,
                  dbData: dbQuantities,
                ),
                0.75,
              );
            }
          }
        },
      ),
    );
  }

  Widget searchTextField(TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: AutoSizeTextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: selection == 'file' ? '' : 'Search by MPN...',
          hintStyle: TextStyle(fontStyle: FontStyle.italic),
          fillColor: lightGrey,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          focusColor: lightGrey,
        ),
        style: textfieldSearchMenu,
        minFontSize: 2,
        maxFontSize: 40,
        onEditingComplete: () async {
          if (selection == 'text') {
          } else {
            setState(() {
              selection = 'text';
            });
          }
          List<Product> components = [];
          if (controller.text.isEmpty) {
            components = await searchProductsByCategoryInDatabase(
                selectedInventoryCategory);
          } else {
            components = await searchProductByMPNInDatabase(controller.text);
          }

          if (components.length == 1) {
            containerDialog(
              context,
              false,
              EditComponentScreen(
                product: components[0],
              ),
              0.75,
            );
          } else if (components.length > 1) {
            inventoryState.setState(() {
              products = components;
              if (controller.text.isNotEmpty) {
                isSearchingSearchBar = true;
              }
            });
          } else {
            inventoryState.setState(() {
              isSearchingSearchBar = false;
            });
            containerDialog(
              context,
              false,
              AlertNotification(
                icon: Icons.warning_amber_rounded,
                color: red,
                str: 'No Components with that MPN',
              ),
              0.75,
            );
          }
        },
      ),
    );
  }
}
