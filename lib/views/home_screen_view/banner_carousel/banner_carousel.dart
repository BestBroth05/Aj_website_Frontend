import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/home_screen_view/banner_carousel/banner_item.dart';
import 'package:guadalajarav2/views/home_screen_view/banner_carousel/banner_slider.dart';

class BannerCarousel extends StatefulWidget {
  BannerCarousel({Key? key}) : super(key: key);

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  CarouselOptions get carouselOptions => CarouselOptions(
        autoPlay: true,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) => setState(() => page = index),
      );

  CarouselSliderController carouselController = CarouselSliderController();

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height * 0.45,
          width: width,
          color: backgroundColor,
          child: CarouselSlider(
            carouselController: carouselController,
            items: [
              BannerItem(
                image: Image.asset(
                  'assets/images/carousel1.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              BannerItem(
                image: Image.network(
                  'assets/images/carousel2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              BannerItem(
                // description:
                // 'We handle hardware, firmware, software, Industrial design and manufacture',
                image: Image.network(
                  'assets/images/carousel3.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
            options: carouselOptions,
          ),
        ),
        BannerSlider(
          value: page,
          amount: 3,
          onClick: (value) => carouselController.animateToPage(
            value,
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ],
    );
  }
}
