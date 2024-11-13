import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ServiceSubSection extends StatelessWidget {
  final String title;
  final List<String> services;
  final String? imgUrl;
  final bool isReversed;
  ServiceSubSection(
    this.title,
    this.services, {
    Key? key,
    this.isReversed = false,
    this.imgUrl,
  }) : super(key: key);

  final TextStyle textStyle = TextStyle(color: black);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: [
          isReversed && imgUrl != null
              ? Expanded(
                  child: Center(
                    child: Image.asset(
                      imgUrl!,
                      height: 400,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: isReversed
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  title,
                  style: textStyle.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: isReversed
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: services
                      .map(
                        (e) => AutoSizeText(
                          e,
                          style: textStyle.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
          !isReversed && imgUrl != null
              ? Expanded(
                  child: Center(
                    child: Image.asset(
                      imgUrl!,
                      height: 400,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
