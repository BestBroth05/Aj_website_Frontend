import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/admin/projects/projects_database_handler.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/projects/projects_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:guadalajarav2/views/projects_view/project_editor/project_editor_view.dart';
import 'package:guadalajarav2/views/projects_view/project_employee/project_employee.dart';
import 'package:guadalajarav2/views/projects_view/projects_table.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectsView extends StatefulWidget {
  ProjectsView({Key? key}) : super(key: key);

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  Map<int, Map<String, dynamic>> projects = {};
  Map<String, String?> filters = {};

  int inProgress = 0;
  int standby = 0;
  int completed = 0;

  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      try {
        openDialog(context, container: BasicTextDialog('Loading'), block: true);

        user = await getUserFromToken();
        while (user == null) {
          user = await getUserFromToken();
          if (token == null) {
            openLink(context, AJRoute.login.url, isRoute: true);
          }
          await Future.delayed(Duration(seconds: 1));
        }
        await updateProjects();
      } catch (e) {
        openDialog(context,
            container: BasicTextDialog('Error\nLogging out'), block: true);
        await Future.delayed(Duration(seconds: 3));
        logout();
      }

      // print(user);
    });
  }

  void logout() async {
    removeTokenFromDatabase(context, token!);
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('token')) {
      _preferences.remove('token');
    }
    token = null;
    user = null;
    print('[WEBSITE] Logged out');
    openLink(context, AJRoute.home.url, isRoute: true);
  }

  Future<void> updateProjects() async {
    List<dynamic> _projects = await getProjectsFromUser(user!.projectsId);

    _projects.forEach((element) {
      Map<int, List<int>> members = {};
      element['members'].forEach((member) {
        members[member[0]] = (member.sublist(1) as List).cast<int>();
        // membersPermissions[member[0]] = member[1];
      });
      element['members'] = members;
      // element['members_permissions'] = membersPermissions;
      int totalTasks = element['tasks'].length;
      int _completed = 0;
      Map<int, Map<String, dynamic>> tasks = {};
      element['estimated_hours'] = 0;
      element['real_hours'] = 0;

      (element['tasks'] as List).forEach(
        (e) {
          if (e['status'] == 2) _completed += 1;
          tasks[element['tasks'].indexOf(e)] = e;
          element['estimated_hours'] += e['estimated_hours'] ?? 0;
          element['real_hours'] += e['real_hours'] ?? 0;
        },
      );

      element['tasks'] = [];
      element['tasks'] = tasks;
      element['progress'] = totalTasks == 0 ? 0 : _completed / totalTasks;
      element['completed_tasks'] = totalTasks == 0 ? 0 : _completed;
      projects[element['id']] = element;

      switch (element['status']) {
        case 0:
          inProgress += 1;
          break;
        case 1:
          standby += 1;
          break;
        case 2:
          completed += 1;
          break;
      }

      List<String> dates = ['deadline', 'initial_date'];

      dates.forEach((key) {
        projects[element['id']]![key] = DateTime.parse(element[key]);
      });

      projects[element['id']]!['comments'] = jsonDecode(element['comments']);
    });
    setState(() {});

    // print(projects);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: Column(
        children: [
          DashboardTopBar(selected: 3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: _TopProjectsBar(
                      filters: filters,
                      addFilter: (key, value) => setState(
                        () => filters[key] = value == 'None' ? null : value,
                      ),
                      clearFilters: () => setState(() => filters.clear()),
                      finished: completed,
                      inProgress: inProgress,
                      standby: standby,
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: ProjectsTable(
                        projects,
                        update: () => updateProjects(),
                        addTask: addTasksInProject,
                        editTasks: editTasksInProject,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addTasksInProject(int index, Map<String, dynamic> task) async {
    openDialog(
      context,
      container: BasicTextDialog('Loading'),
      block: true,
    );
    projects[index]!['tasks'].putIfAbsent(
      projects[index]!['tasks'].length,
      () => task,
    );
    if (await editTasksInProjectInDataBase(
          {
            'id': index,
            'tasks': projects[index]!['tasks'].values.toList(),
          },
        ) ==
        200) {
      Navigator.pop(context);
      Navigator.pop(context);
      await updateProjects();
      openDialog(
        context,
        container: BasicTextDialog('Updating'),
        block: true,
      );

      await Future.delayed(Duration(seconds: 2));

      Navigator.pop(context);

      openDialog(
        context,
        container: ProjectEmployee(
          projects[index]!,
          update: updateProjects,
          addTask: (newTask) async => await addTasksInProject(index, newTask),
        ),
      );
    } else {
      // Navigator.pop(context);
      openDialog(
        context,
        container: TimedDialog(
          text: 'Error when adding Task',
        ),
      );

      (projects[index]!['tasks'] as Map)
          .remove(projects[index]!['tasks'].length - 1);
    }

    setState(() {});
  }

  Future<void> editTasksInProject(
      int index, Map<int, Map<String, dynamic>> tasks) async {
    openDialog(
      context,
      container: BasicTextDialog('Loading'),
      block: true,
    );
    projects[index]!['tasks'] = tasks;
    if (await editTasksInProjectInDataBase(
          {
            'id': index,
            'tasks': projects[index]!['tasks'].values.toList(),
          },
        ) ==
        200) {
      Navigator.pop(context);
      Navigator.pop(context);
      await updateProjects();
      openDialog(
        context,
        container: BasicTextDialog('Updating'),
        block: true,
      );

      await Future.delayed(Duration(seconds: 2));
      List<User> usersList = await getAllUsersInDatabase();

      Map<int, User> usersMap = Map.fromIterable(
        usersList,
        key: (element) => element.id,
        value: (element) => element,
      );
      Navigator.pop(context);

      openDialog(
        context,
        container: ProjectEditorView(
          projects[index]!,
          users: usersMap,
          projectId: index,
          editTask: editTasksInProject,
        ),
      );
    } else {
      // Navigator.pop(context);
      openDialog(
        context,
        container: TimedDialog(
          text: 'Error when adding Task',
        ),
      );

      (projects[index]!['tasks'] as Map)
          .remove(projects[index]!['tasks'].length - 1);
    }

    setState(() {});
  }
}

class _TopProjectsBar extends StatelessWidget {
  final int inProgress;
  final int standby;
  final int finished;
  final Map<String, String?> filters;
  final Function(String filter, String? value) addFilter;
  final VoidCallback clearFilters;
  _TopProjectsBar({
    Key? key,
    required this.clearFilters,
    required this.addFilter,
    required this.inProgress,
    required this.standby,
    required this.finished,
    required this.filters,
  }) : super(key: key);
  final Map<String, Map<String, dynamic>> filterItems = {
    'company': {
      'items': ['ibiosense', 'dmi'],
      'icon': Icons.location_city,
    },
    'status': {
      'items': ['In Progress', 'Standby', 'Completed'],
      'icon': Icons.analytics_outlined,
    },
    'area': {
      'items': [
        'Hardware',
        'Software',
        'Firmware',
        'Manufacture',
        'Industrial'
      ],
      'icon': Icons.amp_stories_sharp,
    },
    'year': {
      'items': ['2022', '2021', '2020'],
      'icon': Icons.calendar_today
    },
    'month': {
      'items': [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
      'icon': Icons.calendar_month_outlined,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.005),
      height: 75,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: teal.add(black, 0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: filterItems.entries
                      .map(
                        (e) => SizedBox(
                          width: width * 0.1,
                          height: 50,
                          child: _FilterDropdown(
                            filters[e.key],
                            items: e.value['items'],
                            icon: e.value['icon'],
                            hint: e.key.toTitle(),
                            onChanged: (value) => addFilter(e.key, value),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                      width: width * 0.06,
                      text: 'Apply filters',
                      color: white,
                      textColor: black,
                      height: 42.5,
                      onPressed: () {},
                    ),
                    SizedBox(width: width * 0.025),
                    CustomButton(
                      text: 'Clear filters',
                      width: width * 0.06,
                      // color: red.add(white, 0.5),
                      height: 42.5,
                      onPressed: clearFilters,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _NumberText(amount: inProgress, text: 'in progress'),
              _NumberText(amount: standby, text: 'standby'),
              _NumberText(amount: finished, text: 'completed'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final Function(String? value) onChanged;
  final IconData icon;
  _FilterDropdown(
    this.value, {
    Key? key,
    required this.icon,
    required this.onChanged,
    required this.items,
    required this.hint,
  }) : super(key: key);

  @override
  State<_FilterDropdown> createState() => __FilterDropdownState();
}

class __FilterDropdownState extends State<_FilterDropdown> {
  List<String> items = ['None'];

  @override
  void initState() {
    super.initState();
    items.addAll(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String?>(
          isExpanded: true,
          underline: SizedBox(),
          borderRadius: BorderRadius.circular(5),
          hint: Row(
            children: [
              Icon(widget.icon, color: gray.add(black, 0.2)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.01),
                  child: AutoSizeText(widget.hint, minFontSize: 1, maxLines: 1),
                ),
              ),
            ],
          ),
          icon: SizedBox(),
          selectedItemBuilder: (context) => items
              .map(
                (e) => Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: gray.add(black, 0.2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.01),
                      child: AutoSizeText(e, minFontSize: 1, maxLines: 1),
                    ),
                  ],
                ),
              )
              .toList(),
          items: items
              .map(
                (e) => DropdownMenuItem<String?>(
                  child: AutoSizeText(e, minFontSize: 1, maxLines: 1),
                  value: e,
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          value: widget.value,
        ),
      ),
    );
  }
}

class _NumberText extends StatelessWidget {
  final int amount;
  final String text;
  const _NumberText({
    Key? key,
    required this.amount,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              '$amount',
              style: TextStyle(fontSize: 20, color: white),
            ),
            AutoSizeText(
              text.toTitle(),
              style: TextStyle(fontSize: 10, color: gray.add(black, 0.0)),
            ),
          ],
        ),
      ),
    );
  }
}
