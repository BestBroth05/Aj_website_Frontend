import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_projects_table/admin_project_tile.dart';

class AdminProjectsTable extends StatefulWidget {
  final Map<int, Map<String, dynamic>> projects;
  final Function(Map<String, dynamic> project) editProject;

  AdminProjectsTable(
    this.projects, {
    Key? key,
    required this.editProject,
  }) : super(key: key);

  @override
  State<AdminProjectsTable> createState() => _AdminProjectsTableState();
}

class _AdminProjectsTableState extends State<AdminProjectsTable> {
  Map<String, int> headers = {
    'id': 1,
    'name': 3,
    'status': 2,
    'company': 3,
    'deadline': 2,
    'progress': 4,
    'tasks': 2,
    'members': 2,
  };

  @override
  void initState() {
    super.initState();
  }

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
              itemBuilder: (context, index) => AdminProjectTile(
                widget.projects.values.elementAt(index),
                attributesFlex: headers,
                isOdd: index % 2 != 0,
                editProject: widget.editProject,
              ),
              separatorBuilder: (context, index) => Container(height: 2),
              itemCount: widget.projects.length,
            ),
          ),
        )
      ],
    );
  }
}
