import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class LoadingDialog extends StatefulWidget {
  static int total = 100;
  static int value = 0;
  LoadingDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  double get percentage => LoadingDialog.value / LoadingDialog.total;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    LoadingDialog.value = 0;
    timer = Timer.periodic(
      Duration(milliseconds: 100),
      (timer) => setState(() {}),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.2,
      height: height * 0.15,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.0125,
        vertical: height * 0.0125,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AutoSizeText(
              'Loading Data...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AutoSizeText(
              '${LoadingDialog.value}/${LoadingDialog.total}',
            ),
          ),
          CustomPaint(
            size: Size(width, height * 0.025),
            painter: _LoadingBarPainter(percentage: percentage),
          )
        ],
      ),
    );
  }
}

class _LoadingBarPainter extends CustomPainter {
  double percentage;
  _LoadingBarPainter({required this.percentage});
  @override
  void paint(Canvas canvas, Size size) {
    percentage = percentage.clamp(0, 1);
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()
      ..color = blue
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(colors: [blue, green]).createShader(rect);

    Path path = Path()
      ..moveTo(rect.centerLeft.dx, rect.centerLeft.dy)
      ..lineTo(rect.centerRight.dx * percentage, rect.centerRight.dy);

    // canvas.drawRect(rect, paint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LoadingBarPainter oldDelegate) => true;
}
