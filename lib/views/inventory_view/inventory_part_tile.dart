import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/inventory/addNewComponent.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/enums/enumColors.dart';
import 'package:guadalajarav2/inventory/enums/enumCurrent.dart';
import 'package:guadalajarav2/inventory/enums/enumDielectricType.dart';
import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';
import 'package:guadalajarav2/inventory/enums/enumTemperature.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_table.dart';

class InventoryPartTile extends StatefulWidget {
  final Product product;
  final bool isOdd;
  final Map<String, dynamic> units;
  final Function(List<Product> components) updateParts;

  InventoryPartTile(
    this.product, {
    Key? key,
    this.isOdd = false,
    required this.units,
    required this.updateParts,
  }) : super(key: key);

  @override
  State<InventoryPartTile> createState() => _InventoryPartTileState();
}

class _InventoryPartTileState extends State<InventoryPartTile> {
  @override
  Widget build(BuildContext context) {
    int length = InventoryTable.header.length - 1;

    return InkWell(
      onTap: () => openDialog(
        context,
        // container: InventoryPartDialog(
        //   widget.product,
        //   updateParts: widget.updateParts,
        // ),
        container: NewComponentScreen(
          category: widget.product.category!,
          product: widget.product,
          isEditing: false,
        ),
      ),
      child: Container(
        width: width,
        height: 75,
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: widget.isOdd ? backgroundColor : white,
        child: Row(
          children: List.generate(
            InventoryTable.header.length,
            (index) {
              Map<String, dynamic> e = widget.product
                  .toJson()
                  .map((key, value) => MapEntry(key.toLowerCase(), value));

              String key = InventoryTable.header.keys
                  .elementAt(index)
                  .replaceAll(' ', '')
                  .toLowerCase();

              String value = e[key].toString();

              value = convertValue(key, value, widget.units[key.toLowerCase()]);

              if (key.toLowerCase() == 'mpn') {
                value = value.toUpperCase();
              }

              return Expanded(
                child: Container(
                  height: 75,
                  padding: EdgeInsets.only(
                    left: index == length ? 15 : 5,
                    top: 10,
                    right: index == 0 ? 15 : 5,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right: index != length
                          ? BorderSide(color: gray)
                          : BorderSide.none,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 150,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        value,
                        textAlign: TextAlign.center,
                        minFontSize: 2,
                        style: TextStyle(color: value == 'N/A' ? gray : black),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  String convertValue(String key, String value, dynamic selected) {
    if (value != 'null' && value.isNotEmpty) {
      if (key == 'power' && selected == 'fraction') {
        value = decimalToFraction(double.parse(value)).toString();
      } else if (key == 'voltage') {
        value =
            VoltageUnit.v.convertTo(double.parse(value), selected).toString();
      } else if (key == 'current') {
        value =
            CurrentUnit.a.convertTo(double.parse(value), selected).toString();
      } else if (key == 'voltagebreakdown' ||
          key == 'voltagereverse' ||
          key == 'voltageclamping') {
        // print(key);
        value =
            VoltageUnit.v.convertTo(double.parse(value), selected).toString();
        // switch (key) {
        //   case 'voltageBreakdown':
        //     value = VoltageUnit.v
        //         .convertTo(double.parse(value), selected)
        //         .toString();

        //     break;
        //   case 'voltageReverse':
        //     value = VoltageUnit.v
        //         .convertTo(double.parse(value), selected)
        //         .toString();
        //     break;
        //   case 'voltageClamping':
        //     value = VoltageUnit.v
        //         .convertTo(double.parse(value), selected)
        //         .toString();
        //     break;
        // }
      } else if (key == 'value') {
        switch (selected) {
          case 'farad':
            value = FaradsUnit.f
                .convertTo(double.parse(value), widget.units[selected])
                .toString();
            break;
          case 'ohm':
            value = OhmUnit.ohm
                .convertTo(double.parse(value), widget.units[selected])
                .toString();
            break;
          case 'henry':
            value = HenryUnit.h
                .convertTo(double.parse(value), widget.units[selected])
                .toString();
            break;
        }
      } else if (key == 'mounting') {
        value = Mounting.values[int.parse(value)].name;
      } else if (key == 'status') {
        value = ProductStatus.values[int.parse(value)].name;
      } else if (key == 'dielectrictype') {
        value = DielectricType.values[int.parse(value)].name.toString();
      } else if (key == 'color') {
        value = LedColor.values[int.parse(value)].name;
      } else if (key == 'temperature') {
        value = TemperatureUnit.c
            .convertTo(double.parse(value), selected)
            .toString();
      }
    } else {
      value = 'N/A';
    }
    return value;
  }
}
