import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_project_dialog/admin_project_task_details.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_project_dialog/admin_project_tasks.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/new_project/add_new_project.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AdminProjectDialog extends StatefulWidget {
  final Map<String, dynamic> project;
  final Function(Map<String, dynamic> project) editProject;
  AdminProjectDialog(
    this.project, {
    Key? key,
    required this.editProject,
  }) : super(key: key);

  @override
  State<AdminProjectDialog> createState() => _AdminProjectDialogState();
}

class _AdminProjectDialogState extends State<AdminProjectDialog> {
  Map<String, dynamic> project = {};
  Map<int, User> users = {};
  Map<int, User> usersInProject = {};
  int? selected;
  Map<String, dynamic> tempTask = {
    'user': null,
    'area': 0,
    'hours': 0,
    'status': 0,
  };

  @override
  void initState() {
    super.initState();
    project = widget.project;
    Timer.run(() async {
      openDialog(
        context,
        container: BasicTextDialog('Loading...'),
        block: true,
      );
      users = Map.fromIterable(
        await getAllUsersInDatabase(),
        key: (element) => element.id,
        value: (element) => element,
      );
      Navigator.pop(context);
      setState(() {
        usersInProject = Map.fromIterable(
          users.values.where(
            (element) => project['members'].keys.contains(
                  element.id,
                ),
          ),
          key: (element) => element.id,
          value: (element) => element,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Container(
        width: width * 0.95,
        height: height * 0.95,
        color: white,
      );
    }
    return Card(
      child: Container(
        width: width * 0.95,
        height: height * 0.95,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: _AdminProjectDialogView(
                project,
                users: users,
                editProject: widget.editProject,
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                      child: AdminProjectTasks(
                        project['tasks'],
                        users: usersInProject,
                        selected: selected,
                        onSelect: (index) => setState(() => changeTask(index)),
                      ),
                    ),
                    SizedBox(width: width * 0.0125),
                    Expanded(
                      flex: 3,
                      child: AdminProjectTaskDetails(
                        selected != null ? project['tasks'][selected] : null,
                        temp: tempTask,
                        users: usersInProject,
                        onChanged: (key, value) => setState(
                          () => tempTask[key] = value,
                        ),
                        onEdit: () => setState(() {
                          project['tasks'][selected].forEach(
                            (k, v) => tempTask.putIfAbsent(
                              k,
                              () => v,
                            ),
                          );

                          List<List<int>> members = [];

                          project['members'].forEach((key, value) {
                            List<int> v = [key, value[0]];
                            v.addAll(value.sublist(1));
                            members.add(v);
                          });

                          Map<String, dynamic> _project = {
                            'name': project['name'],
                            'codename': project['codename'],
                            'description': project['description'],
                            'company': project['company'],
                            'status': project['status'],
                            // 'progress': 0,
                            'comments': project['comments'].toString(),
                            'tasks': project['tasks'].values.toList(),
                          };
                          _project['tasks'][selected] = tempTask;
                          _project['members'] = members.toString();
                          _project['deadline'] =
                              project['deadline'].toIso8601String();
                          _project['initial_date'] =
                              project['initial_date'].toIso8601String();
                          _project['id'] = project['id'];

                          widget.editProject(_project);
                        }),
                      ),
                    ),
                    // AdminProjectCommentsSection(
                    //   project,
                    //   users: users,
                    //   addCommentFunct: widget.addCommentFunct,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeTask(int index) {
    if (index == selected) {
      selected = null;
    } else {
      selected = index;
      Map<String, dynamic> task = project['tasks'][selected];
      tempTask['user'] = usersInProject[task['member_id']];
      tempTask['area'] = task['area'];
      tempTask['status'] = task['status'];
      tempTask['hours'] = task['real_hours'];
    }
  }
}

class _AdminProjectDialogView extends StatelessWidget {
  final Map<String, dynamic> project;
  final Map<int, User> users;
  final Function(Map<String, dynamic> project) editProject;
  // final Map<int, List<int>> members;
  _AdminProjectDialogView(
    this.project, {
    Key? key,
    required this.editProject,
    required this.users,
    // required this.members,
  }) : super(key: key);

  String get progressString => (project['progress'] * 100).toInt().toString();
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        width: width,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      AutoSizeText(
                        project['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AutoSizeText('-'),
                      ),
                      AutoSizeText(
                        timeLeft,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        project['description'],
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AutoSizeText('Progress: $progressString%'),
                        CustomPaint(
                          size: Size(width, height * 0.05),
                          painter: _ProgressPainter(project['progress']),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Edit',
                    color: blue,
                    onPressed: () => openDialog(
                      context,
                      container: AddNewProjectDialog(
                        users: users.values.toList(),
                        addProject: editProject,
                        project: project,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double value;

  _ProgressPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    Paint paint = Paint()
      ..shader = LinearGradient(colors: [blue, green]).createShader(rect);
    Paint background = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // canvas.drawArc(rect, 0, pi * 2, false, background);
    // canvas.drawArc(rect, -pi / 2, pi * 2 * value, false, paint);

    canvas.drawRect(rect, background);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * value, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) => true;
}
