import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/utils/admin/projects/projects_database_handler.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:guadalajarav2/views/projects_view/project_employee/project_employee_information.dart';
import 'package:guadalajarav2/views/projects_view/project_employee/project_employee_tab.dart';
import 'package:guadalajarav2/views/projects_view/project_employee/project_employee_tasks.dart';

class ProjectEmployee extends StatefulWidget {
  final Map<String, dynamic> project;
  final VoidCallback update;
  final Function(Map<String, dynamic> newTask) addTask;
  ProjectEmployee(
    this.project, {
    Key? key,
    required this.update,
    required this.addTask,
  }) : super(key: key);

  @override
  State<ProjectEmployee> createState() => _ProjectEmployeeState();
}

class _ProjectEmployeeState extends State<ProjectEmployee> {
  Map<String, dynamic>? _task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.975,
      height: height * 0.975,
      color: white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: ProjectEmployeeInformation(
              widget.project,
              addTask: widget.addTask,
            ),
          ),
          Expanded(
            flex: 7,
            child: ProjectEmployeeTasks(
              widget.project,
              task: _task,
              onSelect: (task) => setState(
                () => _task == task ? _task = null : _task = task,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ProjectEmployeeTab(
              _task,
              // onChanged: (key, value) => setState(
              //   () => _task![key] = value,
              // ),
              onChanged: editTasksInProject,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> editTasksInProject(String key, dynamic value) async {
    openDialog(
      context,
      container: BasicTextDialog('Loading'),
      block: true,
    );

    dynamic temp = _task![key];

    _task![key] = value;

    if (await editTasksInProjectInDataBase(
          {
            'id': widget.project['id'],
            'tasks': widget.project['tasks'].values.toList(),
          },
        ) ==
        200) {
      // Navigator.pop(context);
    } else {
      // Navigator.pop(context);
      openDialog(
        context,
        container: TimedDialog(
          text: 'Error when updating values',
        ),
      );

      _task![key] = temp;
    }

    setState(() {});
    widget.update.call();
  }
}
