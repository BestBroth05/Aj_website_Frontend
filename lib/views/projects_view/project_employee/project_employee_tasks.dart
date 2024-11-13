import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/colors.dart';

class ProjectEmployeeTasks extends StatelessWidget {
  final Map<String, dynamic> project;
  final Map<String, dynamic>? task;
  final Function(Map<String, dynamic>? task) onSelect;
  const ProjectEmployeeTasks(
    this.project, {
    Key? key,
    this.task,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> standby = [];
    List<Map<String, dynamic>> active = [];
    List<Map<String, dynamic>> stopped = [];
    List<Map<String, dynamic>> completed = [];

    project['tasks'].values.forEach((_task) {
      if (_task['member_id'] == user!.id) {
        ProjectStatus status = ProjectStatus.values[_task['status']];

        switch (status) {
          case ProjectStatus.active:
            active.add(_task);
            break;
          case ProjectStatus.standby:
            standby.add(_task);
            break;
          case ProjectStatus.completed:
            completed.add(_task);
            break;
          case ProjectStatus.stopped:
            stopped.add(_task);
            break;
        }
      }
    });

    return Row(
      children: [
        Expanded(
          child: _TasksTableContainer(
            standby,
            title: ProjectStatus.standby.name,
            onSelect: onSelect,
            task: task,
          ),
        ),
        Expanded(
          child: _TasksTableContainer(
            active,
            title: ProjectStatus.active.name,
            onSelect: onSelect,
            task: task,
          ),
        ),
        Expanded(
          child: _TasksTableContainer(
            stopped,
            title: ProjectStatus.stopped.name,
            onSelect: onSelect,
            task: task,
          ),
        ),
        Expanded(
          child: _TasksTableContainer(
            completed,
            title: ProjectStatus.completed.name,
            onSelect: onSelect,
            task: task,
          ),
        ),
      ],
    );
  }
}

class _TasksTableContainer extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final String title;
  final Map<String, dynamic>? task;
  final Function(Map<String, dynamic>? task) onSelect;
  const _TasksTableContainer(
    this.tasks, {
    Key? key,
    this.task,
    this.title = '',
    required this.onSelect,
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
                      itemBuilder: (context, index) {
                        index = (tasks.length - 1) - index;
                        return InkWell(
                          onTap: () => onSelect(tasks[index]),
                          child: Container(
                            color: task == tasks[index]
                                ? blue.add(black, 0.2)
                                : index % 2 == 0
                                    ? backgroundColor
                                    : white,
                            child: _TaskTile(
                              tasks[index],
                              isSelected: task == tasks[index],
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                        );
                      },
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
  final bool isSelected;
  const _TaskTile(
    this.task, {
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<_TaskTile> createState() => __TaskTileState();
}

class __TaskTileState extends State<_TaskTile> {
  Map<String, dynamic> get task => widget.task;
  bool get isSelected => widget.isSelected;

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                            color: isSelected ? white : null,
                          ),
                        ),
                      ),
                      AutoSizeText(
                        'Estimated hours: ${task['estimated_hours']}',
                        style: TextStyle(
                          color: isSelected ? white : null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          WorkingAreas.values[task['area']].name.toTitle(),
                          style: TextStyle(
                            color: isSelected ? white : null,
                          ),
                        ),
                      ),
                      AutoSizeText(
                        'Real hours: ${task['real_hours']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? white : null,
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
              color: isSelected ? white : black,
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
                      style: TextStyle(
                        color: isSelected ? white : null,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
