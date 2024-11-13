import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class AboutUsTile extends StatelessWidget {
  final String title;
  final Widget description;
  final Widget child;

  final bool isLeft;

  const AboutUsTile({
    Key? key,
    required this.child,
    this.isLeft = true,
    this.title = 'Title',
    this.description = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: teal.add(black, 0.3),
                fontSize: height * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}
