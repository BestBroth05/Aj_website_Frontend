import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final VoidCallback onEnter;
  CustomTextField({
    Key? key,
    this.hint,
    required this.onEnter,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: AutoSizeTextField(
        controller: widget.controller,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          isDense: false,
          isCollapsed: false,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontStyle: FontStyle.italic,
          ),
          suffixIcon: IconButton(
            splashRadius: 1,
            icon: Icon(Icons.cancel, size: 15),
            onPressed: () {
              widget.controller.clear();
              widget.onEnter.call();
            },
          ),
        ),
        onEditingComplete: widget.onEnter,
      ),
    );
  }
}
