import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/inventory/changesBOM.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ProductBOMScreen extends StatefulWidget {
  final Map<String, Map<String, dynamic>> bomProducts;
  final Map<String, int> bomQuantities;
  final Map<String, Map<String, dynamic>> dbData;

  ProductBOMScreen(
      {required this.bomProducts,
      required this.bomQuantities,
      required this.dbData});

  @override
  _ProductBOMState createState() => _ProductBOMState();
}

class _ProductBOMState extends State<ProductBOMScreen> {
  TextEditingController bomQuantityController = new TextEditingController();
  int bomQuantity = 1;
  Map<String, Map<String, dynamic>> bomProducts = {};

  List<int> selectedComponents = [];
  List<List<dynamic>> selectedValues = [];

  Map<String, int> headers = {
    'MPN': 3,
    'Description': 3,
    'Manufacturer': 3,
    'Values': 2,
    'Alternative 1': 2,
    'Alternative 2': 2,
    'Required': 2,
  };
  @override
  void initState() {
    for (String key in widget.bomProducts.keys) {
      String mpn = key;
      String description = widget.bomProducts[key]!['description'];
      String manufacturer = widget.bomProducts[key]!['manufacturer'];
      String? data;
      if (widget.dbData[key] != null) {
        int quantity = widget.dbData[key]!['quantity'];
        double unitPrice = widget.dbData[key]!['unitPrice'];
        data = 'Q: $quantity   \$: $unitPrice';
      } else {
        data = 'Q: 0   \$: 0.0';
      }

      String? mpn1 = widget.bomProducts[key]!['mpn1'];
      if (mpn1 != null && mpn1.isNotEmpty) {
        if (widget.dbData[mpn1] != null) {
          int quantity1 = widget.dbData[mpn1]!['quantity'];
          double unitPrice1 = widget.dbData[mpn1]!['unitPrice'];

          mpn1 += '\nQ: $quantity1   \$: $unitPrice1';
        } else {
          mpn1 += '\nQ: 0   \$: 0.0';
        }
      } else {
        mpn1 = null;
      }

      String? mpn2 = widget.bomProducts[key]!['mpn2'];
      if (mpn2 != null && mpn2.isNotEmpty) {
        if (widget.dbData[mpn2] != null) {
          int quantity2 = widget.dbData[mpn2]!['quantity'];
          double unitPrice2 = widget.dbData[mpn2]!['unitPrice'];

          mpn2 += '\nQ: $quantity2   \$: $unitPrice2';
        } else {
          mpn2 += '\nQ: 0   \$: 0.0';
        }
      } else {
        mpn2 = null;
      }
      selectedComponents.add(3);
      selectedValues.add(['$key', 0]);
      // print(key);
      int requiredQuantity = widget.bomQuantities[key]!;
      bomProducts.putIfAbsent(
        key,
        () => {
          'mpn': mpn,
          'description': description,
          'manufacturer': manufacturer,
          'data': data,
          'mpn1': mpn1,
          'mpn2': mpn2,
          'required': requiredQuantity,
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.8,
      height: height * 0.8,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Row(
                children: arrangeInfoByFlex(getHeaders()),
              ),
            ),
          ),
          Expanded(
            flex: 17,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.01),
              child: ListView.separated(
                itemBuilder: (BuildContext context, int i) =>
                    productTile(bomProducts.values.elementAt(i), i),
                itemCount: bomProducts.length,
                separatorBuilder: (BuildContext context, int i) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01,
                  ),
                  child: Divider(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.125),
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: gray),
                      child: AutoSizeText(
                        'Close',
                        style: TextStyle(
                          color: white,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.125),
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: green),
                      child: AutoSizeText(
                        'Manufacture',
                        style: TextStyle(
                          color: white,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      onPressed: () {
                        List<List<dynamic>> toChange = [];

                        for (int i = 0; i < selectedValues.length; i++) {
                          int index = selectedComponents[i];
                          if (index > -1) {
                            toChange.add([
                              selectedValues[i][0],
                              selectedValues[i][1],
                              bomProducts.values.elementAt(i)['required'] *
                                  bomQuantity
                            ]);
                          }
                        }
                        if (toChange.length > 0) {
                          containerDialog(
                            context,
                            false,
                            ChangesBOMNotification(
                              components: toChange,
                            ),
                            0.5,
                          );
                        } else {
                          containerDialog(
                            context,
                            true,
                            AlertNotification(
                              icon: Icons.list_rounded,
                              color: red,
                              str: 'Select at least\none component',
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
          ),
        ],
      ),
    );
  }

  Row intTextField(TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: addButton('-', -1, controller),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              // vertical: height * 0.025,
              horizontal: width * 0.001,
            ),
            child: AutoSizeTextField(
              minFontSize: 1,
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.001),
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
                hintText: '1',
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: lightGrey,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: lightGrey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: lightGrey,
                  ),
                ),
              ),
              onEditingComplete: () {
                if (canConvertToInt(controller.text)) {
                  setState(() {
                    bomQuantity = int.parse(controller.text);
                  });
                } else {
                  containerDialog(
                    context,
                    true,
                    AlertNotification(
                        icon: Icons.warning_amber_rounded,
                        color: red,
                        str: 'Summit valid int value'),
                    0.5,
                  );
                  setState(() {
                    controller.text = '';
                  });
                }
              },
            ),
          ),
        ),
        Expanded(
          child: addButton('+', 1, controller),
        ),
      ],
    );
  }

  TextButton addButton(
      String text, int amount, TextEditingController controller) {
    return TextButton(
      // style: TextButton.styleFrom(backgroundColor: blue),
      child: AutoSizeText(
        '$text',
        style: TextStyle(
          fontFamily: 'Nunito',
          color: blue,
        ),
      ),
      onPressed: () {
        bool success = changeIntControllerValue(1, 99999, amount, controller);
        if (success) {
          if (controller.text.isEmpty) {
            bomQuantity = 1;
          } else {
            setState(() {
              bomQuantity = int.parse(controller.text);
            });
          }
        }
      },
    );
  }

  List<Widget> getTileInfo(Map<String, dynamic> data, int index) {
    List<Widget> row = [];
    bool hasButton = false;
    List<dynamic> values = data.values.map(
      (e) {
        if (e == null) {
          return 'N/A';
        } else {
          return e;
        }
      },
    ).toList();

    int quantityTotal = data['required'] * bomQuantity;

    for (int i = 0; i < values.length; i++) {
      dynamic text = values[i];
      bool isValid = false;
      int quantity = 0;
      TextStyle textStyle;

      if (text == 'N/A') {
        textStyle = TextStyle(
          color: gray,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );
      } else {
        if (text.toString().contains('   ') && i > 2) {
          quantity = int.parse(
            text
                .toString()
                .split('\n')[text.toString().split('\n').length - 1]
                .split('   ')[0]
                .split(' ')[1],
          );

          if (quantity >= quantityTotal) {
            isValid = true;
            hasButton = true;
            if (selectedValues[index][1] < quantity) {
              selectedComponents[index] = i;
              if (i > 3) {
                selectedValues[index] = [
                  text.toString().split('\n')[0],
                  quantity
                ];
              } else {
                selectedValues[index] = [values[0].toString(), quantity];
              }
            }
            textStyle = TextStyle(
              color: selectedComponents[index] == i ? white : green,
              fontWeight: FontWeight.w400,
              fontFamily: 'Nunito',
            );
          } else {
            textStyle = TextStyle(
              color: red,
              fontWeight: FontWeight.w400,
              fontFamily: 'Nunito',
            );
          }
        } else {
          if (i == values.length - 1) {
            text *= bomQuantity;
          }
          textStyle = TextStyle(
            color: darkGrey,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito',
          );
        }
      }
      Container container = Container(
        child: Center(
          child: SelectableText(
            '$text',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      );

      if (isValid) {
        row.add(
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: selectedComponents[index] == i
                  ? green.withOpacity(
                      0.5,
                    )
                  : white,
            ),
            onPressed: () => setState(() {
              if (selectedComponents[index] == i) {
                selectedComponents[index] = -2;
              } else {
                selectedComponents[index] = i;
                if (i > 3) {
                  selectedValues[index] = [
                    text.toString().split('\n')[0],
                    quantity
                  ];
                } else {
                  selectedValues[index] = [values[0].toString(), quantity];
                }
              }
            }),
            child: container,
          ),
        );
      } else {
        row.add(container);
      }
    }
    if (!hasButton) {
      selectedComponents[index] = -1;
    }
    return row;
  }

  List<Widget> getHeaders() {
    List<Widget> row = [];
    for (int i = 0; i < headers.length; i++) {
      String text = headers.keys.elementAt(i);
      if (text == 'Required') {
        row.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          child: Center(
                            child: AutoSizeText(
                              '$text',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: darkGrey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: intTextField(
                          bomQuantityController,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        row.add(
          Container(
            child: Center(
              child: AutoSizeText(
                '$text',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: darkGrey,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito'),
              ),
            ),
          ),
        );
      }
    }
    return row;
  }

  List<Widget> arrangeInfoByFlex(List<Widget> widgets) {
    List<Widget> row = [];
    for (int i = 0; i < widgets.length; i++) {
      int flex = headers.values.elementAt(i);
      Widget widget = widgets[i];

      if (i > 0) {
        row.add(Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.005),
          child: VerticalDivider(),
        ));
      }

      row.add(
        Expanded(
          flex: flex,
          child: widget,
        ),
      );
    }
    return row;
  }

  ListTile productTile(Map<String, dynamic> data, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Container(
        height: height * 0.05,
        child: Row(
          children: arrangeInfoByFlex(getTileInfo(data, index)),
        ),
      ),
    );
  }
}
