import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/admin/projects/projects_database_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_project_dialog/admin_project_dialog.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/new_project/add_new_project.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_projects_grid/admin_projects_grid.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_projects_table/admin_projects_table.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/projects_top_bar.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';

class AdminProjectsView extends StatefulWidget {
  AdminProjectsView({Key? key}) : super(key: key);

  @override
  State<AdminProjectsView> createState() => _AdminProjectsViewState();
}

class _AdminProjectsViewState extends State<AdminProjectsView> {
  bool isGridLayout = false;

  Map<String, String?> filters = {};

  Map<int, Map<String, dynamic>> projects = {};

  int finished = 0;
  int inProgress = 0;
  int standby = 0;

  @override
  void initState() {
    super.initState();
    // projects = exampleProjects;

    Timer.run(() async => await getProjects());
  }

  Future<void> getProjects() async {
    openDialog(
      context,
      container: BasicTextDialog('Loading Projects'),
      block: true,
    );
    List<dynamic> p = await getProjectsFromDataBase() as List<dynamic>;

    p.forEach((element) {
      element['deadline'] = DateTime.parse(element['deadline']);
      element['initial_date'] = DateTime.parse(element['initial_date']);
      Map<int, List<int>> members = {};
      element['members'].forEach((member) {
        members[member[0]] = (member.sublist(1) as List).cast<int>();
        // membersPermissions[member[0]] = member[1];
      });
      element['members'] = members;
      // element['members_permissions'] = membersPermissions;
      projects[element['id']] = element;
    });

    // print(projects);
    for (Map<String, dynamic> project in projects.values) {
      switch (project['status']) {
        case 0:
          inProgress += 1;
          break;
        case 1:
          standby += 1;
          break;
        case 2:
          finished += 1;
          break;
      }
      int totalTasks = project['tasks'].length;
      int completed = 0;
      Map<int, Map<String, dynamic>> tasks = {};

      (project['tasks'] as List).forEach(
        (element) {
          if (element['status'] == 2) completed += 1;
          tasks[project['tasks'].indexOf(element)] = element;
        },
      );

      project['tasks'] = [];
      project['tasks'] = tasks;
      project['progress'] = totalTasks == 0 ? 0 : completed / totalTasks;
      project['completed_tasks'] = totalTasks == 0 ? 0 : completed;
      // print(project);
    }
    setState(() {});

    Navigator.pop(context);
    // openDialog(
    //   context,
    //   container: AdminProjectDialog(
    //     projects.values.last,
    //     addCommentFunct: (index, comment) {},
    //     editProject: (p) async {
    //       // print(await editProjectToDataBase(p));
    //     },
    //   ),
    //   shadowless: true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              DashboardTopBar(selected: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 5,
                        child: ProjectsTopBar(
                          isGridLayout: isGridLayout,
                          changeLayout: (value) => setState(
                            () => isGridLayout = value,
                          ),
                          addFilter: (key, value) => setState(
                            () => filters[key] = value == 'None' ? null : value,
                          ),
                          clearFilters: () => setState(() => filters.clear()),
                          finished: finished,
                          inProgress: inProgress,
                          standby: standby,
                          filters: filters,
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 5,
                          child: isGridLayout
                              ? AdminProjectsGrid(
                                  projects,
                                  addCommentFunct: (projectId, comment) =>
                                      addComment(
                                    projectId,
                                    comment,
                                  ),
                                )
                              : AdminProjectsTable(
                                  projects,
                                  editProject: (p) => editProject(p),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(), //<-- SEE HERE
                padding: EdgeInsets.all(20),
              ),
              onPressed: () async {
                List<User> users = await getAllUsersInDatabase();
                openDialog(
                  context,
                  container: AddNewProjectDialog(
                    users: users,
                    addProject: (project) async {
                      // exampleProjects[exampleProjects.length] = project;
                      // for (Map<String, dynamic> project
                      //     in exampleProjects.values) {
                      //   print(project);
                      // }

                      if (await addProjectToDataBase(project) == 200) {
                        Navigator.pop(context);
                        openDialog(
                          context,
                          container: TimedDialog(text: 'Project Added'),
                        );

                        await getProjects();
                      } else {
                        openDialog(
                          context,
                          container: TimedDialog(text: 'There was an error'),
                        );
                      }
                    },
                  ),
                  block: true,
                  shadowless: true,
                );
              },
              child: Container(
                height: 40,
                width: 40,
                child: Icon(Icons.add),
              ),
            ),
          ),
        )
      ],
    );
  }

  void editProject(project) async {
    int code = await editProjectToDataBase(project);

    if (code == 200) {
      await getProjects();
      Navigator.pop(context);
      openDialog(
        context,
        container: AdminProjectDialog(
          projects[project['id']]!,
          editProject: (p) => editProject(p),
        ),
      );
    } else {}
  }

  void addComment(int id, String comment) => setState(() {
        (projects[id]!['comments'] as List).add({
          'member': user!.id,
          'comment': comment,
          'dateTime': DateTime.now(),
        });
        // print('added comment $comment');
      });
}
