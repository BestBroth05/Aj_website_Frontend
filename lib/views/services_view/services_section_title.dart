import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ServiceSectionTitle extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? subtitle;

  const ServiceSectionTitle(
    this.title, {
    Key? key,
    required this.imageUrl,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/images/$imageUrl.png'),
              ),
              AutoSizeText(
                '$title'.toUpperCase(),
                style: TextStyle(
                  color: teal.add(black, 0.5),
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              )
            ],
          ),
          subtitle == null
              ? Container()
              : AutoSizeText(
                  '$subtitle'.toUpperCase(),
                  style: TextStyle(
                    color: teal.add(black, 0.5),
                    fontSize: 20,
                  ),
                ),
        ],
      ),
    );
  }
}
