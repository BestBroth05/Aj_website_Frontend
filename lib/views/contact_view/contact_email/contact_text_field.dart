import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class ContactTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool expands;
  final String text;
  ContactTextField(
    this.controller, {
    Key? key,
    this.expands = false,
    this.text = '',
  }) : super(key: key);

  @override
  State<ContactTextField> createState() => _ContactTextFieldState();
}

class _ContactTextFieldState extends State<ContactTextField> {
  Color get color => lightGrey.add(black, 0.2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          widget.text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: AutoSizeTextField(
            controller: widget.controller,
            expands: widget.expands,
            minLines: widget.expands ? null : 1,
            maxLines: widget.expands ? null : 1,
            textAlignVertical: widget.expands
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: green),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
