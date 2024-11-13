import 'package:flutter/material.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/classes/bom_part.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/bom_view/bom_final/bom_final_tile.dart';
import 'package:guadalajarav2/views/bom_view/bom_header.dart';
import 'package:guadalajarav2/views/bom_view/bom_table_header.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class BomFinalParts extends StatefulWidget {
  final List<Map<String, dynamic>> parts;
  BomFinalParts(this.parts, {Key? key}) : super(key: key);

  @override
  State<BomFinalParts> createState() => _BomFinalPartsState();
}

class _BomFinalPartsState extends State<BomFinalParts> {
  Map<String, int> headers = {
    'designator': 1,
    'description': 1,
    'mpn': 1,
    'unit price': 1,
    'stock': 1,
    'using': 1,
    'remaining': 1,
    'needed': 1,
    'total cost': 1,
  };

  double get totalCost {
    double tC = 0;
    parts.forEach(
        (key, value) => tC += (value['unitPrice'] ?? 0) * value['using']);
    return tC;
  }

  Map<String, Map<String, dynamic>> parts = {};

  @override
  void initState() {
    super.initState();
    parts.clear();
    widget.parts.forEach((part) {
      verifyMPN(part, part['using'], part['designators']);
      for (int i = 1; i < 3; i++) {
        if (part['alternative$i'] != null) {
          verifyMPN(
            part['alternative$i'],
            part['using$i'],
            part['designators'],
          );
        }
      }
    });

    parts.forEach((key, value) {
      // print('$key ${value['designators']}');
    });
  }

  void verifyMPN(
      dynamic mpn, dynamic using, Map<dynamic, dynamic> designators) {
    if (using != null && mpn['quantity'] != null) {
      mpn['using'] = int.tryParse(using.toString()) ?? 0;
      if (mpn['using'] > 0) {
        mpn['designators'] = designators;

        dynamic key = mpn['mpn'];
        // designators = (designators as Map).entries.first;
        // print(mpn['designator'].split(', '));

        if (parts.containsKey(key)) {
          parts[key]!['using'] += mpn['using'];
          Map<dynamic, dynamic> d = {};
          for (MapEntry designator in designators.entries) {
            if (d.containsKey(designator.key)) {
              (designator.value as List).forEach(
                  (element) => (d[designator.key] as List).add(element));
            } else {
              d[designator.key] = [];
              (designator.value as List).forEach(
                  (element) => (d[designator.key] as List).add(element));
            }
            d[designator.key]
                .addAll(parts[key]!['designators'][designator.key]);
          }
          // parts.forEach((key, value) {
          //   if (key == '691313710002' || key == '691352710002') {
          //     print(value);
          //   }
          // });
          parts[key]!['designators'] = d;
          // parts.forEach((key, value) {
          //   if (key == '691313710002' || key == '691352710002') {
          //     print(value);
          //   }
          // });
          // if ((parts[key]!['designators'] as Map)
          //     .containsKey(designators.key)) {
          //   (parts[key]!['designators'][designators.key] as List)
          //       .addAll(designators.value);
          // } else {
          //   parts[key]!['designators'][designators.key] = designators.value;
          // }
        } else {
          parts[key] = mpn;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: Column(
        children: [
          Container(
            height: height * 0.075,
            color: white,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: 'Cancel',
                  color: teal.add(black, 0.3),
                  onPressed: () => Navigator.pop(context),
                ),
                CustomButton(
                  text: 'Update database',
                  color: teal.add(black, 0.3),
                  onPressed: () async {
                    List<List<dynamic>> components = [];

                    parts.forEach((key, value) {
                      int remaining = (value['quantity'] - value['using']);
                      remaining = remaining >= 0 ? remaining : 0;
                      components.add([key, remaining]);
                    });

                    if (await removeComponentsbyBOMInDatabase(
                      components,
                      alreadyLinked: true,
                    )) {
                      Navigator.pop(context);
                      openDialog(
                        context,
                        container: AlertNotification(
                          icon: Icons.check_rounded,
                          color: green,
                          str: 'Database Updated',
                        ),
                      );
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
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    BomTableHeader(
                      headers,
                      totalCost: totalCost,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => BomFinalTile(
                          parts.values.elementAt(index),
                          isOdd: index % 2 != 0,
                        ),
                        itemCount: parts.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
