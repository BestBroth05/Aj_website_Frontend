import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_project_dialog/admin_project_dialog.dart';

class AdminProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final Color? color;
  final void Function(int projectId, String comment) addCommentFunct;
  AdminProjectCard(
    this.project, {
    Key? key,
    this.color,
    required this.addCommentFunct,
  }) : super(key: key);

  @override
  State<AdminProjectCard> createState() => _AdminProjectCardState();
}

class _AdminProjectCardState extends State<AdminProjectCard> {
  Map<String, dynamic> get project => widget.project;

  DateTime get deadline => widget.project['deadline'] ?? DateTime.now();
  int get daysLeft => deadline.difference(DateTime.now()).inDays;
  Color get color => daysLeft > 100
      ? green.add(black, 0.2)
      : daysLeft < 61
          ? red
          : Colors.amber.add(black, 0.2);

  String get timeLeft => daysLeft > 61
      ? '${daysLeft ~/ 30} Months left'
      : daysLeft > 14
          ? '${daysLeft ~/ 7} Weeks left'
          : '$daysLeft Days left';
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openDialog(
        context,
        container: AdminProjectDialog(
          project,
          editProject: (p) {},
        ),
        shadowless: true,
      ),
      onHover: (value) => setState(() => isHover = value),
      child: Card(
        elevation: isHover ? 10 : 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Row(
                children: [
                  AutoSizeText(deadline.readableFormat.toTitle()),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      project['name'].toString(),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      project['company'] ?? 'company',
                    ),
                    _ProgressWidget(project['progress'] ?? 0),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    'members',
                    style: TextStyle(color: white),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: AutoSizeText(
                      timeLeft,
                      style: TextStyle(
                        color: color.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ProgressWidget extends StatelessWidget {
  final double value;
  const _ProgressWidget(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Progress',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                (value * 100).toInt().toString().padLeft(3, ' ') + '%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          CustomPaint(
            size: Size(width, 27.5),
            painter: _ProgressPainter(value),
          ),
        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double value;

  _ProgressPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    if (value == 0) {
      return;
    }
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    rect = rect.deflate(size.aspectRatio);
    Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [blue.add(black, 0.2), blue],
      ).createShader(rect)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = rect.height;
    Path path = Path()
      ..moveTo(rect.centerLeft.dx, rect.centerLeft.dy)
      ..lineTo(rect.centerRight.dx * value, rect.centerRight.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) => true;
}
