import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/about_view/about_our_projects.dart';
import 'package:guadalajarav2/views/about_view/about_our_services.dart';
import 'package:guadalajarav2/views/about_view/about_us_tile/about_us_tile.dart';
import 'package:guadalajarav2/views/contact_view/contact_info.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController? videoPlayerController;

class AboutView extends StatefulWidget {
  AboutView({Key? key}) : super(key: key);

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  String rawText = contactInfo['about us']!;

  List<String> boldWords = ['AJ Electronic Design', '"one-stop"', 'product'];
  List<String> text = [];
  List<double> positions = [0, 500, 1000];

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset(
      'assets/videos/AJ_SUB.mp4',
    )..initialize().then((value) => setState(() {}));
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
    videoPlayerController!.setVolume(0);
    videoPlayerController!.play();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Column(
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        AboutUsTile(
                          title: 'WHAT IS AJ?',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: AutoSizeText.rich(
                              TextSpan(
                                text: text[0],
                                children: List.generate(
                                  text.length - 1,
                                  (index) => TextSpan(
                                    text: text[index + 1],
                                    style: TextStyle(
                                      fontWeight:
                                          boldWords.contains(text[index + 1])
                                              ? FontWeight.w900
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                color: teal.add(black, 0.3),
                                fontWeight: FontWeight.w900,
                                fontSize: height * 0.02,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: AspectRatio(
                            aspectRatio:
                                videoPlayerController!.value.aspectRatio * 1.5,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                VideoPlayer(videoPlayerController!),
                                InkWell(
                                  onTap: () => setState(
                                    () {
                                      bool isPlaying = videoPlayerController!
                                          .value.isPlaying;

                                      if (isPlaying &&
                                          videoPlayerController!.value.volume ==
                                              1) {
                                        videoPlayerController!.pause();
                                      } else {
                                        videoPlayerController!.setVolume(1);
                                        videoPlayerController!.play();
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Image.asset(
                      'assets/images/about_us.png',
                      height: 500,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 120,
                ),
                child: AboutUsTile(
                  title: 'OUR SERVICES',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: AboutOurServices(),
                  ),
                ),
              ),
              AboutUsTile(
                title: 'PROJECTS',
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            AutoSizeText(
                              'Leave a like on projects that you like',
                              style: TextStyle(
                                color: teal,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AboutOurProjects(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
