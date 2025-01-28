import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/projects/project_permissions.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/utils/dates_utils.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/new_project/add_tasks_container.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/new_project/members_container.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AddNewProjectDialog extends StatefulWidget {
  final Map<String, dynamic>? project;
  final List<User> users;
  final Function(Map<String, dynamic> project) addProject;
  AddNewProjectDialog({
    Key? key,
    required this.users,
    required this.addProject,
    this.project,
  }) : super(key: key);

  @override
  State<AddNewProjectDialog> createState() => _AddNewProjectDialogState();
}

class _AddNewProjectDialogState extends State<AddNewProjectDialog> {
  Map<int, List<int>> users = {};

  List<Map<String, dynamic>> tasks = [];

  bool get editing => widget.project != null;

  @override
  void initState() {
    super.initState();
    if (editing) {
      widget.project!['members'].forEach((key, value) {
        users[key] = [];
        users[key]!.addAll(value);
      });
      tasks = widget.project!['tasks'].values.toList();
      // print();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: height * 0.975,
            width: width * 0.3,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  editing ? 'Editing Project' : 'New Project',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Divider(thickness: 2),
                Expanded(
                  child: _NewProjectForm(
                    tasks: tasks,
                    users: users,
                    addProject: widget.addProject,
                    project: widget.project,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: width * 0.025),
          AddMembersContainer(
            Map.fromIterable(
              widget.users,
              key: (element) => element.id,
              value: (element) => element,
            ),
            onAddedMember: (user, area, ProjectPermission permission) =>
                setState(() {
              if (users.containsKey(user.id)) {
                if (area != null) {
                  users[user.id]!.add(area.id);
                }

                users[user.id]![0] = permission.id;
              } else {
                users[user.id] = [permission.id];
                if (area != null) {
                  users[user.id]!.add(area.id);
                }
              }
            }),
            onDeleteArea: (userId, areaId) => setState(() {
              users[userId]!.remove(areaId);
              if (users[userId]!.length == 1) {
                users.remove(userId);
              }
            }),
            membersInProject: users,
          ),
          SizedBox(width: width * 0.025),
          AddTaskContainer(
            tasks,
            usersInProject: users,
            users: Map.fromIterable(
              widget.users,
              key: (element) => element.id,
              value: (element) => element,
            ),
            onDelete: (index) => setState(() => tasks.removeAt(index)),
            onValidated: (task) => setState(() {
              tasks.add(task);
            }),
          ),
        ],
      ),
    );
  }
}

class _NewProjectForm extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final Map<int, List<int>> users;
  final Map<String, dynamic>? project;
  final Function(Map<String, dynamic> project) addProject;
  _NewProjectForm({
    Key? key,
    this.project,
    required this.tasks,
    required this.users,
    required this.addProject,
  }) : super(key: key);

  @override
  State<_NewProjectForm> createState() => __NewProjectFormState();
}

class __NewProjectFormState extends State<_NewProjectForm> {
  DateTime deadline = DateTime.now().add(Duration(days: 1));

  String get estimatedHours {
    int hours = 0;
    widget.tasks.forEach((task) {
      hours += (task['estimated_hours']! as int);
    });

    return '$hours';
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController codenameController = TextEditingController();

  bool get editing => widget.project != null;
  Map<String, dynamic>? get project => widget.project;

  @override
  void initState() {
    super.initState();
    if (editing) {
      nameController.text = project!['name'];
      companyController.text = project!['company'];
      descriptionController.text = project!['description'];
      codenameController.text = project!['codename'];
      deadline = project!['deadline'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          Expanded(
            child: Column(
              children: [
                _CustomFormTextField(
                  title: 'Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a name';
                    } else {
                      return null;
                    }
                  },
                ),
                _CustomFormTextField(
                  title: 'Company',
                  controller: companyController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a company\'s name';
                    } else {
                      return null;
                    }
                  },
                ),
                _CustomFormTextField(
                  title: 'Description',
                  lines: 3,
                  controller: descriptionController,
                ),
                _CustomFormTextField(
                  title: 'Codename',
                  controller: codenameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a codename';
                    } else {
                      return null;
                    }
                  },
                ),
                _CustomFormText(title: 'Estimated Hours', text: estimatedHours),
                _CustomDateSelector(
                  date: deadline,
                  onDateChanged: (date) => setState(() => deadline = date),
                ),
              ],
            ),
          ),
          Divider(thickness: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                text: 'Cancel',
                color: gray,
                onPressed: () => Navigator.pop(context),
              ),
              CustomButton(
                text: editing ? 'Edit' : 'Create',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    List<List<int>> members = [];

                    widget.users.forEach((key, value) {
                      List<int> v = [key, value[0]];
                      v.addAll(value.sublist(1));
                      members.add(v);
                    });

                    Map<String, dynamic> project = {
                      'name': nameController.text,
                      'codename': codenameController.text,
                      'description': descriptionController.text,
                      'company': companyController.text,
                      'members': members.toString(),
                      'deadline': deadline.toIso8601String(),
                      'initial_date': DateTime.now().toIso8601String(),
                      'status': 0,
                      'tasks': widget.tasks,
                      // 'progress': 0,
                      'comments': [].toString(),
                    };

                    if (editing) {
                      project['id'] = widget.project!['id'];
                    }

                    widget.addProject.call(project);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomDateSelector extends StatefulWidget {
  final Function(DateTime date) onDateChanged;
  final DateTime date;
  _CustomDateSelector({
    Key? key,
    required this.date,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  State<_CustomDateSelector> createState() => __CustomDateSelectorState();
}

class __CustomDateSelectorState extends State<_CustomDateSelector> {
  DateTime get date => widget.date;

  @override
  Widget build(BuildContext context) {
    // print(months);
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText('Deadline Date'),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                _CustomDropDown<int>(
                  title: 'Day',
                  onChanged: (day) => changeDate(day: day),
                  value: date.day,
                  items: List.generate(
                    date.month == 2 && date.year % 4 == 0
                        ? daysInMonth[date.month - 1] + 1
                        : daysInMonth[date.month - 1],
                    (index) => index + 1,
                  ),
                ),
                _CustomDropDown<int>(
                  title: 'Month',
                  onChanged: (month) => changeDate(month: month! + 1),
                  value: date.month - 1,
                  items: List.generate(12, (index) => index),
                  builderItems: months,
                ),
                _CustomDropDown<int>(
                  title: 'Year',
                  onChanged: (year) => changeDate(year: year),
                  value: date.year,
                  items:
                      List.generate(10, (index) => DateTime.now().year + index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeDate({int? day, int? month, int? year}) => setState(
        () {
          DateTime _date = DateTime(
            year ?? date.year,
            month ?? date.month,
            day ?? date.day,
          );
          widget.onDateChanged.call(_date);
        },
      );
}

class _CustomDropDown<T> extends StatefulWidget {
  final String title;
  final Function(T? selected) onChanged;
  final T? value;
  final List<T> items;
  final String hint;
  final List<String>? builderItems;
  _CustomDropDown({
    Key? key,
    this.builderItems,
    required this.title,
    this.hint = '',
    required this.onChanged,
    required this.value,
    required this.items,
  }) : super(key: key);

  @override
  State<_CustomDropDown<T>> createState() => __CustomDropDownState<T>();
}

class __CustomDropDownState<T> extends State<_CustomDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AutoSizeText(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Card(
            elevation: 5,
            child: DropdownButton<T>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(10),
              underline: SizedBox(),
              icon: Container(),
              selectedItemBuilder: (context) => widget.items
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: AutoSizeText(
                          widget.builderItems == null
                              ? e.toString().toTitle()
                              : widget.builderItems![e as int].toTitle(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              items: widget.items
                  .map(
                    (T e) => DropdownMenuItem<T>(
                      child: Center(
                        child: AutoSizeText(
                          widget.builderItems == null
                              ? e.toString().toTitle()
                              : widget.builderItems![e as int].toTitle(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      value: e,
                    ),
                  )
                  .toList(),
              hint: Center(
                child: AutoSizeText(
                  widget.hint,
                  textAlign: TextAlign.start,
                ),
              ),
              onChanged: widget.onChanged,
              value: widget.value,
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomFormTextField extends StatefulWidget {
  final String title;
  final String? Function(String? value)? validator;
  final int lines;
  final TextEditingController controller;

  _CustomFormTextField({
    Key? key,
    this.lines = 1,
    this.validator,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  State<_CustomFormTextField> createState() => __CustomFormTextFieldState();
}

class __CustomFormTextFieldState extends State<_CustomFormTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            controller: widget.controller,
            maxLines: widget.lines,
            style: TextStyle(fontWeight: FontWeight.bold),
            // The validator receives the text that the user has entered.
            validator: widget.validator,

            decoration: InputDecoration(
              fillColor: backgroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomFormText extends StatelessWidget {
  final String title;
  final String text;
  _CustomFormText({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
