import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class TimedDialog extends StatefulWidget {
  final String text;
  final Duration duration;
  TimedDialog({
    Key? key,
    this.text = 'This is a timed dialog',
    this.duration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  State<TimedDialog> createState() => _TimedDialogState();
}

class _TimedDialogState extends State<TimedDialog>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    animationController =
        AnimationController(vsync: this, duration: widget.duration);

    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);
        }
      });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    animationController.stop();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.15,
      height: height * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: white,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _LoadingPainter(animation.value)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  double v;

  _LoadingPainter(this.v);

  @override
  void paint(Canvas canvas, Size size) {
    double xCenter = 15;
    double yCenter = size.height - 15;

    Offset center = Offset(xCenter, yCenter);

    Rect rect = Rect.fromCircle(center: center, radius: 10);

    Paint paint = Paint()
      ..color = teal.add(black, 0.6).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawArc(rect, -pi / 2, pi * 2 * (1 - v), true, paint);
  }

  @override
  bool shouldRepaint(_LoadingPainter oldDelegate) => true;
}
