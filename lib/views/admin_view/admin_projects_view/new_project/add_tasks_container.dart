import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/csv_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AddTaskContainer extends StatefulWidget {
  final Map<int, User> users;
  final Map<int, List<int>> usersInProject;
  final Function(Map<String, dynamic> task) onValidated;
  final Function(int index) onDelete;
  final List<Map<String, dynamic>> tasks;

  AddTaskContainer(
    this.tasks, {
    Key? key,
    required this.usersInProject,
    required this.users,
    required this.onValidated,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<AddTaskContainer> createState() => _AddTaskContainerState();
}

class _AddTaskContainerState extends State<AddTaskContainer> {
  final GlobalKey<FormState> _tastFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Tasks',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 2),
          Expanded(
            child: widget.tasks.length == 0
                ? Center(
                    child: AutoSizeText(
                      'There are currently no tasks in this project',
                      style: TextStyle(
                        color: gray.add(black, 0.3),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      Map<String, dynamic> task = widget.tasks.elementAt(
                        index,
                      );

                      String name = task['name'];
                      String notes = task['notes'];
                      int hours = task['estimated_hours'];
                      User member = widget.users[task['member_id']]!;
                      WorkingAreas area =
                          WorkingAreas.values.elementAt(task['area']);

                      return Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      '$name - $hours hours',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.5,
                                      ),
                                    ),
                                    AutoSizeText(
                                      '${member.fullName} - ${area.name.toTitle()}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: gray.add(black, 0.3),
                                      ),
                                    ),
                                    AutoSizeText(
                                      '$notes',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: gray.add(black, 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                splashRadius: 10,
                                onPressed: () => setState(
                                  () => widget.onDelete.call(index),
                                ),
                                color: red,
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: widget.tasks.length,
                  ),
          ),
          Divider(thickness: 2),
          _NewTaskForm(
            _tastFormKey,
            usersInProject: widget.usersInProject,
            users: widget.users,
            onValidated: widget.onValidated,
          ),
        ],
      ),
    );
  }
}

class _NewTaskForm extends StatefulWidget {
  final Map<int, List<int>> usersInProject;
  final Map<int, User> users;
  final GlobalKey<FormState> _formKey;
  final Function(Map<String, dynamic> task) onValidated;
  _NewTaskForm(
    this._formKey, {
    Key? key,
    required this.usersInProject,
    required this.users,
    required this.onValidated,
  }) : super(key: key);

  @override
  State<_NewTaskForm> createState() => __NewTaskFormState();
}

class __NewTaskFormState extends State<_NewTaskForm> {
  User? selectedUser;
  WorkingAreas? selectedArea;

  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
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
            ],
          ),
          _CustomFormTextField(
            title: 'Notes',
            controller: notesController,
            lines: 3,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _CustomUserDropDown<User>(
                  onChanged: (newUser) => setState(() {
                    selectedArea = null;
                    selectedUser = newUser;
                  }),
                  value: selectedUser,
                  users: widget.users.values.where((element) {
                    return widget.usersInProject.containsKey(element.id);
                  }).toList(),
                  hint: 'Member',
                ),
              ),
              Expanded(
                flex: 3,
                child: _CustomUserDropDown<WorkingAreas>(
                  onChanged: (newUser) => setState(
                    () => selectedArea = newUser,
                  ),
                  value: selectedUser == null || selectedArea == null
                      ? null
                      : widget.usersInProject.containsKey(selectedUser!.id)
                          ? widget.usersInProject[selectedUser!.id]!
                                  .contains(selectedArea!.id)
                              ? selectedArea
                              : null
                          : selectedArea,
                  users: WorkingAreas.values.where((element) {
                    if (selectedUser == null) {
                      return false;
                    } else {
                      if (widget.usersInProject.containsKey(selectedUser!.id)) {
                        return widget.usersInProject[selectedUser!.id]!
                            .contains(element.id);
                      } else {
                        return false;
                      }
                    }
                  }).toList(),
                  hint: 'Area',
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
                  text: 'Upload tasks',
                  color: blue,
                  onPressed: selectedUser != null && selectedArea != null
                      ? () async {
                          List<List<String>>? values = await openCSV();

                          if (values == null) {
                            return;
                          }

                          for (List<String> value in values) {
                            addTask(
                              name: value[0],
                              hours: int.tryParse(value[2]) ?? 0,
                              notes: value[1],
                              memberId: selectedUser!.id,
                              areaId: selectedArea!.id,
                            );
                          }
                        }
                      : null,
                ),
                CustomButton(
                  text: 'Add New Task',
                  onPressed: () {
                    if (widget._formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      if (selectedUser != null && selectedArea != null) {
                        addTask(
                          name: nameController.text,
                          hours: int.parse(hoursController.text),
                          notes: notesController.text,
                          memberId: selectedUser!.id,
                          areaId: selectedArea!.id,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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
    task['real_hours'] = 0;
    task['notes'] = notes;
    task['member_id'] = memberId;
    task['area'] = areaId;
    task['status'] = 1;

    widget.onValidated.call(task);
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
                child: Center(
                  child: AutoSizeText(
                    T == User
                        ? (e as User).name
                        : (e as WorkingAreas).name.toTitle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
            .toList(),
        items: widget.users
            .map(
              (T e) => DropdownMenuItem<T>(
                child: Center(
                  child: AutoSizeText(
                    T == User
                        ? (e as User).name
                        : (e as WorkingAreas).name.toTitle(),
                    textAlign: TextAlign.center,
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
    );
  }
}

class _CustomFormTextField extends StatefulWidget {
  final String title;
  final String? Function(String? value)? validator;
  final int lines;
  final TextEditingController controller;
  final bool isNumeric;
  _CustomFormTextField({
    Key? key,
    this.lines = 1,
    this.validator,
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
            inputFormatters: widget.isNumeric
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
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
