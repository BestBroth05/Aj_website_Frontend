import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class CustomDropdown<T> extends StatefulWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value) onChanged;
  final Color dropdownColor;
  final Color color;

  CustomDropdown({
    Key? key,
    this.color = Colors.white,
    this.dropdownColor = Colors.white,
    required this.onChanged,
    required this.value,
    required this.items,
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: width,
      child: DropdownButton<T>(
        value: widget.value,
        dropdownColor: widget.dropdownColor,
        focusColor: Colors.transparent,
        underline: SizedBox(),
        icon: SizedBox(),

        isExpanded: true,
        // icon: SizedBox(),
        selectedItemBuilder: (context) => widget.items
            .map(
              (e) => Center(
                child: Container(
                  child: e.child,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
            .toList(),
        items: widget.items,
        onChanged: widget.onChanged,
      ),
    );
  }
}
