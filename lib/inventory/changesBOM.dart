import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'package:guadalajarav2/inventory/searchMenu.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ChangesBOMNotification extends StatefulWidget {
  final List<List<dynamic>> components;

  ChangesBOMNotification({required this.components});

  @override
  _ChangesBOMState createState() => _ChangesBOMState();
}

class _ChangesBOMState extends State<ChangesBOMNotification> {
  List<List<dynamic>> components = [];

  @override
  void initState() {
    components = widget.components;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      height: height * 0.6,
      width: width * 0.25,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.002,
                ),
                child: Center(
                  child: AutoSizeText(
                    'Changes to be made in Database',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: white,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: height * 0.015,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      'MPN',
                      style: subtitleEdit,
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: AutoSizeText(
                      'Quantity',
                      textAlign: TextAlign.center,
                      style: subtitleEdit,
                    ),
                  ),
                  Expanded(child: Container()),
                  Expanded(
                    child: AutoSizeText(
                      'Needed',
                      textAlign: TextAlign.center,
                      style: subtitleEdit,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: height * 0.01,
              ),
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    tileRow(index),
                itemCount: components.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: red,
                      ),
                      child: AutoSizeText('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: green,
                      ),
                      child: AutoSizeText('Confirm'),
                      onPressed: () async {
                        if (await removeComponentsbyBOMInDatabase(components)) {
                          Navigator.pop(inventoryState.context);
                          Navigator.pop(inventoryState.context);

                          containerDialog(
                            inventoryState.context,
                            true,
                            AlertNotification(
                              icon: Icons.check_rounded,
                              color: green,
                              str: 'Database Updated',
                            ),
                            0.5,
                          );
                          List<Product> componentsInDB =
                              await searchProductsByCategoryInDatabase(
                                  selectedCategory);

                          inventoryState.setState(() {
                            products = componentsInDB;
                          });
                        } else {
                          containerDialog(
                            context,
                            true,
                            AlertNotification(
                              icon: Icons.error_rounded,
                              color: red,
                              str: 'Error while\ntrying to update',
                            ),
                            0.5,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ListTile tileRow(int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Container(
        height: height * 0.05,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: AutoSizeText(
                components[index][0],
                style: TextStyle(
                  color: darkGrey,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            Expanded(
              child: AutoSizeText(
                '${components[index][1]}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkGrey,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            Expanded(child: VerticalDivider()),
            Expanded(
              child: AutoSizeText(
                '${components[index][2]}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: darkGrey,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
