import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/styles.dart';

class SearchMenuTextField extends StatefulWidget {
  final bool inRow;
  final String title;
  final TextEditingController controller;
  final VoidCallback onEnter;

  SearchMenuTextField({
    Key? key,
    this.title = '',
    this.inRow = false,
    required this.onEnter,
    required this.controller,
  }) : super(key: key);

  @override
  _SearchMenuTextFieldState createState() => _SearchMenuTextFieldState();
}

class _SearchMenuTextFieldState extends State<SearchMenuTextField> {
  List<Widget> children = [];
  String title = '';

  @override
  void initState() {
    super.initState();
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    if (title == 'Speed') {
      title = 'Speed (Mbps)';
    } else if (title == 'Temperature') {
      title = 'Milicandela Rating (mcd)';
    }

    List<Widget> children = [];
    Expanded titleText = Expanded(
      child: AutoSizeText(
        title,
        style: subTitleSearchMenu,
        maxLines: 1,
        minFontSize: 2,
      ),
    );
    Expanded textField = Expanded(
      child: AutoSizeTextField(
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintStyle: TextStyle(fontStyle: FontStyle.italic),
          fillColor: lightGrey,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          focusColor: darkGrey,
        ),
        style: textfieldSearchMenu,
        minFontSize: 1,
        maxFontSize: 30,
        onEditingComplete: widget.onEnter,
      ),
    );
    if (!widget.inRow) {
      children = [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [titleText],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    textField,
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    } else {
      children = [
        titleText,
        textField,
      ];
    }
    return Container(
      child: Row(children: children),
    );
  }
}
