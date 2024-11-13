import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class BomFilterButton extends StatefulWidget {
  final String text;
  final Function(bool newValue) onPressed;
  final bool isActive;
  BomFilterButton(
    this.text, {
    Key? key,
    required this.onPressed,
    required this.isActive,
  }) : super(key: key);

  @override
  State<BomFilterButton> createState() => _BomFilterButtonState();
}

class _BomFilterButtonState extends State<BomFilterButton> {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: widget.text,
      color: widget.isActive
          ? teal.add(black, 0.2)
          : backgroundColor.add(black, 0.4),
      onPressed: () => widget.onPressed.call(!widget.isActive),
    );
  }
}
