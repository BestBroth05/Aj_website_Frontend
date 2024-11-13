import 'package:flutter/material.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'package:guadalajarav2/inventory/orderButton.dart';
import 'package:guadalajarav2/inventory/searchBar.dart';
import 'package:guadalajarav2/inventory/searchMenu.dart';
import 'package:guadalajarav2/utils/tools.dart';

bool isInventory = false;

class InventoryScreen extends StatefulWidget {
  @override
  InventoryState createState() => InventoryState();
}

class InventoryState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isInventory = true;
    return Row(
      children: [
        Expanded(
          flex: 13,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.005,
              vertical: width * 0.005,
            ),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: InventorySearchMenu(),
            ),
          ),
        ),
        Expanded(
          flex: 87,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.005,
              vertical: height * 0.005,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 15,
                          child: OrderButton(),
                        ),
                        Expanded(flex: 70, child: SizedBox()),
                        Expanded(
                          flex: 15,
                          child: SearchB(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 92,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: InventoryList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
