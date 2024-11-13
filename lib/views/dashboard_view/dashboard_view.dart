import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import 'package:guadalajarav2/views/dashboard_view/dashboard_inventory_chart.dart';
import 'package:guadalajarav2/views/dashboard_view/dashboard_tile.dart';

class DashBoardView extends StatefulWidget {
  DashBoardView({Key? key}) : super(key: key);

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  int totalComponents = 0;
  double inventoryCategorySize = 30;
  Map<String, int> componentCategoriesAmount = Map.fromIterable(
    Category.values,
    key: (element) => (element as Category).name,
    value: (element) => 0,
  );
  bool isAllLoaded = false;
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    for (Category category in Category.values) {
      int amount = (await searchProductsByCategoryInDatabase(category)).length;
      totalComponents += amount;
      componentCategoriesAmount[category.name] = amount;
    }
    setState(() {
      isAllLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          DashboardTopBar(selected: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: height,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DashboardTile(
                                height: 200,
                                heightEnlarged: inventoryCategorySize *
                                    Category.values.length,
                                backgroundColor: white,
                                primaryWidget: DashboardInventoryChart(),
                                enlargedWidget: Column(
                                  children: List.generate(
                                    Category.values.length,
                                    (index) {
                                      MapEntry<String, int> entry =
                                          componentCategoriesAmount.entries
                                              .elementAt(index);
                                      String key = entry.key;

                                      int amount = entry.value;

                                      return Expanded(
                                        child: Container(
                                          height: inventoryCategorySize,
                                          color: index % 2 != 0
                                              ? white
                                              : backgroundColor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText(key),
                                              AutoSizeText('$amount')
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
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
}
