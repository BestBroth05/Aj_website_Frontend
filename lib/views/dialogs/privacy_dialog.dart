import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'dart:ui' as ui;
import 'dart:html';

import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class PrivacyDialog extends StatefulWidget {
  final String privacyURL;
  PrivacyDialog(this.privacyURL, {Key? key}) : super(key: key);

  @override
  State<PrivacyDialog> createState() => _PrivacyDialogState();
}

class _PrivacyDialogState extends State<PrivacyDialog> {
  String get backgroundURL =>
      'https://drive.google.com/uc?id=1IUCx_Cg0xtdX5VsyQuls-bB8ZEqsy_Ff';

  late NetworkImage backgroundImage;

  @override
  void initState() {
    super.initState();
    backgroundImage = NetworkImage(
      backgroundURL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.5,
      width: width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(image: backgroundImage, fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AutoSizeText(
                  'AJ\'s Privacy Policy',
                  style: TextStyle(
                    color: white,
                    fontSize: height * 0.075,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.075),
                child: AutoSizeText(
                  'We recommend that you read this policy and make sure you understand it completely, before agreeing with or utilize any of our services',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: white,
                    fontSize: height * 0.02,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.1),
              child: CustomButton(
                text: 'Download',
                color: teal.add(black, 0.2),
                elevated: true,
                onPressed: () =>
                    openLink(context, widget.privacyURL, isDownload: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
