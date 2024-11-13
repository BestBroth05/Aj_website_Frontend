import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class LoadingScreen extends StatefulWidget {
  final String text;

  LoadingScreen({required this.text});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.15,
      height: height * 0.15,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: AutoSizeText(
              "${widget.text}",
              textAlign: TextAlign.center,
              style: subtitleEdit,
            ),
          ),
          SpinKitWave(
            color: green,
            size: height * 0.03,
            itemCount: 5,
          ),
        ],
      ),
    );
  }
}
