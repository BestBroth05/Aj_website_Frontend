import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/contact_view/contact_info.dart';

class LoginAlternativeBackground extends StatelessWidget {
  String rawText = contactInfo['about us']!;

  List<String> boldWords = ['AJ Electronic Design', '"one-stop"', 'product'];
  List<String> text = [];

  @override
  Widget build(BuildContext context) {
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
    return Container(
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _LoginBackgroundPainter(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Welcome!',
                      style: TextStyle(
                        color: teal.add(black, 0.2),
                        fontSize: 75,
                      ),
                    ),
                    AutoSizeText(
                      '  Log in to continue',
                      style: TextStyle(
                        color: black.add(white, 0.6),
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: white,
                  size: 30,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                  Container(
                    height: 100,
                    width: width * 0.35,
                    padding: EdgeInsets.only(left: 10),
                    child: AutoSizeText.rich(
                      TextSpan(
                        text: text[0],
                        children: List.generate(
                          text.length - 1,
                          (index) => TextSpan(
                            text: text[index + 1],
                            style: TextStyle(
                              fontWeight: boldWords.contains(text[index + 1])
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.w900,
                        fontSize: height * 0.02,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()..color = teal;
    // Paint pointPaint = Paint()..color = red;
    // Paint centerPaint = Paint()..color = black;

    List<Offset> points = [
      Offset(size.width * 0.8, size.height),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.2, 0),
    ];
    List<Offset> centers = [];

    Path path = Path()..moveTo(points[0].dx, points[0].dy);
    centers.add(
      Offset(
        size.width * 0.9,
        size.height * 0.7,
      ),
    );
    path.quadraticBezierTo(
      centers[0].dx,
      centers[0].dy,
      points[1].dx,
      points[1].dy,
    );
    centers.add(
      Offset(
        size.width * 0.0,
        size.height * 0.525,
      ),
    );
    path.quadraticBezierTo(
      centers[1].dx,
      centers[1].dy,
      points[2].dx,
      points[2].dy,
    );
    centers.add(
      Offset(
        size.width * 0.725,
        size.height * 0.0 - 100,
      ),
    );
    path.quadraticBezierTo(
      centers[2].dx,
      centers[2].dy,
      points[3].dx,
      points[3].dy,
    );
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);

    // for (Offset center in centers) {
    //   canvas.drawCircle(center, 2, centerPaint);
    // }
    // for (Offset center in points) {
    //   canvas.drawCircle(center, 2, pointPaint);
    // }
  }

  @override
  bool shouldRepaint(_LoginBackgroundPainter oldDelegate) => true;

  Offset triangleCenter(Offset p1, Offset p2, {bool isLeft = true}) {
    Offset p3;

    if (isLeft) {
      p3 = Offset(p1.dx, p2.dy);
    } else {
      p3 = Offset(p2.dx, p1.dy);
    }

    double x = (p1.dx + p2.dx + p3.dx) / 3;
    double y = (p1.dy + p2.dy + p3.dy) / 3;
    Offset center = Offset(x, y);
    return center;
  }
}
