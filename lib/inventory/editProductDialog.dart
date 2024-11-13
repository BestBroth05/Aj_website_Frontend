import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumColors.dart';
import 'package:guadalajarav2/inventory/enums/enumCurrent.dart';
import 'package:guadalajarav2/inventory/enums/enumDielectricType.dart';
import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumFlash.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumMoney.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';
import 'package:guadalajarav2/inventory/addNewComponent.dart';
import 'package:guadalajarav2/inventory/deleteNotification.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class EditComponentScreen extends StatefulWidget {
  final Product product;

  EditComponentScreen({required this.product});

  @override
  EditComponentState createState() => EditComponentState();
}

class EditComponentState extends State<EditComponentScreen> {
  List<Widget> productInfo = [];
  List<dynamic> selections = [];

  @override
  void initState() {
    super.initState();
    selections = [
      MoneyUnit.usDollar, //0
      VoltageUnit.v,
      FaradsUnit.f,
      CurrentUnit.a,
      VoltageUnit.v,
      VoltageUnit.v,
      VoltageUnit.v,
      HenryUnit.h,
      'decimal',
      FlashUnit.mb,
      FlashUnit.mb,
      OhmUnit.ohm,
      FaradsUnit.f,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return productFullView(widget.product);
  }

  Widget productFullView(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.01,
        vertical: height * 0.01,
      ),
      width: width * 0.3,
      height: height * 0.75,
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              padding: EdgeInsets.only(
                top: height * 0.01,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          product.category!.nameSingular,
                          style: titleEdit,
                        ),
                        AutoSizeText(
                          'Last edited: ${product.lastEdited.toString()}',
                          style: TextStyle(
                            fontSize: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        SelectableText(
                          'MPN: ',
                          style: subtitleEdit,
                        ),
                        SelectableText(
                          '${product.mpn}',
                          style: informationEdit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: Column(
                children: buildInfo(),
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: width * 0.05,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                          ),
                          child: ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: red),
                            onPressed: () {
                              // Navigator.pop(context);
                              containerDialog(
                                context,
                                true,
                                DeleteConfirmation(
                                  product: widget.product,
                                ),
                                0.2,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AutoSizeText(
                                  'Delete',
                                  style: buttonEdit,
                                ),
                                Icon(
                                  Icons.delete_forever_rounded,
                                  size: height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: width * 0.05,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              containerDialog(
                                  context,
                                  false,
                                  NewComponentScreen(
                                    category: product.category!,
                                    product: product,
                                  ),
                                  0.75);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AutoSizeText(
                                  'Edit',
                                  style: buttonEdit,
                                ),
                                Icon(
                                  Icons.edit,
                                  size: height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildInfo() {
    Product product = widget.product;

    return productInfo = [
      Expanded(
        flex: 3,
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            informationSection(
                                "Manufacturer", product.manufacturer, 1),
                          ],
                        ),
                      ),
                    ),
                    informationSection("Status", product.status!.name, 1),
                    informationSection(
                      "Quantity",
                      product.quantity.toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            informationSectionMultiple<MoneyUnit>(
                              "Unit Price",
                              "${MoneyUnit.euro.parse(selections[0].toString())!.symbol} ${MoneyUnit.usDollar.convertTo(product.unitPrice!, selections[0]).toString()}",
                              1,
                              MoneyUnit.values,
                              0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    informationSection("Description", product.description, 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      getExtraInformation(product),
    ];
  }

  Expanded informationSection(String? title, String? information, int? flex) {
    if (information == 'null' || information!.isEmpty) {
      information = 'N/A';
    } else {
      information = toTitle(information);
    }

    if (title == 'Speed') {
      title = 'Speed (Mbps)';
    }
    if (title == 'Temperature') {
      title = 'Milicandela Rating (mcd)';
    }

    return Expanded(
      flex: flex!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      title!,
                      style: subtitleEdit,
                      maxFontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: title == 'Description' ? 3 : 1,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: title == 'Description' ? height * 0.01 : 0,
              ),
              child: Row(
                crossAxisAlignment: title == 'Description'
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SelectableText(
                      information,
                      style: informationEdit,
                      maxLines: 3,
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

  Expanded informationSectionMultiple<T>(
    String title,
    String? information,
    int flex,
    List<T> values,
    int index,
  ) {
    if (information == 'null' || information!.isEmpty || information == null) {
      information = 'N/A';
    } else {
      information = toTitle(information);
    }
    List<String> stringValues = [];

    switch (T) {
      case MoneyUnit:
        for (MoneyUnit v in values.cast<MoneyUnit>()) {
          stringValues.add(v.unit);
          if (v.toString() == selections[index].toString()) {}
        }
        break;

      case VoltageUnit:
        for (VoltageUnit v in values.cast<VoltageUnit>()) {
          stringValues.add(v.unit);
          if (v.toString() == selections[index].toString()) {}
        }
        break;

      case FaradsUnit:
        for (FaradsUnit v in values.cast<FaradsUnit>()) {
          stringValues.add(v.unit);
          if (v.toString() == selections[index].toString()) {}
        }
        break;

      case CurrentUnit:
        for (CurrentUnit v in values.cast<CurrentUnit>()) {
          stringValues.add(v.unit);
          if (v.toString() == selections[index].toString()) {}
        }
        break;
      case HenryUnit:
        for (HenryUnit v in values.cast<HenryUnit>()) {
          stringValues.add(v.unit);
          if (v.toString() == selections[index].toString()) {}
        }
        break;
      case OhmUnit:
        for (OhmUnit v in values.cast<OhmUnit>()) {
          stringValues.add(v.unit);
          if (v.toString() == selections[index].toString()) {}
        }
        break;

      case String:
        stringValues = ['Watts', 'Watts'];
        break;

      case FlashUnit:
        for (FlashUnit v in values.cast<FlashUnit>()) {
          stringValues.add(v.unit);
          if (v.toString() == selections[index].toString()) {}
        }
        break;
    }
    return Expanded(
      flex: flex,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                DropdownButton<dynamic>(
                  underline: SizedBox(),
                  selectedItemBuilder: (BuildContext context) {
                    return values
                        .map(
                          (T item) => Row(
                            children: [
                              AutoSizeText(
                                toTitle(title) +
                                    ' (${stringValues[values.indexOf(item)]})',
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                minFontSize: 2,
                                style: subtitleEdit,
                                maxFontSize: 15,
                              ),
                            ],
                          ),
                        )
                        .toList();
                  },
                  items: values.map(
                    (T item) {
                      return DropdownMenuItem<dynamic>(
                        child: Center(
                          child: AutoSizeText(
                            item.toString(),
                            minFontSize: 1,
                            maxFontSize: 15,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        value: item,
                      );
                    },
                  ).toList(),
                  value: selections[index],
                  onChanged: (dynamic newValue) {
                    setState(
                      () {
                        selections[index] = newValue;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(information, style: informationEdit),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded getExtraInformation(Product product) {
    Map<String, dynamic> values = product.toJson();

    switch (product.category) {
      case Category.capacitors:
        return Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSectionMultiple(
                      "Value",
                      FaradsUnit.f
                          .convertTo(values['value'], selections[2])
                          .toString(),
                      1,
                      FaradsUnit.values,
                      2,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Dielectric Type",
                      DielectricType.values[values['dielectricType']].name,
                      1,
                    ),
                    informationSection(
                      "Material",
                      values['material'].toString(),
                      1,
                    ),
                    informationSection(
                      "Tolerance",
                      values['tolerance'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.connectors:
        return Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSectionMultiple(
                      "Current",
                      CurrentUnit.a
                          .convertTo(values['current'], selections[3])
                          .toString(),
                      1,
                      CurrentUnit.values,
                      3,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Pin Count",
                      values['pinCount'].toString(),
                      1,
                    ),
                    informationSection(
                      "Pitch",
                      values['pitch'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Row",
                      values['row'].toString(),
                      1,
                    ),
                    informationSection(
                      "Contact Type",
                      values['contactType'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.discrete_semiconductors:
        return Expanded(
          flex: 5,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSectionMultiple(
                      "Voltage Breakdown",
                      VoltageUnit.v
                          .convertTo(values['voltageBreakdown'], selections[4])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage Reverse",
                      VoltageUnit.v
                          .convertTo(values['voltageReverse'], selections[5])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      5,
                    ),
                    informationSectionMultiple(
                      "Voltage Clamping",
                      VoltageUnit.v
                          .convertTo(values['voltageClamping'], selections[6])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      6,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Current",
                      CurrentUnit.a
                          .convertTo(values['current'], selections[3])
                          .toString(),
                      1,
                      CurrentUnit.values,
                      3,
                    ),
                    informationSection(
                      "Speed",
                      values['speed'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Load Capacitance",
                      FaradsUnit.f
                          .convertTo(values['loadCapacitance'], selections[12])
                          .toString(),
                      1,
                      FaradsUnit.values,
                      12,
                    ),
                    informationSection(
                      "Channel Type",
                      values['channelType'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.displays:
        return Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSectionMultiple(
                      "Current",
                      CurrentUnit.a
                          .convertTo(values['current'], selections[3])
                          .toString(),
                      1,
                      CurrentUnit.values,
                      3,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Interface",
                      values['interface'].toString(),
                      1,
                    ),
                    informationSection(
                      "Resolution",
                      values['resolution'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.inductors:
        return Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSectionMultiple(
                      "Current",
                      CurrentUnit.a
                          .convertTo(values['current'], selections[3])
                          .toString(),
                      1,
                      CurrentUnit.values,
                      3,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Value",
                      HenryUnit.h
                          .convertTo(values['value'], selections[7])
                          .toString(),
                      1,
                      HenryUnit.values,
                      7,
                    ),
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                    informationSection(
                      "Tolerance",
                      values['tolerance'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.integrated_circuits:
        return Expanded(
          flex: 5,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Speed",
                      values['speed'].toString(),
                      1,
                    ),
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Power",
                      selections[8] == 'fraction'
                          ? decimalToFraction(values['power'])
                          : values['power'].toString(),
                      1,
                      ['decimal', 'fraction'],
                      8,
                    ),
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Current",
                      CurrentUnit.a
                          .convertTo(values['current'], selections[3])
                          .toString(),
                      1,
                      CurrentUnit.values,
                      3,
                    ),
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Mounting",
                      values['mounting'].toString(),
                      1,
                    ),
                    informationSection(
                      "Pin Count",
                      values['pinCount'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Flash",
                      FlashUnit.mb
                          .convertTo(values['flash'], selections[9])
                          .toString(),
                      1,
                      FlashUnit.values,
                      9,
                    ),
                    informationSectionMultiple(
                      "Ram",
                      FlashUnit.mb
                          .convertTo(values['ram'], selections[10])
                          .toString(),
                      1,
                      FlashUnit.values,
                      10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.leds:
        return Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSection(
                      "Temperature",
                      values['temperature'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                    informationSection(
                      "Color",
                      LedColor.values[values['color']].name,
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.pcbs:
      case Category.mechanics:
        return Expanded(flex: 3, child: Container());
      case Category.microcontrollers:
        return Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          informationSection(
                            "Speed",
                            values['package'].toString(),
                            1,
                          ),
                          informationSection(
                            "Package",
                            values['package'].toString(),
                            1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Flash",
                      FlashUnit.mb
                          .convertTo(values['flash'], selections[9])
                          .toString(),
                      1,
                      FlashUnit.values,
                      9,
                    ),
                    informationSectionMultiple(
                      "Ram",
                      FlashUnit.mb
                          .convertTo(values['ram'], selections[10])
                          .toString(),
                      1,
                      FlashUnit.values,
                      10,
                    ),
                    informationSection(
                      "Pin Count",
                      values['pinCount'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.miscellaneous:
        return Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          informationSectionMultiple(
                            "Voltage",
                            VoltageUnit.v
                                .convertTo(values['voltage'], selections[1])
                                .toString(),
                            1,
                            VoltageUnit.values,
                            1,
                          ),
                          informationSectionMultiple(
                            "Current",
                            CurrentUnit.a
                                .convertTo(values['current'], selections[3])
                                .toString(),
                            1,
                            CurrentUnit.values,
                            3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.optocouplers:
        return Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          informationSectionMultiple(
                            "Voltage",
                            VoltageUnit.v
                                .convertTo(values['voltage'], selections[1])
                                .toString(),
                            1,
                            VoltageUnit.values,
                            1,
                          ),
                          informationSectionMultiple(
                            "Current",
                            CurrentUnit.a
                                .convertTo(values['current'], selections[3])
                                .toString(),
                            1,
                            CurrentUnit.values,
                            3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                    informationSection(
                      "Speed",
                      values['speed'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case Category.power_supplies:
        return Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          informationSectionMultiple(
                            "Voltage",
                            VoltageUnit.v
                                .convertTo(values['voltage'], selections[1])
                                .toString(),
                            1,
                            VoltageUnit.values,
                            1,
                          ),
                          informationSectionMultiple(
                            "Power",
                            selections[8] == 'fraction'
                                ? decimalToFraction(values['power'])
                                : values['power'].toString(),
                            1,
                            ['decimal', 'fraction'],
                            8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                    informationSectionMultiple(
                      "Current",
                      CurrentUnit.a
                          .convertTo(values['current'], selections[3])
                          .toString(),
                      1,
                      CurrentUnit.values,
                      3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.protection_circuits:
        return Expanded(
          flex: 4,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSectionMultiple(
                      "Voltage Breakdown",
                      VoltageUnit.v
                          .convertTo(values['voltageBreakdown'], selections[4])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage Reverse",
                      VoltageUnit.v
                          .convertTo(values['voltageReverse'], selections[5])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      5,
                    ),
                    informationSectionMultiple(
                      "Voltage Clamping",
                      VoltageUnit.v
                          .convertTo(values['voltageClamping'], selections[6])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      6,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Current",
                      CurrentUnit.a
                          .convertTo(values['current'], selections[3])
                          .toString(),
                      1,
                      CurrentUnit.values,
                      3,
                    ),
                    informationSectionMultiple(
                      "Power",
                      selections[8] == 'fraction'
                          ? decimalToFraction(values['power'])
                          : values['power'].toString(),
                      1,
                      ['decimal', 'fraction'],
                      8,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                    informationSection(
                      "Channel Type",
                      values['channelType'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case Category.resistors:
        return Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Value",
                      OhmUnit.ohm
                          .convertTo(values['value'], selections[11])
                          .toString(),
                      1,
                      OhmUnit.values,
                      11,
                    ),
                    informationSectionMultiple(
                      "Power",
                      selections[8] == 'fraction'
                          ? decimalToFraction(values['power'])
                          : values['power'].toString(),
                      1,
                      ['decimal', 'fraction'],
                      8,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSectionMultiple(
                      "Voltage",
                      VoltageUnit.v
                          .convertTo(values['voltage'], selections[1])
                          .toString(),
                      1,
                      VoltageUnit.values,
                      1,
                    ),
                    informationSection(
                      "Package",
                      values['package'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    informationSection(
                      "Mounting",
                      Mounting.values[values['mounting']].name,
                      1,
                    ),
                    informationSection(
                      "Tolerance",
                      values['tolerance'].toString(),
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      default:
        return Expanded(child: Container());
    }
  }
}
