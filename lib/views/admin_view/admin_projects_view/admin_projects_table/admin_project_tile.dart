import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_project_dialog/admin_project_dialog.dart';

class AdminProjectTile extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<String, int> attributesFlex;
  final Function(Map<String, dynamic> project) editProject;
  final bool isOdd;
  AdminProjectTile(
    this.project, {
    Key? key,
    this.isOdd = true,
    required this.editProject,
    required this.attributesFlex,
  }) : super(key: key);

  @override
  State<AdminProjectTile> createState() => _AdminProjectTileState();
}

class _AdminProjectTileState extends State<AdminProjectTile> {
  ProjectStatus get status => ProjectStatus.values[widget.project['status']];
  Color get color => widget.isOdd ? backgroundColor : white;
  Color get statusColor {
    Color? extra;

    switch (status) {
      case ProjectStatus.active:
        break;
      case ProjectStatus.standby:
        extra = darkAmber;
        break;
      case ProjectStatus.completed:
        extra = green;
        break;
      case ProjectStatus.stopped:
        extra = red;
        break;
    }

    return extra != null ? color.add(extra, 0.2) : color;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openDialog(
        context,
        container: AdminProjectDialog(
          widget.project,
          editProject: widget.editProject,
        ),
        shadowless: true,
      ),
      child: Container(
        height: 70,
        color: statusColor,
        child: Row(
          children: widget.attributesFlex.entries.map(
            (e) {
              String key = e.key;
              int flex = e.value;
              dynamic value = widget.project[key];

              switch (key) {
                case 'status':
                  value = status.name.toTitle();
                  break;

                case 'tasks':
                  value =
                      '${widget.project["completed_tasks"]} / ${value.length}';
                  break;
                case 'deadline':
                  value = (value as DateTime).readableFormat.toTitle();
                  break;
                case 'members':
                  value = (value as Map).length;
                  break;
                default:
                  break;
              }

              return Expanded(
                flex: flex,
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      left: key != 'id'
                          ? BorderSide(
                              color: gray,
                            )
                          : BorderSide.none,
                    ),
                  ),
                  child: key == 'progress'
                      ? _ProgressWidget(value)
                      : AutoSizeText(
                          value.toString(),
                          textAlign: TextAlign.center,
                        ),
                ),
              );
            },
          ).toList(),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomPaint(
              size: Size(width, 40),
              painter: _ProgressPainter(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: AutoSizeText(
              (value * 100).toInt().toString().padLeft(3, ' ') + '%',
              textAlign: TextAlign.center,
            ),
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
        colors: [green.add(black, 0.3), green],
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
