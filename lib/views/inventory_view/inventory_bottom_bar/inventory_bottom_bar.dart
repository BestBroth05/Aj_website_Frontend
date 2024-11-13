import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/inventory/addNewComponent.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_top_bar_button.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';
import 'package:guadalajarav2/widgets/custom/custom_drop_down.dart';
import 'package:guadalajarav2/widgets/custom/custom_text_field.dart';

class InventoryBottomBar extends StatefulWidget {
  final Category category;
  final Function(String text) searchFunction;
  Map<String, String?> filters;
  final Function(String filter, String? value) addFilter;
  InventoryBottomBar({
    Key? key,
    required this.filters,
    required this.addFilter,
    required this.searchFunction,
    required this.category,
  }) : super(key: key);

  @override
  _InventoryBottomBarState createState() => _InventoryBottomBarState();
}

class _InventoryBottomBarState extends State<InventoryBottomBar> {
  TextEditingController controller = TextEditingController();

  Map<String, Map<String, dynamic>> filterItems = {
    'mpn': {
      'items': ['A-Z', 'Z-A'],
      'icon': Icons.key_rounded,
    },
    'description': {
      'items': ['A-Z', 'Z-A'],
      'icon': Icons.text_fields_rounded,
    },
    'unitPrice': {
      'items': ['Low - High', 'High - Low'],
      'icon': Icons.price_change_rounded,
    },
    'manufacturer': {
      'items': ['A-Z', 'Z-A'],
      'icon': Icons.location_city_rounded,
    },
    'quantity': {
      'items': ['Low - High', 'High - Low'],
      'icon': Icons.numbers
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomTextField(
              controller: controller,
              hint: 'Search by MPN...',
              onEnter: () => widget.searchFunction.call(controller.text),
            ),
          ),
          SizedBox(
            width: width * 0.6,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: filterItems.entries
                        .map(
                          (e) => Expanded(
                            child: _FilterDropdown(
                              widget.filters[e.key],
                              items: e.value['items'],
                              icon: e.value['icon'],
                              hint: e.key.toTitle(),
                              onChanged: (value) =>
                                  widget.addFilter.call(e.key, value),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CustomButton(
              text: '+',
              width: 25,
              height: 35,
              onPressed: () => openDialog(
                context,
                container: NewComponentScreen(category: widget.category),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final Function(String? value) onChanged;
  final IconData icon;
  _FilterDropdown(
    this.value, {
    Key? key,
    required this.icon,
    required this.onChanged,
    required this.items,
    required this.hint,
  }) : super(key: key);

  @override
  State<_FilterDropdown> createState() => __FilterDropdownState();
}

class __FilterDropdownState extends State<_FilterDropdown> {
  List<String> items = ['None'];

  @override
  void initState() {
    super.initState();
    items.addAll(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String?>(
          isExpanded: true,
          underline: SizedBox(),
          borderRadius: BorderRadius.circular(5),
          hint: Row(
            children: [
              Icon(widget.icon, color: gray.add(black, 0.2)),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AutoSizeText(widget.hint),
              ),
            ],
          ),
          icon: SizedBox(),
          selectedItemBuilder: (context) => items
              .map(
                (e) => Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: gray.add(black, 0.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: AutoSizeText(e),
                    ),
                  ],
                ),
              )
              .toList(),
          items: items
              .map(
                (e) => DropdownMenuItem<String?>(
                  child: AutoSizeText(e),
                  value: e,
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          value: widget.value,
        ),
      ),
    );
  }
}
