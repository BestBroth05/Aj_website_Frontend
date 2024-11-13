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

class ProjectEmployeeAddTask extends StatelessWidget {
  final Function(Map<String, dynamic> task) addTask;
  final List<WorkingAreas> workingAreas;
  const ProjectEmployeeAddTask({
    Key? key,
    required this.addTask,
    required this.workingAreas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: width * 0.3,
      height: height * 0.5,
      child: _NewTaskForm(
        onValidated: addTask,
        workingAreas: workingAreas,
      ),
    );
  }
}

class _NewTaskForm extends StatefulWidget {
  final List<WorkingAreas> workingAreas;
  final Function(Map<String, dynamic> task) onValidated;
  _NewTaskForm({
    Key? key,
    required this.workingAreas,
    required this.onValidated,
  }) : super(key: key);

  @override
  State<_NewTaskForm> createState() => __NewTaskFormState();
}

class __NewTaskFormState extends State<_NewTaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  WorkingAreas? selectedArea;

  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                child: _CustomUserDropDown<WorkingAreas>(
                  onChanged: (newUser) => setState(
                    () => selectedArea = newUser,
                  ),
                  value: selectedArea,
                  users: widget.workingAreas,
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
                  onPressed: selectedArea != null
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
                              memberId: user!.id,
                              areaId: selectedArea!.id,
                            );
                          }
                        }
                      : null,
                ),
                CustomButton(
                  text: 'Add New Task',
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
