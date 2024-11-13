import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';

class ProjectViewerTasks extends StatelessWidget {
  final Map<String, dynamic> project;
  final Map<int, User> users;
  const ProjectViewerTasks(
    this.project, {
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> standby = [];
    List<Map<String, dynamic>> active = [];
    List<Map<String, dynamic>> stopped = [];
    List<Map<String, dynamic>> completed = [];

    project['tasks'].values.forEach((task) {
      ProjectStatus status = ProjectStatus.values[task['status']];

      switch (status) {
        case ProjectStatus.active:
          active.add(task);
          break;
        case ProjectStatus.standby:
          standby.add(task);
          break;
        case ProjectStatus.completed:
          completed.add(task);
          break;
        case ProjectStatus.stopped:
          stopped.add(task);
          break;
      }
    });

    return Row(
      children: [
        Expanded(
          child: _TasksTableContainer(
            standby,
            title: ProjectStatus.standby.name,
            users: users,
            userData: project['members'],
          ),
        ),
        Expanded(
          child: _TasksTableContainer(
            active,
            title: ProjectStatus.active.name,
            users: users,
            userData: project['members'],
          ),
        ),
        Expanded(
          child: _TasksTableContainer(
            stopped,
            title: ProjectStatus.stopped.name,
            users: users,
            userData: project['members'],
          ),
        ),
        Expanded(
          child: _TasksTableContainer(
            completed,
            title: ProjectStatus.completed.name,
            users: users,
            userData: project['members'],
          ),
        ),
      ],
    );
  }
}

class _TasksTableContainer extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final String title;
  final Map<int, User> users;
  final Map<int, List<int>> userData;
  const _TasksTableContainer(
    this.tasks, {
    Key? key,
    this.title = '',
    required this.users,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AutoSizeText(
                title.toTitle(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: tasks.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) => Container(
                        color: index % 2 == 0 ? backgroundColor : white,
                        child: _TaskTile(
                          tasks[index],
                          users: users,
                          userData: userData,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                      itemCount: tasks.length,
                    )
                  : Container(
                      color: backgroundColor,
                      child: Center(
                        child: AutoSizeText('No Tasks'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatefulWidget {
  final Map<String, dynamic> task;
  final Map<int, User> users;
  final Map<int, List<int>> userData;
  const _TaskTile(
    this.task, {
    Key? key,
    required this.users,
    required this.userData,
  }) : super(key: key);
  @override
  State<_TaskTile> createState() => __TaskTileState();
}

class __TaskTileState extends State<_TaskTile> {
  Map<String, dynamic> get task => widget.task;

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    User _user = widget.users[task["member_id"]]!;
    WorkingAreas _area = WorkingAreas.values[task['area']];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          task['name'].toString().toTitle(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AutoSizeText(
                        'Estimated hours: ${task['estimated_hours']}',
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          '${_user.fullName} - ${_area.name.toTitle()}',
                        ),
                      ),
                      AutoSizeText(
                        'Real hours: ${task['real_hours']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => setState(() => isExpanded = !isExpanded),
              icon: Icon(
                isExpanded
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
              ),
              splashRadius: 2,
            ),
          ],
        ),
        isExpanded
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      task['notes'].toString(),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
