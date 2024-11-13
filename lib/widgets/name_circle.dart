import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class NameCircle extends StatelessWidget {
  final String first;
  final String second;
  final Color color;
  const NameCircle(
    this.first,
    this.second, {
    Key? key,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: AutoSizeText(
        '${first[0]}${second[0]}'.toUpperCase(),
        style: TextStyle(
          color: white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
