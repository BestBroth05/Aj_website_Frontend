import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ServicesBelt extends StatefulWidget {
  final String title;
  final String urlRoot;

  ServicesBelt(
    this.title, {
    Key? key,
    required this.urlRoot,
  }) : super(key: key);

  @override
  State<ServicesBelt> createState() => _ServicesBeltState();
}

class _ServicesBeltState extends State<ServicesBelt> {
  CarouselSliderController controller = CarouselSliderController();

  List<String> imagesURLs = [];

  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      String manifestJson =
          await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      Iterable<String> imagesIt = json.decode(manifestJson).keys.where(
          (String key) => key.startsWith('assets/images/${widget.urlRoot}'));
      for (String image in imagesIt) {
        String imgStr = image.replaceAll('%20', ' ');
        // images.add(AssetImage(imgStr));
        imagesURLs.add(imgStr);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 40,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => controller.previousPage(),
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              iconSize: 50,
            ),
            SizedBox(
              height: 100,
              width: width * 0.6,
              child: CarouselSlider(
                items: imagesURLs
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          '$e',
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                    .toList(),
                carouselController: controller,
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 0.25,
                  enlargeCenterPage: true,
                ),
              ),
            ),
            IconButton(
              onPressed: () => controller.nextPage(),
              icon: Icon(Icons.arrow_forward_ios_rounded),
              iconSize: 50,
            ),
          ],
        )
      ],
    );
  }
}
