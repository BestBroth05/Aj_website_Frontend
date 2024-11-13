import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/projects_view/project_editor/project_editor_tasks.dart';
import 'package:guadalajarav2/views/projects_view/project_viewer/project_viewer_information.dart';

class ProjectEditorView extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<int, User> users;
  final int projectId;
  final Function(int, Map<int, Map<String, dynamic>> tasks) editTask;
  ProjectEditorView(
    this.project, {
    Key? key,
    required this.users,
    required this.projectId,
    required this.editTask,
  }) : super(key: key);

  @override
  State<ProjectEditorView> createState() => _ProjectEditorViewState();
}

class _ProjectEditorViewState extends State<ProjectEditorView> {
  Map<String, dynamic> project = {};

  @override
  void initState() {
    super.initState();
    project = widget.project;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.9,
      height: height * 0.9,
      color: white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: ProjectViewerInformation(
              project,
              addTasks: (tasks) => widget.editTask(widget.projectId, tasks),
              users: widget.users,
            ),
          ),
          Expanded(
            flex: 8,
            child: ProjectEditorTasks(
              project,
              users: widget.users,
              editTasks: (tasks) => widget.editTask(widget.projectId, tasks),
            ),
          ),
        ],
      ),
    );
  }
}
