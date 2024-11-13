import 'package:auto_size_text_field/auto_size_text_field.dart';
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

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                child: AutoSizeTextField(
                  // expands: true,
                  // maxLines: null,
                  // minLines: null,
                  onSubmitted: widget.onEnter,
                  controller: widget.controller,
                  obscureText: widget.isSecret,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: widget.title == 'Username'
                        ? Icon(Icons.people_alt_rounded)
                        : Icon(Icons.lock_rounded),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: width * 0.01),
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
                  style: textfieldSearchMenu,
                  minFontSize: 1,
                  maxFontSize: 40,
                  // onEditingComplete: hintTxt == 'Username'
                  //     ? null
                  //     : () async {
                  //         if (await login(
                  //           context,
                  //           userController.text,
                  //           passwordController.text,
                  //         )) {
                  //           changeScreen(
                  //             context,
                  //             RoutesName.DASHBOARD,
                  //           );
                  //         } else {}
                  //       },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
