import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class ConfirmDialog extends StatefulWidget {
  final String text;
  final Function function;

  ConfirmDialog({
    Key? key,
    this.text = 'Are you sure?',
    required this.function,
  }) : super(key: key);

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.2,
      height: height * 0.2,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AutoSizeText(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
                color: gray,
              ),
              CustomButton(
                text: 'Confirm',
                color: red,
                onPressed: () {
                  widget.function.call();
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

void openConfirmDialog(
  BuildContext context,
  Function function, {
  String text = 'Are you sure?',
}) =>
    openDialog(
      context,
      container: ConfirmDialog(
        text: text,
        function: function,
      ),
      block: true,
    );
