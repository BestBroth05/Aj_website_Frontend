import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/csv_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class ProjectEditorEditTask extends StatelessWidget {
  final Map<String, dynamic>? task;
  final Function(Map<String, dynamic> task) editTask;
  final Map<int, List<int>> usersData;
  final Map<int, User> users;
  final User initUser;
  final WorkingAreas? initArea;
  const ProjectEditorEditTask(
    this.task, {
    Key? key,
    required this.editTask,
    this.initArea,
    required this.usersData,
    required this.users,
    required this.initUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: white,
      ),
      padding: EdgeInsets.all(20),
      width: width * 0.3,
      height: height * 0.8,
      child: _NewTaskForm(
        task,
        editTask: editTask,
        usersData: usersData,
        users: users,
        initUser: initUser,
        initArea: initArea,
        size: Size(width * 0.3, height * 0.8),
      ),
    );
  }
}

class _NewTaskForm extends StatefulWidget {
  final Map<String, dynamic>? initTask;
  final Function(Map<String, dynamic> task) editTask;
  final Map<int, List<int>> usersData;
  final Map<int, User> users;
  final User initUser;
  final WorkingAreas? initArea;
  final Size size;
  const _NewTaskForm(
    this.initTask, {
    Key? key,
    required this.size,
    required this.editTask,
    required this.initArea,
    required this.usersData,
    required this.users,
    required this.initUser,
  }) : super(key: key);

  @override
  State<_NewTaskForm> createState() => __NewTaskFormState();
}

class __NewTaskFormState extends State<_NewTaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  WorkingAreas? selectedArea;
  User? selectedUser;
  ProjectStatus? selectedStatus;

  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController realHoursController = TextEditingController();

  Map<String, dynamic> get initTask =>
      widget.initTask ??
      {
        'name': '',
        'notes': '',
        'estimated_hours': 0,
        'real_hours': 0,
        'status': 0,
      };

  List<WorkingAreas> get areas => WorkingAreas.values.where((element) {
        int index = WorkingAreas.values.indexOf(element);

        return widget.usersData[selectedUser!.id]!.sublist(1).contains(index);
      }).toList();

  @override
  void initState() {
    super.initState();
    nameController.text = initTask['name'];
    notesController.text = initTask['notes'];
    hoursController.text = initTask['estimated_hours'].toString();
    realHoursController.text = initTask['real_hours'].toString();
    selectedUser = widget.initUser;
    selectedStatus = ProjectStatus.values[initTask['status']];
    selectedArea = widget.initArea ?? areas[0];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: widget.size.height,
        width: widget.size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _CustomFormTextField(
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
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _CustomFormTextField(
                    title: 'Estimated Hours',
                    controller: hoursController,
                    isNumeric: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter estimated hours';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _CustomFormTextField(
                    title: 'Real Hours',
                    controller: realHoursController,
                    isNumeric: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter real hours';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: _CustomFormTextField(
                title: 'Notes',
                controller: notesController,
                expanded: true,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _CustomUserDropDown<User>(
                    onChanged: (newUser) => setState(
                      () {
                        selectedUser = newUser;
                        selectedArea = areas[0];
                      },
                    ),
                    value: selectedUser,
                    users: widget.users.values.toList(),
                    hint: 'Area',
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _CustomUserDropDown<WorkingAreas>(
                    onChanged: (newUser) => setState(
                      () => selectedArea = newUser,
                    ),
                    value: selectedArea,
                    users: areas,
                    hint: 'Area',
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _CustomUserDropDown<ProjectStatus>(
                    onChanged: (newUser) => setState(
                      () => selectedStatus = newUser,
                    ),
                    value: selectedStatus,
                    users: ProjectStatus.values,
                    hint: 'Status',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Cancel',
                    color: blue,
                    onPressed: () => Navigator.pop(context),
                  ),
                  CustomButton(
                    text: widget.initTask == null ? 'Add Task' : 'Edit Task',
                    onPressed: selectedArea != null
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              addTask(
                                name: nameController.text,
                                hours: int.parse(hoursController.text),
                                notes: notesController.text,
                                memberId: user!.id,
                                areaId: selectedArea!.id,
                              );
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTask({
    required String name,
    required int hours,
    required String notes,
    required int memberId,
    required int areaId,
  }) {
    Map<String, dynamic> task = {};

    task['name'] = name;
    task['estimated_hours'] = hours;
    task['real_hours'] = int.parse(realHoursController.text);
    task['notes'] = notes;
    task['member_id'] = memberId;
    task['area'] = areaId;
    task['status'] = ProjectStatus.values.indexOf(selectedStatus!);

    widget.editTask.call(task);
    // print(task);
  }
}

class _CustomUserDropDown<T> extends StatefulWidget {
  final Function(T? selected) onChanged;
  final T? value;
  final List<T> users;
  final String hint;
  _CustomUserDropDown({
    Key? key,
    required this.hint,
    required this.onChanged,
    required this.value,
    required this.users,
  }) : super(key: key);

  @override
  State<_CustomUserDropDown<T>> createState() => __CustomUserDropDownState<T>();
}

class __CustomUserDropDownState<T> extends State<_CustomUserDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: DropdownButton<T>(
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        underline: SizedBox(),
        icon: Container(),
        selectedItemBuilder: (context) => widget.users
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: _DropdownText<T>(e),
              ),
            )
            .toList(),
        items: widget.users
            .map(
              (T e) => DropdownMenuItem<T>(
                child: _DropdownText<T>(e),
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
    );
  }
}

class _DropdownText<T> extends StatelessWidget {
  final dynamic e;
  const _DropdownText(this.e, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
        T == User
            ? (e as User).name
            : T == ProjectStatus
                ? (e as ProjectStatus).name.toTitle()
                : (e as WorkingAreas).name.toTitle(),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _CustomFormTextField extends StatefulWidget {
  final String title;
  final String? Function(String? value)? validator;
  final int lines;
  final TextEditingController controller;
  final bool isNumeric;
  final bool expanded;
  _CustomFormTextField({
    Key? key,
    this.lines = 1,
    this.validator,
    this.expanded = false,
    this.isNumeric = false,
    required this.controller,
    required this.title,
  }) : super(key: key);

  @override
  State<_CustomFormTextField> createState() => __CustomFormTextFieldState();
}

class __CustomFormTextFieldState extends State<_CustomFormTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          widget.expanded
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      inputFormatters: widget.isNumeric
                          ? [FilteringTextInputFormatter.digitsOnly]
                          : [],
                      controller: widget.controller,
                      expands: widget.expanded,
                      textAlignVertical:
                          widget.expanded ? TextAlignVertical.top : null,
                      minLines: widget.expanded ? null : 1,
                      maxLines: widget.expanded ? null : widget.lines,
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
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    inputFormatters: widget.isNumeric
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : [],
                    controller: widget.controller,
                    expands: widget.expanded,
                    minLines: widget.expanded ? null : 1,
                    maxLines: widget.expanded ? null : widget.lines,
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
      ),
    );
  }
}
