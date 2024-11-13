import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class DashboardTopBarButton extends StatefulWidget {
  final String text;
  final bool isPressed;
  final VoidCallback onPressed;
  final double width;
  DashboardTopBarButton(
    this.text, {
    Key? key,
    this.width = 100,
    this.isPressed = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<DashboardTopBarButton> createState() => _DashboardTopBarButtonState();
}

class _DashboardTopBarButtonState extends State<DashboardTopBarButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: widget.width,
      child: Center(
        child: InkWell(
          onTap: widget.onPressed,
          onHover: (value) => setState(() => isHover = value),
          child: AutoSizeText(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: teal.add(black, 0.2),
              decoration: widget.isPressed ? TextDecoration.underline : null,
              fontWeight: isHover || widget.isPressed
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
