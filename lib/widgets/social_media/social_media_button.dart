import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/social_media.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaButton extends StatefulWidget {
  final SocialMedia socialMedia;
  final String url;
  SocialMediaButton(
    this.socialMedia, {
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<SocialMediaButton> createState() => _SocialMediaButtonState();
}

class _SocialMediaButtonState extends State<SocialMediaButton> {
  double size = 30;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        String url = widget.socialMedia.url + widget.url;

        if (!await launch(url)) throw 'Could not launch $url';
      },
      padding: EdgeInsets.zero,
      splashRadius: size / 2,
      icon: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: teal,
            width: 2,
          ),
        ),
        child: Image.asset(
          widget.socialMedia.imageURL,
          color: teal,
        ),
      ),
    );
  }
}
