import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/contact_view/contact_info.dart';

class ShortAbout extends StatefulWidget {
  ShortAbout({Key? key}) : super(key: key);

  @override
  State<ShortAbout> createState() => _ShortAboutState();
}

class _ShortAboutState extends State<ShortAbout> {
  String rawText = contactInfo['about us']!;

  List<String> boldWords = ['AJ Electronic Design', '"one-stop"', 'product'];
  List<String> text = [];

  @override
  void initState() {
    super.initState();
    for (String boldWord in boldWords) {
      if (rawText.contains(boldWord)) {
        List<String> separated = rawText.split(boldWord);
        if (separated[0].isNotEmpty) {
          text.add(separated[0]);
        }
        text.add(boldWord);
        rawText = separated[1];
      } else {
        continue;
      }
    }
    text.add(rawText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText.rich(
            TextSpan(
              text: text[0],
              children: List.generate(
                text.length - 1,
                (index) => TextSpan(
                  text: text[index + 1],
                  style: TextStyle(
                    fontWeight: boldWords.contains(text[index + 1])
                        ? FontWeight.w900
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
            style: TextStyle(
              color: Color.fromRGBO(4, 56, 28, 1),
              fontWeight: FontWeight.w900,
              fontSize: height * 0.02,
            ),
          )
        ],
      ),
    );
  }
}
