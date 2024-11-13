import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class AboutUsMiniMenu extends StatefulWidget {
  final Function(int index) onPressed;

  AboutUsMiniMenu({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<AboutUsMiniMenu> createState() => _AboutUsMiniMenuState();
}

class _AboutUsMiniMenuState extends State<AboutUsMiniMenu> {
  List<String> texts = ['What is AJ?', 'Our Services', 'Projects'];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.1,
      height: 300,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          texts.length,
          (index) {
            String text = texts[index];
            return TextButton(
              onPressed: () => widget.onPressed.call(index),
              child: AutoSizeText(
                '$text',
                style: TextStyle(
                  color: teal.add(black, 0.3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
