import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AdminProjectTasks extends StatefulWidget {
  final Map<int, Map<String, dynamic>> tasks;
  final Map<int, User> users;
  final int? selected;
  final Function(int selected) onSelect;
  AdminProjectTasks(
    this.tasks, {
    Key? key,
    this.selected,
    required this.users,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<AdminProjectTasks> createState() => _AdminProjectTasksState();
}

class _AdminProjectTasksState extends State<AdminProjectTasks> {
  Map<int, Map<String, dynamic>> get tasks => widget.tasks;
  Map<String, int> headers = {
    'name': 3,
    'estimated_hours': 2,
    'real_hours': 2,
    'status': 2,
    'area': 2,
    'member_id': 2,
  };

  @override
  Widget build(BuildContext context) {
    // print(widget.users);
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Tasks',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: teal.add(black, 0.3),
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: headers.entries.map((e) {
                        String key = e.key.split('_').join(' ').toTitle();
                        int flex = e.value;

                        if (e.key == 'member_id') {
                          key = 'Member';
                        }

                        return Expanded(
                          flex: flex,
                          child: Container(
                            decoration: BoxDecoration(
                              border: e.key != headers.keys.last
                                  ? Border(right: BorderSide(color: gray))
                                  : null,
                            ),
                            child: Center(
                              child: AutoSizeText(
                                key,
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Container(
                        color: index == widget.selected
                            ? teal
                            : index % 2 == 0
                                ? white
                                : backgroundColor,
                        child: _TaskTile(
                          tasks.values.elementAt(index),
                          selected: index == widget.selected,
                          onTouch: () => widget.onSelect(index),
                          headers: headers,
                          user: widget.users[
                              tasks.values.elementAt(index)['member_id']]!,
                        ),
                      ),
                      itemCount: tasks.length,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Add Task',
                  onPressed: () => print('project'),
                  // onPressed: () => openDialog(
                  //   context,
                  //   container: AddTaskContainer(
                  //     tasks.values.toList(),
                  //     usersInProject: usersInProject,
                  //     users: users,
                  //     onValidated: onValidated,
                  //     onDelete: onDelete,
                  //   ),
                  // ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatefulWidget {
  final Map<String, dynamic> task;
  final Map<String, int> headers;
  final VoidCallback onTouch;
  final User user;
  final bool selected;
  _TaskTile(
    this.task, {
    Key? key,
    this.selected = false,
    required this.headers,
    required this.onTouch,
    required this.user,
  }) : super(key: key);

  @override
  State<_TaskTile> createState() => __TaskTileState();
}

class __TaskTileState extends State<_TaskTile> {
  Map<String, dynamic> get task => widget.task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTouch,
      child: Container(
        height: 75,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.headers.entries.map(
            (e) {
              String key = e.key;
              int flex = e.value;

              dynamic value = task[key];

              switch (key) {
                case 'status':
                  value = ProjectStatus.values[value].name.toTitle();
                  break;

                case 'area':
                  value = WorkingAreas.values[value].name.toTitle();
                  break;
                case 'member_id':
                  value = widget.user.fullName;
                  break;
              }

              return Expanded(
                flex: flex,
                child: Container(
                  decoration: BoxDecoration(
                    border: key != widget.headers.keys.last
                        ? Border(right: BorderSide(color: gray))
                        : null,
                  ),
                  child: Center(
                    child: AutoSizeText(
                      value.toString(),
                      style: TextStyle(color: widget.selected ? white : null),
                    ),
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
