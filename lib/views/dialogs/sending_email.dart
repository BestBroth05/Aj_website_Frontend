import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class SendingEmailDialog extends StatefulWidget {
  SendingEmailDialog({Key? key}) : super(key: key);

  @override
  State<SendingEmailDialog> createState() => _SendingEmailDialogState();
}

class _SendingEmailDialogState extends State<SendingEmailDialog> {
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
                'Sending...',
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
