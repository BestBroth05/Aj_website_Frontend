import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/enums/projects/project_permissions.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_project_dialog/admin_project_dialog.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/projects_view/project_editor/project_editor_view.dart';
import 'package:guadalajarav2/views/projects_view/project_employee/project_employee.dart';
import 'package:guadalajarav2/views/projects_view/project_viewer/project_viewer.dart';

class ProjectsTable extends StatelessWidget {
  final Map<int, Map<String, dynamic>> projects;
  final VoidCallback update;
  final Function(int projectId, Map<String, dynamic> newTask) addTask;
  final Function(int projectId, Map<int, Map<String, dynamic>> tasks) editTasks;
  ProjectsTable(
    this.projects, {
    Key? key,
    required this.update,
    required this.addTask,
    required this.editTasks,
  }) : super(key: key);
  final Map<String, int> headers = {
    'id': 1,
    'name': 3,
    'status': 2,
    'company': 3,
    'deadline': 2,
    'progress': 4,
    'tasks': 2,
    'estimated_hours': 2,
    'real_hours': 2,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: teal.add(black, 0.3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
          child: Row(
            children: headers.entries
                .map(
                  (e) => Expanded(
                    flex: e.value,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          left: e.key != 'id'
                              ? BorderSide(
                                  color: white,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: AutoSizeText(
                        e.key.split('_').join(' ').toTitle(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: white),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
            ),
            child: ListView.separated(
              itemBuilder: (context, index) => _ProjectTile(
                projects.values.elementAt(index),
                attributesFlex: headers,
                isOdd: index % 2 != 0,
                editProject: (_) {},
                projectIndex: projects.keys.elementAt(index),
                editTasks: editTasks,
                update: update,
                addTask: (newTask) => addTask(
                  projects.keys.elementAt(index),
                  newTask,
                ),
              ),
              separatorBuilder: (context, index) => Container(height: 2),
              itemCount: projects.length,
            ),
          ),
        )
      ],
    );
  }
}

class _ProjectTile extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<String, int> attributesFlex;
  final int projectIndex;
  final Function(Map<String, dynamic> project) editProject;
  final Function(int, Map<int, Map<String, dynamic>> project) editTasks;
  final bool isOdd;
  final VoidCallback update;
  final Function(Map<String, dynamic> newTask) addTask;
  _ProjectTile(
    this.project, {
    Key? key,
    this.isOdd = true,
    required this.projectIndex,
    required this.update,
    required this.addTask,
    required this.editTasks,
    required this.editProject,
    required this.attributesFlex,
  }) : super(key: key);

  @override
  State<_ProjectTile> createState() => _AdminProjectTileState();
}

class _AdminProjectTileState extends State<_ProjectTile> {
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
      onTap: () async {
        Widget dialog = Container();

        ProjectPermission permission =
            ProjectPermission.values[widget.project['members'][user!.id][0]];

        switch (permission) {
          case ProjectPermission.admin:
            dialog = AdminProjectDialog(
              widget.project,
              editProject: (p) {},
            );
            // dialog = ProjectViewer(widget.project);
            break;
          case ProjectPermission.editor:
            openDialog(
              context,
              container: BasicTextDialog('Loading Project'),
              block: true,
            );
            List<User> usersList = await getAllUsersInDatabase();

            Map<int, User> usersMap = Map.fromIterable(
              usersList,
              key: (element) => element.id,
              value: (element) => element,
            );

            dialog = ProjectEditorView(
              widget.project,
              users: usersMap,
              projectId: widget.projectIndex,
              editTask: widget.editTasks,
            );
            Navigator.pop(context);
            break;
          case ProjectPermission.employee:
            dialog = ProjectEmployee(
              widget.project,
              update: widget.update,
              addTask: widget.addTask,
            );

            break;
          case ProjectPermission.viewer:
            openDialog(
              context,
              container: BasicTextDialog('Loading Project'),
              block: true,
            );
            List<User> usersList = await getAllUsersInDatabase();

            Map<int, User> usersMap = Map.fromIterable(
              usersList,
              key: (element) => element.id,
              value: (element) => element,
            );
            dialog = ProjectViewer(widget.project, users: usersMap);
            Navigator.pop(context);
            break;
        }

        openDialog(context, container: dialog);
      },
      child: Container(
        height: 70,
        color: statusColor,
        child: Row(
          children: widget.attributesFlex.entries.map(
            (e) {
              String key = e.key;
              int flex = e.value;
              dynamic value = widget.project[key];
              // print('${widget.project} $key $value');

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
