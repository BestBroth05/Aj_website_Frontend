import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/widgets/custom/custom_drop_down.dart';

class InventoryDropdown<T> extends StatefulWidget {
  final T value;
  final String keyHeader;
  final String name;
  final Function(String key, dynamic value)? onChanged;
  final Map<T, String> items;

  InventoryDropdown({
    Key? key,
    required this.name,
    required this.onChanged,
    required this.value,
    required this.items,
    required this.keyHeader,
  }) : super(key: key);

  @override
  State<InventoryDropdown<T>> createState() => _InventoryDropdownState<T>();
}

class _InventoryDropdownState<T> extends State<InventoryDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>(
      onChanged: (value) => widget.onChanged!.call(widget.keyHeader, value),
      color: teal.add(black, 0.3),
      dropdownColor: teal.add(black, 0.3),
      value: widget.value,
      items: widget.items.entries
          .map(
            (entry) => DropdownMenuItem<T>(
              child: Center(
                child: AutoSizeText(
                  '${widget.name} ${entry.value}'.toTitle(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: white),
                ),
              ),
              value: entry.key,
            ),
          )
          .toList(),
    );
  }
}
