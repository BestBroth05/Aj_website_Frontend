import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/enums/projects/projects_status.dart';
import 'package:guadalajarav2/enums/working_areas.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class ProjectEmployeeTab extends StatelessWidget {
  final Map<String, dynamic>? task;
  final Function(String key, dynamic value) onChanged;
  ProjectEmployeeTab(
    this.task, {
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  TextEditingController commitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        color: task == null ? backgroundColor : null,
        child: task == null
            ? Center(
                child: AutoSizeText('No task selected'),
              )
            : Row(
                children: [
                  Expanded(
                    child: _CustomUserDropDown<ProjectStatus>(
                      hint: 'Status',
                      onChanged: (newStatus) => onChanged(
                        'status',
                        ProjectStatus.values.indexOf(newStatus!),
                      ),
                      users: [
                        ProjectStatus.standby,
                        ProjectStatus.active,
                        ProjectStatus.stopped,
                        ProjectStatus.completed,
                      ],
                      value: ProjectStatus.values[task!['status']],
                    ),
                  ),
                  Expanded(
                    child: _CustomUserDropDown<int>(
                      hint: 'Real Hours',
                      onChanged: (hours) {
                        onChanged('real_hours', hours);
                        commit('Hours updated to: $hours');
                      },
                      users: List.generate(50, (index) => index),
                      value: task!['real_hours'],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: _CustomFormTextField(
                        controller: commitController,
                        title: 'Commit',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomButton(
                      text: 'Commit',
                      onPressed: () => commit(commitController.text),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void commit(String message) {
    if (message.isEmpty) {
      return;
    }
    String old = task!['notes'];

    String value =
        '[${DateTime.now().dateFormatted} - ${DateTime.now().timeFormatted}]\n-$message ';
    if (old.isNotEmpty) {
      value = '$old\n$value';
    }
    onChanged('notes', value);
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
                child: _TextDropDown<T>(e),
              ),
            )
            .toList(),
        items: widget.users
            .map(
              (T e) => DropdownMenuItem<T>(
                child: _TextDropDown<T>(e),
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

class _TextDropDown<T> extends StatelessWidget {
  final T e;
  const _TextDropDown(this.e, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
        T == User
            ? (e as User).name
            : T == ProjectStatus
                ? (e as ProjectStatus).name.toTitle()
                : T == ProjectStatus
                    ? (e as WorkingAreas).name.toTitle()
                    : e.toString().toTitle(),
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
        Expanded(
          child: Center(
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
        ),
      ],
    );
  }
}
