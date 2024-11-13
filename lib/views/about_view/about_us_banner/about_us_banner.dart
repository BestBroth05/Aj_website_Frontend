import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:video_player/video_player.dart';

class AboutUsBanner extends StatefulWidget {
  AboutUsBanner({Key? key}) : super(key: key);

  @override
  State<AboutUsBanner> createState() => _AboutUsBannerState();
}

class _AboutUsBannerState extends State<AboutUsBanner> {
  late VideoPlayerController _controller;

  String videoUrl = 'assets/videos/about_us_video.mp4';

  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      videoUrl,
    )..initialize().then((_) async {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0);
      });

    Timer.run(() async {
      while (!_controller.value.isInitialized) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: width,
      child: _controller.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                Container(color: teal.add(black, 0.2).withOpacity(0.7)),
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Center(
                      child: AutoSizeText(
                        'Here is where your slogan will be!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: white,
                          fontSize: height * 0.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
