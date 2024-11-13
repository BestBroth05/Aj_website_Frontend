import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'package:guadalajarav2/loadingScreen.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class OrderButton extends StatefulWidget {
  @override
  _OrderButton createState() => _OrderButton();
}

class _OrderButton extends State<OrderButton> {
  List<String> orderValues = ['MPN', 'Description', 'Quantity', 'Manufacturer'];
  String orderValue = 'MPN';
  bool isAscending = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: AutoSizeText(
            'Sorted by:',
            textAlign: TextAlign.center,
            style: informationEdit,
            minFontSize: 2,
            maxLines: 1,
          ),
        ),
        Expanded(
          flex: 2,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DropdownButton<String>(
              icon: SizedBox(),
              underline: SizedBox(),
              isExpanded: true,
              selectedItemBuilder: (BuildContext context) => orderValues
                  .map(
                    (String value) => Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.01),
                      padding: EdgeInsets.symmetric(horizontal: width * 0.005),
                      decoration: BoxDecoration(
                        color: lightDarkGrey,
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          '$value',
                          minFontSize: 2,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              items: orderValues
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        child: AutoSizeText(value, minFontSize: 1, maxLines: 1),
                      ),
                    ),
                  )
                  .toList(),
              value: orderValue,
              onChanged: (String? newValue) {
                setState(() {
                  orderValue = newValue!;
                });
                containerDialog(
                  context,
                  true,
                  LoadingScreen(text: 'Sorting Components'),
                  0.5,
                );
                inventoryState.setState(() {
                  switch (orderValue) {
                    case 'MPN':
                      products.sort((a, b) => a.mpn!.compareTo(b.mpn!));
                      break;
                    case 'Description':
                      products.sort(
                          (a, b) => a.description!.compareTo(b.description!));
                      break;
                    case 'Quantity':
                      products
                          .sort((a, b) => a.quantity!.compareTo(b.quantity!));
                      break;
                    case 'Manufacturer':
                      products.sort(
                          (a, b) => a.manufacturer!.compareTo(b.manufacturer!));
                      break;
                  }
                  if (!isAscending) {
                    products = products.reversed.toList();
                  }
                });

                Navigator.pop(context);
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.025),
            child: TextButton(
              child: Center(
                child: Icon(
                  !isAscending
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                  color: darkGrey,
                ),
              ),
              onPressed: () {
                setState(() {
                  isAscending = !isAscending;
                });
                inventoryState.setState(() {
                  products = products.reversed.toList();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
