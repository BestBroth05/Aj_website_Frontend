import 'dart:async';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/bom_part.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/utils/bom_handler.dart';
import 'package:guadalajarav2/utils/inventory/digikey_api_handler.dart';
import 'package:guadalajarav2/utils/inventory/mouser_api_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_dialog.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_headers.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_table.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_top_bar.dart';
import 'package:guadalajarav2/views/bom_view/bom_header.dart';
import 'package:guadalajarav2/views/bom_view/bom_selection_dialog.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/loading_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';

class AJCartView extends StatefulWidget {
  static Map<String, Map<String, dynamic>> parts = {};
  static double totalDigikey = 0;
  static double totalMouser = 0;
  AJCartView({Key? key}) : super(key: key);

  @override
  State<AJCartView> createState() => _AJCartViewState();
}

class _AJCartViewState extends State<AJCartView> {
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  ScrollController bodyController = ScrollController(initialScrollOffset: 0);

  Map<String, int> headers = {
    'designator': 2,
    'description': 2,
    'manufacturer': 2,
    'mpn': 2,
    // 'alt1': 2,
    // 'alt2': 2,
    'digikey': 2,
    // 'digikey_1': 2,
    // 'digikey_2': 2,
    'mouser': 2,
    // 'mouser_1': 2,
    // 'mouser_2': 2,
    'required': 1,
    'using': 1,
    'total_cost_digikey': 1,
    'total_cost_mouser': 1,
  };

  @override
  void initState() {
    super.initState();
    bodyController.addListener(
      () => scrollController.jumpTo(bodyController.offset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          child: AJCartTopBar(
            uploadFunction: searchPartsFromBom,
            exportFunction: () {},
            missingPartsFilter: (_) {},
            onlyMissingParts: false,
            continueFunction: AJCartView.parts.isEmpty
                ? null
                : () => openDialog(
                      context,
                      container: AJCartDialog(),
                    ),
            requiredTimesFunct: (_) {},
          ),
        ),
        Expanded(
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                AJCartHeaders(
                  headers,
                  scrollController: scrollController,
                ),
                Expanded(
                  child: AJCartTable(
                    scrollController: bodyController,
                    headers: headers,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void searchPartsFromBom() async {
    openDialog(
      context,
      container: BomSelectionDialog(
        updateFunction: () async {
          AJCartView.totalDigikey = 0;
          AJCartView.totalMouser = 0;
          openDialog(
            context,
            container: BasicTextDialog('Loading...'),
            block: true,
          );
          try {
            Map<String, Map<String, dynamic>> components = {};
            List<String> errors = [];
            for (Map<String, dynamic>? bom in BomSelectionDialog.boms.values) {
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

                componentsInExcel.forEach((element) {
                  if (element['mpn'] == null) {
                  } else {
                    element['required'] *= bom['times'];
                    element['designators'] = {
                      bom['key']: element['designator'].split(', ')
                    };
                    // print(element);
                    if (components.containsKey(element['mpn'])) {
                      components[element['mpn']]!['required'] +=
                          element['required'];
                      if (components[element['mpn']]!['designators']
                              [bom['key']] !=
                          null) {
                        (components[element['mpn']]!['designators'][bom['key']]
                                as List)
                            .addAll(element['designator'].split(', '));
                      } else {
                        components[element['mpn']]!['designators'][bom['key']] =
                            element['designator'].split(', ');
                      }
                      // // print(element['mpn'] + ' repeated');
                    } else {
                      components[element['mpn']] = element;
                      //     // print(element['mpn'] + ' not repeated');
                    }
                  }
                });
              }
            }
            Navigator.pop(context);
            LoadingDialog.total = components.length > 0 ? components.length : 1;
            openDialog(
              context,
              container: LoadingDialog(),
              block: true,
            );
            components.forEach((key, value) {
              components[key]!['controller'] = TextEditingController();
              components[key]!['controller1'] = TextEditingController();
              components[key]!['controller2'] = TextEditingController();

              // print(value);
            });
            int i = 0;
            for (String key in components.keys) {
              Map<String, dynamic>? digikey = await searchInDigikey(key);
              components[key]!['digikey'] = digikey;
              if (digikey != null) {
                components[key]!['digikey']['controller'] =
                    TextEditingController();
                double totalCostDigikey =
                    digikey['UnitPrice'] * components[key]!['required'] ?? 0;
                AJCartView.totalDigikey += totalCostDigikey;

                // Map<String, Map<String, dynamic>> similar =
                //     await getSimilarPartsInDigikey(context, digikey);
                // for (int i = 1; i < similar.length + 1; i++) {
                //   Map<String, dynamic>? s = similar.values.elementAt(i - 1);

                //   components[key]!['digikey_$i'] = s;
                //   components[key]!['digikey_$i']['controller'] =
                //       TextEditingController();
                // }
              }

              Map<String, dynamic>? mouser = await searchInMouser(key);
              components[key]!['mouser'] = mouser;
              if (mouser != null) {
                components[key]!['mouser']['controller'] =
                    TextEditingController();
                double cost = 0;

                if (mouser['PriceBreaks'] != null &&
                    mouser['PriceBreaks'].length > 0) {
                  if (mouser['PriceBreaks'][0]['Quantity'] == 1) {
                    cost += components[key]!['required'] *
                            double.tryParse(mouser['PriceBreaks'][0]['Price']
                                .toString()
                                .substring(1)) ??
                        0;
                  }
                }

                AJCartView.totalMouser += cost;
              }
              // for (int i = 1; i < 3; i++) {
              //   Map<String, dynamic>? s = components[key]!['digikey_$i'];
              //   if (s != null) {
              //     Map<String, dynamic>? m =
              //         await searchInMouser(s['ManufacturerPartNumber']);
              //     components[key]!['mouser_$i'] = m;
              //     if (m != null) {
              //       components[key]!['mouser_$i']['controller'] =
              //           TextEditingController();
              //     }
              //     if (components[key]!['alt$i'] == null) {
              //       List<Product> p = await searchProductByMPNInDatabase(
              //         s['ManufacturerPartNumber'],
              //       );
              //       if (p.length > 0) {
              //         components[key]!['alt$i'] = p.first.toJson();
              //         components[key]!['alt$i']['controller'] =
              //             TextEditingController();
              //       }
              //     }
              //   }
              // }
              i += 1;
              LoadingDialog.value = i;
            }
            setState(() {
              AJCartView.parts = components;
              // Timer(Duration(seconds: 2), () => setState(() {}));
            });
            Navigator.pop(context);
            Navigator.pop(context);
          } on Exception catch (e) {
            Navigator.pop(context);
            openDialog(
              context,
              container: TimedDialog(
                text: 'Error uploading File',
                duration: Duration(
                  seconds: 20,
                ),
              ),
            );
          }
        },
      ),
      block: true,
    );
  }
}
