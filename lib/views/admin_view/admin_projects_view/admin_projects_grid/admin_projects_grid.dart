import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_project_dialog/admin_project_dialog.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_projects_grid/admin_project_card.dart';

class AdminProjectsGrid extends StatefulWidget {
  final Map<int, Map<String, dynamic>> projects;
  final void Function(int projectId, String comment) addCommentFunct;
  AdminProjectsGrid(
    this.projects, {
    Key? key,
    required this.addCommentFunct,
  }) : super(key: key);

  @override
  State<AdminProjectsGrid> createState() => _AdminProjectsGridState();
}

class _AdminProjectsGridState extends State<AdminProjectsGrid> {
  List<Color> colors = [
    red,
    Colors.amber,
    green,
    teal,
    blue,
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 27.5,
          mainAxisSpacing: 27.5,
        ),
        itemCount: widget.projects.length,
        itemBuilder: (BuildContext context, int index) => AdminProjectCard(
          widget.projects.values.elementAt(index),
          addCommentFunct: widget.addCommentFunct,
          // color: colors[index % colors.length].withOpacity(0.2),
        ),
      ),
    );
  }
}
