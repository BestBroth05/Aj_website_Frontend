import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/dates_utils.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/dialogs/confirm_dialog.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AdminUserCard extends StatefulWidget {
  final User? user;
  final Map<String, TextEditingController> controllers;
  final Map<String, dynamic> values;
  final Function(String key, dynamic value) onValuesChange;
  final Function(User _user) deleteUser;
  final Function(User _user) editUser;
  static bool editing = false;
  AdminUserCard(
    this.user, {
    Key? key,
    required this.controllers,
    required this.values,
    required this.deleteUser,
    required this.onValuesChange,
    required this.editUser,
  }) : super(key: key);

  @override
  State<AdminUserCard> createState() => _AdminUserCardState();
}

class _AdminUserCardState extends State<AdminUserCard> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: widget.user != null ? white : backgroundColor,
      child: widget.user == null
          ? Center(child: AutoSizeText('No user selected'))
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      widget.user!.username,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          'ID: ' + '${widget.user!.id}'.padLeft(7, '0'),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          'Register date: ' +
                              DateTime.parse(widget.user!.registerDate)
                                  .readableFormat,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(thickness: 2),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: _CustomFormTextField(
                              title: 'First Name',
                              enabled: AdminUserCard.editing,
                              controller: widget.controllers['name']!,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _CustomFormTextField(
                              title: 'Last Name',
                              enabled: AdminUserCard.editing,
                              controller: widget.controllers['lastName']!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: _CustomFormTextField(
                              title: 'Username',
                              enabled: AdminUserCard.editing,
                              controller: widget.controllers['username']!,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _CustomFormTextField(
                              title: 'Password',
                              obscure: true,
                              enabled: AdminUserCard.editing,
                              controller: widget.controllers['password']!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: _CustomFormTextField(
                              title: 'Phone',
                              enabled: AdminUserCard.editing,
                              controller: widget.controllers['number']!,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _CustomFormTextField(
                              title: 'Company',
                              enabled: AdminUserCard.editing,
                              controller: widget.controllers['company']!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: _CustomDropDown<UserType>(
                              title: 'Type',
                              enabled: AdminUserCard.editing,
                              onChanged: (type) => widget.onValuesChange.call(
                                'type',
                                type,
                              ),
                              value: widget.values['type'],
                              items: UserType.values,
                              builderItems:
                                  UserType.values.map((e) => e.name).toList(),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _CustomDropDown<bool>(
                              title: 'Status',
                              enabled: AdminUserCard.editing,
                              onChanged: (status) => widget.onValuesChange.call(
                                'status',
                                status,
                              ),
                              value: widget.values['status'],
                              items: [true, false],
                              builderItems: ['Active', 'Not Active'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: AutoSizeText('Birthday'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _CustomDropDown<int>(
                                    title: 'Day',
                                    enabled: AdminUserCard.editing,
                                    onChanged: (day) => widget.onValuesChange(
                                      'date',
                                      changeDate(day: day),
                                    ),
                                    value: widget.values['date'].day,
                                    items: List.generate(
                                      widget.values['date'].month == 2 &&
                                              widget.values['date'].year % 4 ==
                                                  0
                                          ? daysInMonth[
                                                  widget.values['date'].month -
                                                      1] +
                                              1
                                          : daysInMonth[
                                              widget.values['date'].month - 1],
                                      (index) => index + 1,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _CustomDropDown<int>(
                                    title: 'Month',
                                    enabled: AdminUserCard.editing,
                                    onChanged: (month) => widget.onValuesChange(
                                      'date',
                                      changeDate(month: month! + 1),
                                    ),
                                    value: widget.values['date'].month - 1,
                                    items: List.generate(
                                      12,
                                      (index) => index,
                                    ),
                                    builderItems: months,
                                  ),
                                ),
                                Expanded(
                                  child: _CustomDropDown<int>(
                                    title: 'Year',
                                    enabled: AdminUserCard.editing,
                                    onChanged: (year) => widget.onValuesChange(
                                      'date',
                                      changeDate(year: year),
                                    ),
                                    value: widget.values['date'].year,
                                    items: List.generate(
                                      100,
                                      (index) => DateTime.now().year - index,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            text: AdminUserCard.editing ? 'Cancel' : 'Delete',
                            onPressed: AdminUserCard.editing
                                ? () => setState(
                                      () => AdminUserCard.editing = false,
                                    )
                                : () => openConfirmDialog(
                                      context,
                                      () => widget.deleteUser(widget.user!),
                                      text:
                                          'Do you want to delete user:\n${widget.user!.username}?',
                                    ),
                            color: AdminUserCard.editing ? gray : red,
                          ),
                          CustomButton(
                            text: AdminUserCard.editing ? 'Confirm' : 'Edit',
                            onPressed: () => setState(
                              () {
                                if (_formKey.currentState!.validate() &&
                                    AdminUserCard.editing) {
                                  User newUser = User(
                                    type: widget.values['type'],
                                    name: widget.controllers['name']!.text,
                                    lastName:
                                        widget.controllers['lastName']!.text,
                                    email: widget.controllers['email']!.text,
                                    username:
                                        widget.controllers['username']!.text,
                                    password:
                                        widget.controllers['password']!.text,
                                    company:
                                        widget.controllers['company']!.text,
                                    number: widget.controllers['number']!.text,
                                    registerDate:
                                        DateTime.now().toIso8601String(),
                                    birthday:
                                        (widget.values['date'] as DateTime)
                                            .birthdayFormat,
                                  );
                                  newUser.id = widget.user!.id;
                                  newUser.isActive = widget.values['status'];

                                  widget.editUser.call(newUser);
                                }
                                AdminUserCard.editing = !AdminUserCard.editing;
                              },
                            ),
                            color: blue,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  DateTime changeDate({int? day, int? month, int? year}) {
    DateTime date = widget.values['date'];

    date = DateTime(year ?? date.year, month ?? date.month, day ?? date.day);

    return date;
  }
}

class _CustomDropDown<T> extends StatefulWidget {
  final String title;
  final Function(T? selected) onChanged;
  final T? value;
  final List<T> items;
  final String hint;
  final List<String>? builderItems;
  final bool enabled;
  _CustomDropDown({
    Key? key,
    this.builderItems,
    required this.title,
    this.hint = '',
    this.enabled = false,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          widget.title,
        ),
        Card(
          elevation: 5,
          child: DropdownButton<T>(
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            underline: SizedBox(),
            icon: Container(),
            selectedItemBuilder: widget.builderItems == null
                ? (context) => widget.items
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: AutoSizeText(
                            e.toString().toTitle(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                    .toList()
                : (context) => widget.builderItems!
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: AutoSizeText(
                            e.toString().toTitle(),
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
                            : widget.builderItems![widget.items.indexOf(e)]
                                .toTitle(),
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
            onChanged: widget.enabled ? widget.onChanged : null,
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
  final bool enabled;
  final bool obscure;
  _CustomFormTextField({
    Key? key,
    this.lines = 1,
    this.validator,
    this.enabled = false,
    this.obscure = false,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            widget.obscure
                ? Container()
                : IconButton(
                    splashRadius: 10,
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.controller.text,
                        ),
                      );
                      showToast(
                        context,
                        text: 'Copied to clipboard',
                        icon: Icons.copy,
                      );
                    },
                    icon: Icon(
                      Icons.copy,
                      size: 15,
                      color: gray,
                    ),
                  )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              enabled: widget.enabled,
              obscureText: widget.obscure,
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
