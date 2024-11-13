import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/bom_part.dart';
import 'package:guadalajarav2/classes/mpn.dart';
import 'package:guadalajarav2/inventory/searchMenu.dart';
import 'package:guadalajarav2/utils/bom_handler.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/excel_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/bom_view/bom_component_tile.dart';
import 'package:guadalajarav2/views/bom_view/bom_final/bom_final_parts_dialog.dart';
import 'package:guadalajarav2/views/bom_view/bom_header.dart';
import 'package:guadalajarav2/views/bom_view/bom_part_tile.dart';
import 'package:guadalajarav2/views/bom_view/bom_selection_dialog.dart';
import 'package:guadalajarav2/views/bom_view/bom_table_header.dart';
import 'package:guadalajarav2/views/bom_view/bom_top_bar.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/loading_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:guadalajarav2/views/main_top_bar.dart/main_top_bar.dart';
import 'package:http/http.dart';

class BomView extends StatefulWidget {
  static List<BomPart> parts = [];
  static Map<String, Map<String, dynamic>> components = {};
  // static Map<String, Map<String, dynamic>> components = Map.fromIterable(
  //   List.generate(20, (index) => index),
  //   key: (index) => '$index',
  //   value: (_) => {
  //     'designator': 1,
  //     'description': 2,
  //     'manufacturer': 1,
  //     'mpn': 2,
  //     'alternate 1': 2,
  //     'alternate 2': 2,
  //     'required': 1,
  //     'total used': 1,
  //   },
  // );
  BomView({Key? key}) : super(key: key);

  @override
  State<BomView> createState() => _BomViewState();
}

class _BomViewState extends State<BomView> {
  bool onlyMissingParts = false;
  int requiredTimes = 1;

  List<List<TextEditingController>> controllers = [];

  Map<String, int> headers = {
    'designator': 1,
    'description': 2,
    'manufacturer': 1,
    'mpn': 2,
    'alternate 1': 2,
    'alternate 2': 2,
    'required': 1,
    'total used': 1,
  };

  // double get totalPartCost {
  //   double totalCost = 0;
  //   for (Map<String, dynamic> part in filteredParts.values) {
  //   }

  //   return totalCost;
  // }

  Map<String, Map<String, dynamic>> get filteredParts {
    Map<String, Map<String, dynamic>> parts = BomView.components;
    parts.removeWhere(
      (key, value) {
        bool goingToBeRemoved = false;

        // if (goingToBeAdded) {
        //   controllers.add(
        //     TextEditingController(text: '${element.goingToBeUsed}'),
        //   );
        // }
        return goingToBeRemoved;
      },
    );

    return parts;
  }

  // List<BomPart> get selectedParts {
  //   return filteredParts
  //       .where(
  //         (element) => element.selected >= 0 && element.selected <= 2,
  //       )
  //       .toList();
  // }

  @override
  void initState() {
    super.initState();
    BomView.components.clear();
    // Timer.run(
    //   () => openDialog(context, container: BomSelectionDialog(), block: true),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            BomTopBar(
              updateFunction: () async {
                openDialog(
                  context,
                  container: BasicTextDialog('Loading data'),
                  block: true,
                );

                Map<String, Map<String, dynamic>> components = {};
                List<String> errors = [];
                for (Map<String, dynamic>? bom
                    in BomSelectionDialog.boms.values) {
                  if (bom == null) {
                    continue;
                  } else {
                    bom['times'] = int.tryParse(
                            BomSelectionDialog.controllers[bom['key']]!.text) ??
                        1;
                    Excel excel = Excel.decodeBytes(bom['data']);

                    List<Map<String, dynamic>> componentsInExcel =
                        await getValuesFromExcel(excel, false);

                    if (componentsInExcel.length == 0) {
                      errors.add('Invalid BOM ${bom['name']}');
                    }
                    try {
                      componentsInExcel.forEach((element) {
                        if (errors.isNotEmpty) return;
                        if (element['mpn'] == null) {
                          errors.add('Bom has empty mpn');
                          return;
                        }
                        element['required'] *= bom['times'];
                        element['designators'] = {
                          bom['key']: element['designator'].split(', ')
                        };

                        if (components.containsKey(element['mpn'])) {
                          components[element['mpn']]!['required'] +=
                              element['required'];
                          if (components[element['mpn']]!['designators']
                                  [bom['key']] !=
                              null) {
                            (components[element['mpn']]!['designators']
                                    [bom['key']] as List)
                                .addAll(element['designator'].split(', '));
                          } else {
                            components[element['mpn']]!['designators']
                                    [bom['key']] =
                                element['designator'].split(', ');
                          }
                          // print(element['mpn'] + ' repeated');
                        } else {
                          components[element['mpn']] = element;
                          // print(element['mpn'] + ' not repeated');
                        }
                      });
                    } on Exception catch (e) {
                      print(e);
                    }
                  }
                }
                Navigator.pop(context);
                if (errors.isEmpty) {
                  LoadingDialog.total = components.length;
                  LoadingDialog.value = 0;

                  openDialog(context, container: LoadingDialog(), block: true);

                  List<Map<String, dynamic>> values =
                      await getAllValuesFromDatabase(
                    components.keys.toList(),
                  );

                  values.forEach((element) {
                    components[element['mpn']]!.addAll(element);
                    components[element['mpn']]!['using'] =
                        components[element['mpn']]!['quantity'] != null
                            ? components[element['mpn']]!['required']
                            : 'N/A';
                  });

                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {
                    BomView.components = components;

                    controllers.clear();

                    BomView.components.forEach((key, value) {
                      controllers.add([
                        TextEditingController(
                            text: value['required'].toString()),
                        TextEditingController(),
                        TextEditingController(),
                      ]);
                    });
                  });
                }
                String errorText = '';
                errors.forEach((element) => errorText += '$element\n');
                if (errorText.isNotEmpty) {
                  openDialog(
                    context,
                    container: TimedDialog(
                      text: errorText,
                      duration: Duration(minutes: 30),
                    ),
                  );
                }
              },
              exportFunction: BomView.components.isEmpty
                  ? null
                  : () {
                      double totalCost = 0;

                      BomView.components.forEach((key, value) {
                        totalCost +=
                            (double.tryParse(value['unitPrice'].toString()) ??
                                    0) *
                                (double.tryParse(value['using'].toString()) ??
                                    0);
                        if (value['alternative1'] != null) {
                          totalCost += (double.tryParse(value['alternative1']
                                          ['unitPrice']
                                      .toString()) ??
                                  0) *
                              (double.tryParse(value['using1'].toString()) ??
                                  0);
                        }

                        if (value['alternative2'] != null) {
                          totalCost += (double.tryParse(value['alternative2']
                                          ['unitPrice']
                                      .toString()) ??
                                  0) *
                              (double.tryParse(value['using2'].toString()) ??
                                  0);
                        }
                      });

                      exportBOM(
                        [
                          'designator',
                          'description',
                          'manufacturer',
                          'mpn',
                          'quantity',
                          'using',
                          'remaining',
                          'needed',
                          'unit cost',
                          'total cost',
                          'alternative 1',
                          'quantity',
                          'using',
                          'remaining',
                          'needed',
                          'unit cost',
                          'total cost',
                          'alternative 2',
                          'quantity',
                          'using',
                          'remaining',
                          'needed',
                          'unit cost',
                          'total cost',
                          'required',
                          'total needed',
                          'total to buy',
                          'total remaining',
                        ],
                        BomView.components.values.toList(),
                        requiredTimes: requiredTimes,
                        totalCost: totalCost,
                      );
                    },
              // requiredTimesFunct: (value) => setState(
              //   () {
              //     requiredTimes = value;
              //     // controllers.clear();
              //     // BomView.parts.forEach((element) {
              //     //   element.multiplier = requiredTimes;
              //     //   element.setFirstSelected();

              //     //   controllers.add(
              //     //     TextEditingController(text: '${element.goingToBeUsed}'),
              //     //   );
              //     // });
              //   },
              // ),
              // continueFunction: () {},
              continueFunction: BomView.components.isEmpty
                  ? null
                  : () => openDialog(
                        context,
                        container: BomFinalParts(
                          BomView.components.values.toList(),
                        ),
                      ),
              missingPartsFilter: (newValue) => setState(
                () {
                  onlyMissingParts = newValue;
                },
              ),
              onlyMissingParts: onlyMissingParts,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: width,
                    height: 499,
                    child: Column(
                      children: [
                        // BomHeader(
                        //   headers,
                        //   totalCost: totalPartCost,
                        //   requiredTimes: requiredTimes,
                        // ),
                        BomTableHeader(headers),
                        Expanded(
                          child: filteredParts.isEmpty
                              ? Container(
                                  color: backgroundColor,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    'Upload a file with the parts to search',
                                  ),
                                )
                              : ListView.builder(
                                  itemBuilder: (context, index) =>
                                      BomComponentTile(
                                    BomView.components.keys.elementAt(index),
                                    mpnController: controllers[index][0],
                                    mpn1Controller: controllers[index][1],
                                    mpn2Controller: controllers[index][2],
                                    headerValues: headers,
                                  ),
                                  // itemBuilder: (context, index) => BomComponentTile(
                                  //   filteredParts[index],
                                  //   controller: controllers[index],
                                  //   color: index % 2 != 0
                                  //       ? backgroundColor
                                  //       : white,
                                  //   sizes: headers.values.toList(),
                                  //   onSelected: (int selected) {
                                  //     // () => BomView.parts[index].selected = selected,
                                  //     filteredParts[index].selected = selected;
                                  //     if (selected >= 0 && selected < 3) {
                                  //       if (filteredParts[index].required >
                                  //           filteredParts[index]
                                  //               .allMPN[selected]!
                                  //               .quantity) {
                                  //         filteredParts[index].goingToBeUsed =
                                  //             filteredParts[index]
                                  //                 .allMPN[selected]!
                                  //                 .quantity;
                                  //       } else {
                                  //         filteredParts[index].goingToBeUsed =
                                  //             filteredParts[index].required;
                                  //       }
                                  //     } else {
                                  //       filteredParts[index].goingToBeUsed = 0;
                                  //     }
                                  //     setState(() {});
                                  //   },
                                  //   onChagedUsed: (String value) => setState(
                                  //     () {
                                  //       int realIndex = BomView.parts
                                  //           .indexOf(filteredParts[index]);
                                  //       if (value.isNotEmpty) {
                                  //         BomView.parts[realIndex]
                                  //             .goingToBeUsed = int.parse(value);
                                  //       } else {
                                  //         BomView.parts[realIndex]
                                  //             .goingToBeUsed = 0;
                                  //       }
                                  //       int g = BomView
                                  //           .parts[realIndex].goingToBeUsed;

                                  //       controllers[index].text = g.toString();
                                  //       if (g > 0) {
                                  //         // BomView.parts[realIndex]
                                  //         //     .setFirstSelected(setGTBU: false);
                                  //       } else {
                                  //         BomView.parts[realIndex].selected =
                                  //             -5;
                                  //       }
                                  //     },
                                  //   ),
                                  // ),
                                  itemCount: filteredParts.length,
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
