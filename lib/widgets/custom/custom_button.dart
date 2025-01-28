import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double height;
  final double width;
  final bool elevated;
  final IconData? icon;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final bool isBold;
  CustomButton({
    Key? key,
    this.icon,
    this.onPressed,
    this.text = '',
    this.isBold = false,
    this.elevated = false,
    this.height = 50,
    this.width = 100,
    this.borderRadius,
    this.color = Colors.teal,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: widget.elevated ? 5 : 0,
        backgroundColor: widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
        ),
      ),
      onPressed: widget.onPressed,
      child: Container(
        width: widget.width,
        height: widget.height,
        child: Row(
          mainAxisAlignment: widget.icon != null
              ? widget.text.isNotEmpty
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center
              : MainAxisAlignment.center,
          children: [
            widget.text.isNotEmpty
                ? Expanded(
                    child: AutoSizeText(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.textColor,
                        fontWeight:
                            widget.isBold ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  )
                : Container(),
            widget.icon != null
                ? Icon(widget.icon, color: widget.textColor)
                : Container(),
          ],
        ),
      ),
    );
  }
}
