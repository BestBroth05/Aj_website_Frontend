import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/excel_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_dialog_tile.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_header.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_view.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AJCartDialog extends StatefulWidget {
  AJCartDialog({Key? key}) : super(key: key);

  @override
  State<AJCartDialog> createState() => _AJCartDialogState();
}

class _AJCartDialogState extends State<AJCartDialog> {
  Map<String, int> headers = {
    'MPN': 2,
    'designator': 2,
    'description': 2,
    'manufacturer': 2,
    'provider': 2,
    'required': 1,
    'going to be used': 1,
    'total cost': 1,
  };

  List<Map<String, dynamic>> parts = [];

  @override
  void initState() {
    super.initState();
    for (Map<String, dynamic> part in AJCartView.parts.values.toList()) {
      if (part['selected'] == null) {
        continue;
      } else {
        Map<String, dynamic> finalPart = {};
        for (String key in headers.keys) {
          key = key.toLowerCase().split(' ').join('_');
          finalPart[key] = part[key];
        }
        finalPart['provider'] =
            part['selected'].split('_')[0].toString().toTitle();
        parts.add(finalPart);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: height * 0.95,
        width: width * 0.9,
        child: Column(
          children: [
            SizedBox(
              height: 80,
              width: width,
              child: Row(
                children: List.generate(
                  headers.length,
                  (index) => Expanded(
                    flex: headers.values.elementAt(index),
                    child: AJCartHeader(
                      headers.keys.elementAt(index),
                      leftBorder: index != headers.length - 1,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => AJCartDialogTile(
                  parts[index],
                  isOdd: index % 2 != 0,
                ),
                itemCount: parts.length,
              ),
            ),
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  //   child: CustomButton(
                  //     text: 'Export DigiKey',
                  //     color: red.add(black, 0.2),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  //   child: CustomButton(
                  //     text: 'Export Mouser',
                  //     color: blue.add(black, 0.2),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomButton(
                      text: 'Export',
                      color: teal.add(black, 0.2),
                      onPressed: () {
                        String digikeyCSV = exportExcelCart(
                          headers.keys.toList(),
                          parts
                              .where(
                                  (element) => element['provider'] == 'Digikey')
                              .toList(),
                          requiredTimes: 1,
                          totalCost: 1,
                          fileName: 'DigiKeyCart',
                        );
                        String mouserCSV = exportExcelCart(
                          headers.keys.toList(),
                          parts
                              .where(
                                  (element) => element['provider'] == 'Mouser')
                              .toList(),
                          requiredTimes: 1,
                          totalCost: 1,
                          fileName: 'MouserCart',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
