import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class LoadingData extends StatefulWidget {
  LoadingData({Key? key}) : super(key: key);

  @override
  State<LoadingData> createState() => _SendingEmailDialogState();
}

class _SendingEmailDialogState extends State<LoadingData> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Container(
        child: Container(
          height: 125,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        'Loading data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.03,
                        ),
                      ),
                    )),
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
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.5),
              blurRadius: 20,
            )
          ],
        ),
      ),
    );
  }
}
