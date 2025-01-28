import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/utils/styles.dart';

class SearchMenuDropdown<T> extends StatefulWidget {
  final T value;
  final int indexOfValue;
  final List<T> values;
  final Function(dynamic newValue) onChanged;

  SearchMenuDropdown({
    Key? key,
    required this.value,
    required this.values,
    required this.onChanged,
    this.indexOfValue = 0,
  }) : super(key: key);

  @override
  _SearchMenuDropdownState<T> createState() => _SearchMenuDropdownState<T>();
}

class _SearchMenuDropdownState<T> extends State<SearchMenuDropdown<T>> {
  List<dynamic> valuesList = [];
  @override
  void initState() {
    super.initState();

    if (widget.indexOfValue == 1 ||
        widget.indexOfValue == 3 ||
        widget.indexOfValue == 13) {
      valuesList.add('null');
    }
    valuesList.addAll(widget.values);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      hint: Center(
        child: AutoSizeText(
          'None',
          textAlign: TextAlign.center,
          maxLines: 1,
          minFontSize: 1,
          style: subTitleSearchMenu,
        ),
      ),
      style: dropdownButtonGrey,
      items: valuesList.map(
        (dynamic item) {
          String name = '';
          if (item.toString() == 'null') {
            name = 'None';
          } else {
            name = item.toString().split('.')[1];
            switch (item.runtimeType) {
              case Category:
                name = name.toUpperCase().split('_').join(' ');
                break;
              case ProductStatus:
                name = name.substring(0, 1).toUpperCase() +
                    name.substring(1).toLowerCase();
                break;

              case VoltageUnit:
                if (name.length > 1) {
                  name = name.substring(0, 1).toLowerCase() +
                      name.substring(1).toUpperCase();
                } else {
                  name = name.toUpperCase();
                }
            }
          }

          return DropdownMenuItem<dynamic>(
            value: item,
            child: Center(
              child: AutoSizeText(
                name,
                textAlign: TextAlign.center,
                maxLines: name.split(' ').length,
                minFontSize: 1,
                style: subTitleSearchMenu,
              ),
            ),
          );
        },
      ).toList(),
      isExpanded: true,
      isDense: true,
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}
