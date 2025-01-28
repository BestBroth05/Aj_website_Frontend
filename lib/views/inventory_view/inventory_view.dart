import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/addNewComponent.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/inventory/searchMenu.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/inventory_part/inventory_part_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_body.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_bottom_bar/inventory_bottom_bar.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_search_menu.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_table.dart';

class InventoryView extends StatefulWidget {
  InventoryView({Key? key}) : super(key: key);

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  VoltageUnit voltageUnit = VoltageUnit.v;

  Category category = Category.capacitors;

  Map<String, String?> filters = {};

  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      // openDialog(
      //   context,
      //   container: BasicTextDialog('Loading ${category.name.toLowerCase()}...'),
      // );
      changeCategory(category);
      // Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: Column(
        children: [
          DashboardTopBar(selected: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomInventorySearchMenu(
                      category: category,
                      setParts: (products) => setState(
                        () => InventoryBody.parts = products,
                      ),
                      onCategoryChanged: (dynamic _category) =>
                          changeCategory(_category),
                    ),
                  ),
                  // Expanded(
                  //   flex: 3,
                  //   child: InventorySearchMenu(),
                  // ),
                  Expanded(
                    flex: 17,
                    child: Column(
                      children: [
                        Card(
                          elevation: 5,
                          child: InventoryBottomBar(
                            category: category,
                            addFilter: (key, value) async {
                              openDialog(
                                context,
                                container: BasicTextDialog('Sorting...'),
                                block: true,
                              );
                              filters.clear();
                              setState(
                                () => filters[key] =
                                    value == 'None' ? null : value,
                              );

                              if (filters.entries.length > 0) {
                                List<Product> products = InventoryBody.parts;
                                String key = filters.entries.first.key;
                                String? value = filters.entries.first.value;

                                products.sort(
                                  (Product a, Product b) {
                                    String as = a.toJson()[key].toString();
                                    String bs = b.toJson()[key].toString();
                                    String ampn = a.toJson()['mpn'].toString();
                                    String bmpn = b.toJson()['mpn'].toString();
                                    if (value != null) {
                                      if (value == 'A-Z' ||
                                          value == 'Low - High') {
                                        return as.compareTo(bs);
                                      } else {
                                        return -1 * as.compareTo(bs);
                                      }
                                    } else {
                                      return ampn.compareTo(bmpn);
                                    }
                                  },
                                );
                                setState(() {
                                  InventoryBody.parts = products;
                                });
                              }
                              Navigator.pop(context);
                            },
                            filters: filters,
                            searchFunction: (String text) async =>
                                searchFunction(text),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 5,
                            child: InventoryTable(
                              category: category,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> searchFunction(String text) async {
    if (text.isNotEmpty) {
      openDialog(
        context,
        container: BasicTextDialog('Searching\n$text'),
        block: true,
      );

      List<Product> parts = await searchProductByMPNInDatabase(text);
      // print(parts);
      Navigator.pop(context);
      if (parts.length == 1) {
        openDialog(
          context,
          container: NewComponentScreen(
            category: parts.first.category!,
            product: parts.first,
            isEditing: false,
          ),
        );
      } else if (parts.length > 1) {
        InventoryBody.parts = parts;
      } else {
        openDialog(context, container: TimedDialog(text: 'No component found'));
      }
    } else {
      openDialog(
        context,
        container: BasicTextDialog('Loading...'),
        block: true,
      );
      InventoryBody.parts = await searchProductsByCategoryInDatabase(category);
      Navigator.pop(context);
    }

    setState(() {});
  }

  Future<void> changeCategory(Category newCategory) async {
    openDialog(
      context,
      container: BasicTextDialog(
        'Loading ${newCategory.name.toLowerCase()}...',
      ),
      block: true,
    );
    InventoryBody.parts = await searchProductsByCategoryInDatabase(newCategory);
    category = newCategory;
    selectedCategory = newCategory;
    setState(() {
      InventoryTable.header = Map.fromIterable(
        category.allHeaders,
        key: (element) => element,
        value: (element) => 2,
      );
    });
    Navigator.pop(context);
  }

  void search(String text) async {
    openDialog(
      context,
      container: BasicTextDialog(
        'Searching for\n$text...',
      ),
      block: true,
    );
    List<Product> parts = await searchProductByMPNInDatabase(text);
    Navigator.pop(context);
    if (parts.length == 1) {
      openDialog(
        context,
        container: InventoryPartDialog(
          parts[0],
          updateParts: (components) => setState(
            () => InventoryBody.parts = components,
          ),
        ),
      );
    } else if (parts.length > 1) {
      setState(() {
        InventoryBody.parts = parts;
        InventoryTable.header = {};
        Set<Category> categories = {};
        InventoryBody.parts.forEach((element) {
          categories.add(element.category!);
        });

        for (Category category in categories) {
          InventoryTable.header.addAll(Map.fromIterable(
            category.allHeaders,
            key: (element) => element,
            value: (element) => 2,
          ));
        }
      });
    } else {
      openDialog(
        context,
        container: TimedDialog(
          text: '$text\nNot found',
        ),
      );
    }
  }
}
