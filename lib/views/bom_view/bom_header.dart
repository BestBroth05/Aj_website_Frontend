import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/inventory/enums/enumCurrent.dart';
import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';
import 'package:guadalajarav2/inventory/enums/enumTemperature.dart';
import 'package:guadalajarav2/inventory/enums/enumValueUnit.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_dropdown.dart';
import 'package:guadalajarav2/widgets/custom/custom_drop_down.dart';

class BomHeader extends StatefulWidget {
  final Map<String, int> headerMap;
  final double totalCost;
  final int requiredTimes;
  final bool isExpandedHorizontal;
  final double? width;
  final Map<String, dynamic> units;
  final Function(String key, dynamic value)? changesMade;

  BomHeader(
    this.headerMap, {
    Key? key,
    this.width,
    this.totalCost = 0,
    this.requiredTimes = 1,
    this.units = const {},
    this.isExpandedHorizontal = false,
    this.changesMade,
  }) : super(key: key);

  @override
  State<BomHeader> createState() => _BomHeaderState();
}

class _BomHeaderState extends State<BomHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: widget.width != null ? widget.width : width,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: teal.add(black, 0.3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(2.5)),
      ),
      child: Row(
        children: widget.headerMap.entries.toList().map((entry) {
          int index = widget.headerMap.keys.toList().indexOf(entry.key);

          String header = entry.key == 'mpn'
              ? entry.key.toUpperCase()
              : entry.key == 'required'
                  ? '${entry.key.toTitle()}\nx${widget.requiredTimes}'
                  : entry.key == 'total cost'
                      ? '${entry.key}\n\$ ${widget.totalCost.toStringAsFixed(2)}'
                      : entry.key.toTitle();
          String key = header.toLowerCase().replaceAll(' ', '');
          return Expanded(
            flex: entry.value,
            child: Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  right: index != widget.headerMap.length - 1
                      ? BorderSide(color: white)
                      : BorderSide.none,
                ),
              ),
              child: widget.units.keys.contains(key)
                  ? InventoryDropdown(
                      name: header,
                      items: getItems(key),
                      keyHeader: key,
                      value: key == 'value'
                          ? widget.units[widget.units['value']]
                          : widget.units[key],
                      onChanged: widget.changesMade,
                    )
                  : AutoSizeText(
                      header.toTitle(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: white),
                      // maxLines: header.split(' ').length,
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Map<dynamic, String> getItems(String key) {
    Iterable<MapEntry<dynamic, String>> entries = [];
    switch (key) {
      case 'voltage':
      case 'voltagereverse':
      case 'voltageclamping':
      case 'voltagebreakdown':
        entries = VoltageUnit.values.map(
          (e) => MapEntry<VoltageUnit, String>(e, e.unit),
        );
        break;
      case 'current':
        entries = CurrentUnit.values.map(
          (e) => MapEntry<CurrentUnit, String>(e, e.unit),
        );
        break;
      case 'temperature':
        entries = TemperatureUnit.values.map(
          (e) => MapEntry<TemperatureUnit, String>(e, e.name),
        );
        break;
      case 'power':
        entries = ['decimal', 'fraction'].map(
          (e) => MapEntry<String, String>(e, e),
        );
        break;

      case 'value':
        switch (widget.units[key]) {
          case 'farad':
            entries = FaradsUnit.values.map(
              (e) => MapEntry<FaradsUnit, String>(e, e.unit),
            );
            break;
          case 'henry':
            entries = HenryUnit.values.map(
              (e) => MapEntry<HenryUnit, String>(e, e.unit),
            );
            break;
          case 'ohm':
            entries = OhmUnit.values.map(
              (e) => MapEntry<OhmUnit, String>(e, e.unit),
            );
            break;
        }
        break;
    }

    return Map.fromEntries(entries);
  }
}
