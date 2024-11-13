import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class BannerItem extends StatefulWidget {
  final String text;
  final String description;
  final Widget image;
  final List<String> coloredText;
  BannerItem({
    Key? key,
    this.text = '',
    this.description = '',
    this.coloredText = const [],
    this.image = const SizedBox(),
  }) : super(key: key);

  @override
  State<BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem> {
  List<String> titleText = [];

  @override
  void initState() {
    super.initState();
    String original = widget.text;
    for (int i = 0; i < widget.coloredText.length; i++) {
      String t = original.split(widget.coloredText[i])[0];
      titleText.add(t);
      titleText.add(widget.coloredText[i]);
      original = original.substring(t.length + widget.coloredText[i].length);
    }
    if (original.isNotEmpty) {
      titleText.add(original);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.image,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AutoSizeText(
                //   widget.text,
                //   style: TextStyle(
                //     color: teal.add(black, 0.2),
                //     fontSize: height * 0.05,
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),
                titleText.length > 1
                    ? AutoSizeText.rich(
                        TextSpan(
                          text: titleText[0],
                          children: List.generate(
                            titleText.length - 1,
                            (index) => TextSpan(
                              text: titleText[index + 1],
                              style: TextStyle(
                                color:
                                    index % 2 == 0 ? red.add(black, 0.2) : null,
                              ),
                            ),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // color: teal.add(black, 0.2),
                          color: white,
                          fontSize: height * 0.05,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    : AutoSizeText(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // color: teal.add(black, 0.2),
                          color: white,
                          fontSize: height * 0.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                AutoSizeText(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: white,
                    fontSize: height * 0.025,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
