import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class BasicTextDialog extends StatefulWidget {
  final String text;
  BasicTextDialog(this.text, {Key? key}) : super(key: key);

  @override
  State<BasicTextDialog> createState() => _SendingEmailDialogState();
}

class _SendingEmailDialogState extends State<BasicTextDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.15,
      height: height * 0.15,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AutoSizeText(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.03,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: SpinKitSquareCircle(
                color: teal.add(black, 0.2),
                size: height * 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
