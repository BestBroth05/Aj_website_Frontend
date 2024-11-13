import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ProductTile extends StatelessWidget {
  final String value;
  final String title;
  const ProductTile({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: width * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            value,
            style: TextStyle(
              color: teal,
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          AutoSizeText(
            title,
            style: TextStyle(color: darkGrey, fontSize: height * 0.02),
          ),
        ],
      ),
    );
  }
}
