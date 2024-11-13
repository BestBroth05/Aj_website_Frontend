import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class LoginMinimalistTextField extends StatefulWidget {
  final TextEditingController controller;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? hint;

  LoginMinimalistTextField({
    Key? key,
    required this.controller,
    this.icon,
    this.hint,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<LoginMinimalistTextField> createState() =>
      _LoginMinimalistTextFieldState();
}

class _LoginMinimalistTextFieldState extends State<LoginMinimalistTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AutoSizeTextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hint,
          prefixIcon: widget.icon,
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
