import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class LoginTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool isSecret;
  final Function(String value)? onEnter;
  LoginTextField({
    Key? key,
    required this.title,
    required this.controller,
    this.onEnter,
    this.isSecret = false,
  }) : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

bool _obscureText = true;

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 320,
        height: 44,
        child: MouseRegion(
          child: TextField(
            style: textfieldSearchMenu,
            controller: widget.controller,
            onSubmitted: widget.onEnter,
            obscureText: widget.isSecret ? _obscureText : false,
            // keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              prefixIcon: widget.title == 'Username'
                  ? Icon(Icons.people_alt_rounded)
                  : Icon(Icons.lock_rounded),
              contentPadding: EdgeInsets.symmetric(horizontal: width * 0.01),
              hintStyle: TextStyle(fontStyle: FontStyle.italic),
              hintText: 'Enter ${widget.title} here...',
              filled: false,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: lightDarkGrey,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: lightDarkGrey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: green,
                ),
              ),
              focusColor: darkGrey,
            ),
          ),
        ),
      ),
    );
  }
}
