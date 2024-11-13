import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/projects_view/project_viewer/project_viewer_information.dart';
import 'package:guadalajarav2/views/projects_view/project_viewer/project_viewer_tasks.dart';

class ProjectViewer extends StatelessWidget {
  final Map<String, dynamic> project;
  final Map<int, User> users;
  const ProjectViewer(
    this.project, {
    Key? key,
    required this.users,
  }) : super(key: key);

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
              users: users,
            ),
          ),
          Expanded(
            flex: 8,
            child: ProjectViewerTasks(
              project,
              users: users,
            ),
          ),
        ],
      ),
    );
  }
}
