import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ServiceBox extends StatelessWidget {
  final String text;

  ServiceBox(this.text, {Key? key}) : super(key: key);

  final BorderSide border = BorderSide(color: gray.add(black, 0.25));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.15,
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: CustomPaint(painter: _PastePainter()),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              color: white,
              width: width * 0.1,
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: AutoSizeText(
                  '$text'.toTitle(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: teal.add(black, 0.6),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PastePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()
      ..color = teal.add(black, 0.5)
      ..style = PaintingStyle.stroke;
    Paint paintCircle = Paint()..color = green.add(black, 0.6);

    double radius = 5;

    Offset p1 = Offset(
      size.width * 0.5 - width * 0.05 - radius,
      size.height,
    );
    Offset p2 = Offset(
      size.width * 0.5 + width * 0.05,
      0,
    );

    Path path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.centerRight.dx, rect.centerRight.dy)
      ..lineTo(rect.centerLeft.dx, rect.centerLeft.dy)
      ..lineTo(rect.topLeft.dx, rect.topLeft.dy)
      ..lineTo(p2.dx, p2.dy);

    canvas.drawCircle(p1, radius, paintCircle);
    canvas.drawCircle(p2, radius, paintCircle);
    canvas.drawPath(path, paint);

    // canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_PastePainter oldDelegate) => true;
}
