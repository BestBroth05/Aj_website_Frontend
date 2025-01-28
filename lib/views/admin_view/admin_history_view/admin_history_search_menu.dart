import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/Movements/movementType.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class AdminHistorySearchMenu extends StatefulWidget {
  final Map<String, dynamic> filters;
  final Function(String key, dynamic value) changeFilter;
  AdminHistorySearchMenu({
    Key? key,
    required this.filters,
    required this.changeFilter,
  }) : super(key: key);
  @override
  State<AdminHistorySearchMenu> createState() => _AdminHistorySearchMenuState();
}

class _AdminHistorySearchMenuState extends State<AdminHistorySearchMenu> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              width: width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: gray,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: AutoSizeText(
                  'Search Filters',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: Column(
                children: {
                  'category': MovementGType.values,
                  'type': MovementType.values,
                }
                    .entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _SearchFilterTile(
                          e.key,
                          values: e.value,
                          value: widget.filters[e.key],
                          onChange: (value) =>
                              widget.changeFilter(e.key, value),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchFilterTile extends StatelessWidget {
  final String title;
  final List<dynamic> values;
  final dynamic value;
  final Function(dynamic value) onChange;
  const _SearchFilterTile(
    this.title, {
    Key? key,
    required this.value,
    required this.values,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> itemsValues = [null];

    values.forEach((v) => itemsValues.add(v));

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              title.toTitle(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<dynamic>(
                underline: SizedBox(),
                isExpanded: true,
                value: value,
                items: itemsValues.map((e) {
                  String valueString = e.toString();

                  if (e != null) {
                    valueString = separateWords(valueString.split('.')[1]);
                  } else {
                    valueString = 'None';
                  }

                  return DropdownMenuItem(
                    child: Center(
                      child: AutoSizeText(
                        valueString.toTitle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    value: e,
                  );
                }).toList(),
                onChanged: onChange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
