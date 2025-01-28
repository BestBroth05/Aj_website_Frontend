import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/projects_view/project_editor/project_editor_edit_task.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class ProjectViewerInformation extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<int, User> users;
  final Function(Map<int, Map<String, dynamic>> tasks)? addTasks;
  ProjectViewerInformation(
    this.project, {
    Key? key,
    required this.users,
    this.addTasks,
  }) : super(key: key);

  @override
  State<ProjectViewerInformation> createState() =>
      _ProjectViewerInformationState();
}

class _ProjectViewerInformationState extends State<ProjectViewerInformation>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> get project => widget.project;

  double get progress => project['progress'] ?? 0;

  int get daysLeft => project['deadline'].difference(DateTime.now()).inDays;
  Color get color => daysLeft > 100
      ? green.add(black, 0.2)
      : daysLeft < 61
          ? red
          : Colors.amber.add(black, 0.2);

  String get timeLeft => daysLeft > 61
      ? '${daysLeft ~/ 30} Months left'
      : daysLeft > 14
          ? '${daysLeft ~/ 7} Weeks left'
          : daysLeft >= 0
              ? '$daysLeft Days left'
              : '${-daysLeft} Days Overtime';

  late Animation<double> animation;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    Timer(Duration(milliseconds: 100), () {
      if (animationController != null) {
        animationController!.forward();
      }
    });

    animation = Tween<double>(begin: 0, end: progress).animate(
      animationController!,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (animationController != null) {
      animationController!.dispose();
      animationController = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(width * 0.005),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  project['name'] + ' - ' + project['company'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                widget.addTasks != null
                    ? CustomButton(
                        text: 'Add New Task',
                        onPressed: () {
                          Map<int, User> usersInProject = {};
                          (project['members'] as Map).forEach((key, value) {
                            usersInProject[key] = widget.users[key]!;
                          });
                          openDialog(
                            context,
                            container: ProjectEditorEditTask(
                              null,
                              editTask: editTask,
                              usersData: project['members'],
                              users: usersInProject,
                              initUser: usersInProject.values.elementAt(0),
                            ),
                          );
                        },
                        color: blue,
                      )
                    : Container(),
              ],
            ),
            Expanded(
              child: AutoSizeText(
                project['description'],
                style: TextStyle(fontSize: 15),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                '${(progress * 100).toStringAsFixed(2)}%',
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AutoSizeText(timeLeft),
            ),
            CustomPaint(
              size: Size(width, height * 0.03),
              painter: _ProgressPainter(animation.value),
            ),
          ],
        ),
      ),
    );
  }

  void editTask(Map<String, dynamic> task) {
    int index = project['tasks'].length;
    project['tasks'][index] = task;

    Map<int, Map<String, dynamic>> _tasks = {};

    project['tasks'].forEach((key, value) {
      if (key == index) {
        _tasks[index] = task;
      } else {
        _tasks[key] = value;
      }
    });

    widget.addTasks!(_tasks);
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
    Rect rect = Rect.fromLTWH(
      size.height / 2,
      0,
      size.width - size.height / 2,
      size.height,
    );
    Paint paint = Paint()
      ..shader = LinearGradient(colors: [blue, green]).createShader(rect);

    Rect colored = Rect.fromPoints(
      rect.topLeft,
      Offset(rect.width * value, size.height),
    );

    canvas.drawRect(colored, paint);
    canvas.drawCircle(colored.centerLeft, colored.height / 2, paint);
    canvas.drawCircle(colored.centerRight, colored.height / 2, paint);
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) => true;
}
