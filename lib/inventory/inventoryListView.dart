import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/GeneratePageRoute.dart';
import 'package:guadalajarav2/inventory/addNewComponent.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/editQuantity.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumColors.dart';
import 'package:guadalajarav2/inventory/enums/enumCurrent.dart';
import 'package:guadalajarav2/inventory/enums/enumDielectricType.dart';
import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/inventory/editProductDialog.dart';
import 'package:guadalajarav2/inventory/searchMenu.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

List<Product> products = [];
List<String> inventoryHeaders = [];

bool isSearchingSearchBar = false;

VoltageUnit selectedInventoryVUnit = VoltageUnit.v;
CurrentUnit selectedInventoryCUnit = CurrentUnit.a;
VoltageUnit selectedInventoryVBUnit = VoltageUnit.v;
VoltageUnit selectedInventoryVRUnit = VoltageUnit.v;
VoltageUnit selectedInventoryVCUnit = VoltageUnit.v;
String selectedInventoryPower = 'decimal';
FaradsUnit selectedInventoryFarad = FaradsUnit.f;
OhmUnit selectedInventoryOhm = OhmUnit.ohm;
HenryUnit selectedInventoryHenry = HenryUnit.h;
_InventoryListState inventoryState = _InventoryListState();

class InventoryList extends StatefulWidget {
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  @override
  void initState() {
    super.initState();
    inventoryState = this;
    Timer(Duration(milliseconds: 1), () async {
      if (RoutesName.getCurrent() == 'Inventory') {
        List<Product> components =
            await searchProductsByCategoryInDatabase(selectedCategory);

        setState(() {
          products = components;
        });

        mainState!.setState(() {
          floatingButton = Padding(
            padding: EdgeInsets.only(bottom: height * 0.05),
            child: FloatingActionButton(
              onPressed: () => containerDialog(
                inventoryState.context,
                false,
                NewComponentScreen(
                  category: selectedCategory,
                ),
                0.5,
              ),
              backgroundColor: green,
              child: Icon(Icons.add_rounded),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(products);
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.006),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: getInventoryHeaders(selectedInventoryCategory),
              ),
            ),
          ),
          Expanded(
            flex: 92,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return productTile(products[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getInventoryHeaders(Category category) {
    if (isSearching && !isSearchingSearchBar) {
      inventoryHeaders = category.allHeaders;
    } else {
      if (isSearchingSearchBar) {
        inventoryHeaders = [
          'category',
          'mpn',
          'description',
          'manufacturer',
          'quantity'
        ];
      } else {
        inventoryHeaders = category.headers;
      }
    }

    List<Widget> headers = [];
    for (int i = 0; i < inventoryHeaders.length; i++) {
      String title = inventoryHeaders[i];
      if (title == 'temperature') {
        title = 'Milicandela (mcd)';
      }
      if (i > 0) {
        headers.add(
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
            ),
            child: VerticalDivider(),
          ),
        );
      }

      if (title == 'voltage') {
        // title += '\n(${selectedInventoryVUnit.unit})';
        headers.add(
          Expanded(
            flex: getHeaderSize(title),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<VoltageUnit>(
                    selectedItemBuilder: (BuildContext context) {
                      return VoltageUnit.values
                          .map(
                            (VoltageUnit item) => Center(
                              child: AutoSizeText(
                                toTitle(title) +
                                    ' (${selectedInventoryVUnit.unit})',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                minFontSize: 2,
                                style: subTitleSearchMenu,
                              ),
                            ),
                          )
                          .toList();
                    },
                    style: dropdownButtonGrey,
                    items: VoltageUnit.values.map(
                      (VoltageUnit item) {
                        return DropdownMenuItem<VoltageUnit>(
                          value: item,
                          child: Center(
                            child: AutoSizeText(
                              item.unit,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              minFontSize: 1,
                              style: subTitleSearchMenu,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    isExpanded: true,
                    isDense: true,
                    value: selectedInventoryVUnit,
                    onChanged: (VoltageUnit? newValue) {
                      setState(() {
                        selectedInventoryVUnit = newValue!;
                      });
                    }),
              ),
            ),
          ),
        );
      } else if (title == 'power') {
        // title += '\n(${selectedInventoryVUnit.unit})';
        headers.add(
          Expanded(
            flex: getHeaderSize(title),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    selectedItemBuilder: (BuildContext context) {
                      return [
                        Center(
                          child: AutoSizeText(
                            '${toTitle(title)}',
                            minFontSize: 5,
                            textAlign: TextAlign.center,
                            style: subTitleSearchMenu,
                          ),
                        ),
                        Center(
                          child: AutoSizeText(
                            '${toTitle(title)}',
                            textAlign: TextAlign.center,
                            style: subTitleSearchMenu,
                          ),
                        ),
                      ];
                    },
                    style: dropdownButtonGrey,
                    items: [
                      DropdownMenuItem<String>(
                          child: AutoSizeText('decimal'), value: 'decimal'),
                      DropdownMenuItem<String>(
                          child: AutoSizeText('fraction'), value: 'fraction'),
                    ],
                    isExpanded: true,
                    isDense: true,
                    value: selectedInventoryPower,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedInventoryPower = newValue!;
                      });
                    }),
              ),
            ),
          ),
        );
      } else if (title == 'current') {
        // title += '\n(${selectedInventoryVUnit.unit})';
        headers.add(
          Expanded(
            flex: getHeaderSize(title),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CurrentUnit>(
                    selectedItemBuilder: (BuildContext context) {
                      return CurrentUnit.values
                          .map(
                            (CurrentUnit item) => Center(
                              child: AutoSizeText(
                                toTitle(title) +
                                    ' (${selectedInventoryCUnit.unit})',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                minFontSize: 2,
                                style: subTitleSearchMenu,
                              ),
                            ),
                          )
                          .toList();
                    },
                    style: dropdownButtonGrey,
                    items: CurrentUnit.values.map(
                      (CurrentUnit item) {
                        return DropdownMenuItem<CurrentUnit>(
                          value: item,
                          child: Center(
                            child: AutoSizeText(
                              item.unit,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              minFontSize: 1,
                              style: subTitleSearchMenu,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    isExpanded: true,
                    isDense: true,
                    value: selectedInventoryCUnit,
                    onChanged: (CurrentUnit? newValue) {
                      setState(() {
                        selectedInventoryCUnit = newValue!;
                      });
                    }),
              ),
            ),
          ),
        );
      } else if (title == 'value') {
        // title += '\n(${selectedInventoryVUnit.unit})';

        switch (category.unitValue) {
          case FaradsUnit:
            headers.add(
              Expanded(
                flex: getHeaderSize(title),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<FaradsUnit>(
                      selectedItemBuilder: (BuildContext context) {
                        return FaradsUnit.values
                            .map(
                              (FaradsUnit item) => Center(
                                child: AutoSizeText(
                                  toTitle(title) +
                                      ' (${selectedInventoryFarad.unit})',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  minFontSize: 2,
                                  style: subTitleSearchMenu,
                                ),
                              ),
                            )
                            .toList();
                      },
                      style: dropdownButtonGrey,
                      items: FaradsUnit.values.map(
                        (FaradsUnit item) {
                          return DropdownMenuItem<FaradsUnit>(
                            value: item,
                            child: Center(
                              child: AutoSizeText(
                                item.unit,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                minFontSize: 1,
                                style: subTitleSearchMenu,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      isExpanded: true,
                      isDense: true,
                      value: selectedInventoryFarad,
                      onChanged: (FaradsUnit? newValue) {
                        setState(
                          () {
                            selectedInventoryFarad = newValue!;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
            break;
          case OhmUnit:
            headers.add(
              Expanded(
                flex: getHeaderSize(title),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<OhmUnit>(
                      selectedItemBuilder: (BuildContext context) {
                        return OhmUnit.values
                            .map(
                              (OhmUnit item) => Center(
                                child: AutoSizeText(
                                  toTitle(title) +
                                      ' (${selectedInventoryOhm.unit})',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  minFontSize: 2,
                                  style: subTitleSearchMenu,
                                ),
                              ),
                            )
                            .toList();
                      },
                      style: dropdownButtonGrey,
                      items: OhmUnit.values.map(
                        (OhmUnit item) {
                          return DropdownMenuItem<OhmUnit>(
                            value: item,
                            child: Center(
                              child: AutoSizeText(
                                item.unit,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                minFontSize: 1,
                                style: subTitleSearchMenu,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      isExpanded: true,
                      isDense: true,
                      value: selectedInventoryOhm,
                      onChanged: (OhmUnit? newValue) {
                        setState(
                          () {
                            selectedInventoryOhm = newValue!;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
            break;
          case HenryUnit:
            headers.add(
              Expanded(
                flex: getHeaderSize(title),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<HenryUnit>(
                      selectedItemBuilder: (BuildContext context) {
                        return HenryUnit.values
                            .map(
                              (HenryUnit item) => Center(
                                child: AutoSizeText(
                                  toTitle(title) +
                                      ' (${selectedInventoryHenry.unit})',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  minFontSize: 2,
                                  style: subTitleSearchMenu,
                                ),
                              ),
                            )
                            .toList();
                      },
                      style: dropdownButtonGrey,
                      items: HenryUnit.values.map(
                        (HenryUnit item) {
                          return DropdownMenuItem<HenryUnit>(
                            value: item,
                            child: Center(
                              child: AutoSizeText(
                                item.unit,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                minFontSize: 1,
                                style: subTitleSearchMenu,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      isExpanded: true,
                      isDense: true,
                      value: selectedInventoryHenry,
                      onChanged: (HenryUnit? newValue) {
                        setState(
                          () {
                            selectedInventoryHenry = newValue!;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
            break;

          default:
            headers.add(Text("null"));
        }

        // print(value);
        // print(items);

      } else if (title == 'voltage breakdown' ||
          title == 'voltage reverse' ||
          title == 'voltage clamping') {
        // title += '\n(${selectedInventoryVUnit.unit})';
        String name = "V. " + title.split(' ')[1];
        VoltageUnit value = VoltageUnit.v;

        switch (title) {
          case 'voltage breakdown':
            value = selectedInventoryVBUnit;
            break;
          case 'voltage reverse':
            value = selectedInventoryVRUnit;
            break;
          case 'voltage clamping':
            value = selectedInventoryVCUnit;
            break;
        }

        headers.add(
          Expanded(
            flex: getHeaderSize(title),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<VoltageUnit>(
                  selectedItemBuilder: (BuildContext context) {
                    return VoltageUnit.values
                        .map(
                          (VoltageUnit? item) => AutoSizeText(
                            toTitle(name) + ' (${value.unit})',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            minFontSize: 5,
                            style: subTitleSearchMenu,
                          ),
                        )
                        .toList();
                  },
                  style: dropdownButtonGrey,
                  items: VoltageUnit.values.map(
                    (VoltageUnit item) {
                      return DropdownMenuItem<VoltageUnit>(
                        value: item,
                        child: Center(
                          child: AutoSizeText(
                            item.unit,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            minFontSize: 1,
                            style: subTitleSearchMenu,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  isExpanded: true,
                  isDense: true,
                  value: title == 'voltage breakdown'
                      ? selectedInventoryVBUnit
                      : title == 'voltage breakdown'
                          ? selectedInventoryVRUnit
                          : selectedInventoryVCUnit,
                  onChanged: (VoltageUnit? newValue) {
                    setState(
                      () {
                        switch (title) {
                          case 'voltage breakdown':
                            selectedInventoryVBUnit = newValue!;
                            break;
                          case 'voltage reverse':
                            selectedInventoryVRUnit = newValue!;
                            break;
                          case 'voltage clamping':
                            selectedInventoryVCUnit = newValue!;
                            break;
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      } else {
        headers.add(
          Expanded(
            flex: getHeaderSize(title),
            child: AutoSizeText(
              title == 'speed' ? 'Speed (Mbps)' : toTitle(title),
              minFontSize: 0.5,
              maxLines: 2,
              softWrap: true,
              stepGranularity: 0.5,
              textAlign: TextAlign.center,
              style: subTitleSearchMenu,
            ),
          ),
        );
      }
    }
    headers.add(
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.01,
        ),
        child: VerticalDivider(),
      ),
    );

    headers.add(
      Expanded(
        flex: 1,
        child: AutoSizeText(
          'Actions',
          minFontSize: 0.5,
          maxLines: 2,
          softWrap: true,
          stepGranularity: 0.5,
          textAlign: TextAlign.center,
          style: subTitleSearchMenu,
        ),
      ),
    );
    return headers;
  }

  ListTile productTile(Product product, int index) {
    Map<String, dynamic> values = product.toJson();
    List<Widget> attributes = [];
    List<String> headers = inventoryHeaders;
    for (int i = 0; i < values.length; i++) {
      String key = values.keys.elementAt(i);
      dynamic value = values[key];

      if (headers.contains(separateWords(key)) ||
          (isSearching && !isSearchingSearchBar)) {
        if (value != null) {
          if (key == 'power' && selectedInventoryPower == 'fraction') {
            value = decimalToFraction(value);
          } else if (key == 'voltage') {
            value = VoltageUnit.v
                .convertTo(value, selectedInventoryVUnit)
                .toString();
          } else if (key == 'current') {
            value = CurrentUnit.a
                .convertTo(value, selectedInventoryCUnit)
                .toString();
          } else if (key == 'voltageBreakdown' ||
              key == 'voltageReverse' ||
              key == 'voltageClamping') {
            switch (key) {
              case 'voltageBreakdown':
                value = VoltageUnit.v
                    .convertTo(value, selectedInventoryVBUnit)
                    .toString();

                break;
              case 'voltageReverse':
                value = VoltageUnit.v
                    .convertTo(value, selectedInventoryVRUnit)
                    .toString();
                break;
              case 'voltageClamping':
                value = VoltageUnit.v
                    .convertTo(value, selectedInventoryVCUnit)
                    .toString();
                break;
            }
          } else if (key == 'value') {
            switch (selectedCategory.unitValue) {
              case FaradsUnit:
                value = FaradsUnit.f.convertTo(value, selectedInventoryFarad);
                break;
              case OhmUnit:
                value = OhmUnit.ohm.convertTo(value, selectedInventoryOhm);
                break;
              case HenryUnit:
                value = HenryUnit.h.convertTo(value, selectedInventoryHenry);
                break;
            }
          } else if (key == 'mounting') {
            value = Mounting.values[value].name;
          } else if (key == 'status') {
            value = ProductStatus.values[value].name;
          } else if (key == 'dielectricType') {
          } else if (key == 'color') {
            value = LedColor.values[value].name;
          }
        } else {
          value = 'N/A';
        }

        key = separateWords(key);
        if (attributes.length > 0 || isSearchingSearchBar) {
          attributes.add(
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.01,
              ),
              child: VerticalDivider(),
            ),
          );
        }
        attributes.add(
          Expanded(
            flex: getHeaderSize(key),
            child: AutoSizeText(
              value.toString(),
              minFontSize: 0.5,
              maxLines: 3,
              stepGranularity: 0.5,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkGrey,
              ),
            ),
          ),
        );
      } else {
        continue;
      }
    }

    if (isSearchingSearchBar) {
      attributes.insert(
        0,
        Expanded(
          flex: 2,
          child: AutoSizeText(
            toTitle(product.category!.nameSingular),
            minFontSize: 0.5,
            maxLines: 3,
            stepGranularity: 0.5,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkGrey,
            ),
          ),
        ),
      );
    }

    attributes.add(
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.01,
        ),
        child: VerticalDivider(),
      ),
    );

    attributes.add(
      Expanded(
        flex: 1,
        child: Container(
          child: Center(
            child: TextButton(
              child: Icon(
                Icons.edit_rounded,
                color: darkGrey,
              ),
              onPressed: () => containerDialog(
                context,
                false,
                EditQuanity(
                  product: product,
                ),
                0.5,
              ),
            ),
          ),
        ),
      ),
    );

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Container(
        height: height * 0.1,
        child: ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: index % 2 == 0 ? white : lightGrey,
          ),
          child: Row(
            children: attributes,
          ),
          onPressed: () => containerDialog(
            context,
            false,
            EditComponentScreen(
              product: product,
            ),
            0.75,
          ),
        ),
      ),
    );
  }

  int getHeaderSize(String headerTitle) {
    switch (headerTitle) {
      case 'description':
        return 3;
      case 'unit price':
        return 2;
      case 'mpn':
        return 2;
      case 'manufacturer':
        return 3;
      case 'quantity':
        return 2;
      case 'status':
        return 2;

      case 'mounting':
        return 2;
      case 'package':
        return 2;
      case 'current':
        return 2;
      case 'power':
        return 2;
      case 'value':
        return 2;
      case 'pin count':
        return 2;
      case 'tolerance':
        return 2;
      case 'flash':
        return 2;
      case 'ram':
        return 2;
      case 'voltage breakdown':
        return 2;
      case 'voltage reverse':
        return 2;
      case 'voltage clamping':
        return 2;
      case 'dielectric type':
        return 2;
      case 'temperature':
        return 2;
      case 'pitch':
        return 2;
      case 'row':
        return 2;
      case 'interface':
        return 2;
      case 'resolution':
        return 3;
      case 'color':
        return 2;
      case 'load capacitance':
        return 2;
      case 'channel type':
        return 2;
      case 'contact type':
        return 2;
      case 'material':
        return 2;
      case 'speed':
        return 2;

      default:
        return 2;
    }
  }
}
