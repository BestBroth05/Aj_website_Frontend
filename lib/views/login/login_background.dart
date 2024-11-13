import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class LoginBackground extends StatefulWidget {
  LoginBackground({Key? key}) : super(key: key);

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground> {
  String rawText = 'We are a "one-stop" solution ready to listen anyone ' +
      'interested in turning an idea into a product.';

  List<String> coloredWords = ['"one-stop"', 'product'];
  List<String> text = [];

  @override
  void initState() {
    super.initState();
    for (String word in coloredWords) {
      if (rawText.contains(word)) {
        List<String> separated = rawText.split(word);
        if (separated[0].isNotEmpty) {
          text.add(separated[0]);
        }
        text.add(word);
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
      height: height * 0.75,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '1PT4AgK_Cf2-xbS33uxmU-maIcPi2inYx'.driveFile,
          ),
        ),
      ),
      child: Container(
        // color: teal.add(black, 0.2).withOpacity(0.4),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.025,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Image.asset(
            //     'assets/images/logo.png',
            //     height: height * 0.15,
            //   ),
            // ),
            Center(
              child: Container(
                // padding: EdgeInsets.all(20),
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: blue,
                    width: 10,
                  ),
                ),
                child: AutoSizeText.rich(
                  TextSpan(
                    text: text[0],
                    children: List.generate(
                      text.length - 1,
                      (index) => TextSpan(
                        text: text[index + 1],
                        style: TextStyle(
                          color: coloredWords.contains(text[index + 1])
                              ? red
                              : white,
                        ),
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: height * 0.05, color: white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
