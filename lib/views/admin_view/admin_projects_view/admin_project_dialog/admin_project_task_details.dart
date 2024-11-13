import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AdminProjectTaskDetails extends StatefulWidget {
  final Map<String, dynamic>? task;
  final Map<int, User> users;
  final Map<String, dynamic> temp;
  final Function(String key, dynamic newValue) onChanged;
  final VoidCallback onEdit;
  const AdminProjectTaskDetails(
    this.task, {
    Key? key,
    required this.users,
    required this.temp,
    required this.onEdit,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AdminProjectTaskDetails> createState() =>
      _AdminProjectTaskDetailsState();
}

class _AdminProjectTaskDetailsState extends State<AdminProjectTaskDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: widget.task == null ? backgroundColor : null,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.task == null
              ? [
                  Expanded(
                    child: Center(
                      child: AutoSizeText('No task selected'),
                    ),
                  ),
                ]
              : [
                  AutoSizeText(
                    widget.task!['name'],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Divider(thickness: 2),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                widget.task!['notes'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: _CustomUserDropDown<User>(
                                  value: widget.temp['user'],
                                  onChanged: (value) => widget.onChanged(
                                    'user',
                                    value,
                                  ),
                                  users: widget.users.values.toList(),
                                  hint: 'member',
                                ),
                              ),
                              Expanded(
                                child: _CustomUserDropDown<WorkingAreas>(
                                  value:
                                      WorkingAreas.values[widget.temp['area']],
                                  onChanged: (value) => widget.onChanged(
                                    'area',
                                    WorkingAreas.values.indexOf(value!),
                                  ),
                                  users: WorkingAreas.values.toList(),
                                  hint: 'area',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: _CustomUserDropDown<int>(
                                  value: widget.temp['hours'],
                                  onChanged: (value) => widget.onChanged(
                                    'hours',
                                    value,
                                  ),
                                  users: List.generate(101, (index) => index),
                                  hint: 'hours',
                                ),
                              ),
                              Expanded(
                                child: _CustomUserDropDown<int>(
                                  value: widget.task!['estimated_hours'],
                                  onChanged: null,
                                  users: List.generate(101, (index) => index),
                                  hint: 'Estimated Hours',
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: _CustomUserDropDown<ProjectStatus>(
                                  value: ProjectStatus
                                      .values[widget.temp['status']],
                                  onChanged: (value) => widget.onChanged(
                                    'status',
                                    ProjectStatus.values.indexOf(value!),
                                  ),
                                  users: ProjectStatus.values.toList(),
                                  hint: 'status',
                                ),
                              ),
                            ],
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
                        text: 'Edit',
                        onPressed: widget.onEdit,
                        color: blue,
                      ),
                    ],
                  ),
                ],
        ),
      ),
    );
  }
}

class _CustomUserDropDown<T> extends StatefulWidget {
  final Function(T? selected)? onChanged;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          widget.hint.toTitle(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Card(
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
                            : T == WorkingAreas
                                ? (e as WorkingAreas).name.toTitle()
                                : T == ProjectStatus
                                    ? (e as ProjectStatus).name.toTitle()
                                    : e.toString().toTitle(),
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
                            : T == WorkingAreas
                                ? (e as WorkingAreas).name.toTitle()
                                : T == ProjectStatus
                                    ? (e as ProjectStatus).name.toTitle()
                                    : e.toString().toTitle(),
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
