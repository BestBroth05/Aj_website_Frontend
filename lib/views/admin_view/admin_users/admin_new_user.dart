import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/dates_utils.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class AdminNewUser extends StatefulWidget {
  final Function(User newUser) createNewUser;
  AdminNewUser({
    Key? key,
    required this.createNewUser,
  }) : super(key: key);

  @override
  State<AdminNewUser> createState() => _AdminNewUserState();
}

class _AdminNewUserState extends State<AdminNewUser> {
  bool editing = true;
  Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'lastName': TextEditingController(),
    'username': TextEditingController(),
    'company': TextEditingController(),
    'email': TextEditingController(),
    'number': TextEditingController(),
    'password': TextEditingController(),
  };

  UserType type = UserType.employee;
  bool status = true;

  DateTime date = DateTime.now().subtract(Duration(days: 365 * 18));
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void changeDate({int? day, int? month, int? year}) => setState(
        () {
          date = DateTime(
            year ?? date.year,
            month ?? date.month,
            day ?? date.day,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: white,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: SizedBox(
          width: width * 0.3,
          height: height * 0.7,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  'New user',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                AutoSizeText(
                  'Register date: ' + DateTime.now().readableFormat,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Divider(thickness: 2),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: _CustomFormTextField(
                          title: 'First Name',
                          enabled: editing,
                          controller: controllers['name']!,
                          validator: (value) => validate(value, 'Enter a name'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _CustomFormTextField(
                          title: 'Last Name',
                          enabled: editing,
                          controller: controllers['lastName']!,
                          validator: (value) => validate(
                            value,
                            'Enter a Last name',
                          ),
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
                          enabled: editing,
                          controller: controllers['username']!,
                          validator: (value) => validate(
                            value,
                            'Enter a username',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _CustomFormTextField(
                          title: 'Password',
                          obscure: true,
                          enabled: editing,
                          controller: controllers['password']!,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            } else {
                              return null;
                            }
                          },
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
                          title: 'Email',
                          enabled: editing,
                          controller: controllers['email']!,
                          validator: (value) => validate(
                            value,
                            'Enter an email',
                          ),
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
                          enabled: editing,
                          controller: controllers['number']!,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Phone number must be at least 10 digits long';
                            } else {
                              value = value.replaceAll(' ', '');
                              value = value.replaceAll('+', '');
                              value = value.replaceAll('(', '');
                              value = value.replaceAll(')', '');

                              if (int.tryParse(value) == null) {
                                return 'Invalid Phone number';
                              } else {
                                return null;
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _CustomFormTextField(
                          title: 'Company',
                          enabled: editing,
                          controller: controllers['company']!,
                          validator: (value) => validate(value, 'Enter a name'),
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
                          enabled: editing,
                          onChanged: (_) {},
                          value: type,
                          items: UserType.values,
                          builderItems:
                              UserType.values.map((e) => e.name).toList(),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _CustomDropDown<bool>(
                          title: 'Status',
                          enabled: editing,
                          onChanged: (_) {},
                          value: status,
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: AutoSizeText('Birthday'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                              child: _CustomDropDown<int>(
                                title: 'Day',
                                enabled: editing,
                                onChanged: (day) => changeDate(day: day),
                                value: date.day,
                                items: List.generate(
                                  date.month == 2 && date.year % 4 == 0
                                      ? daysInMonth[date.month - 1] + 1
                                      : daysInMonth[date.month - 1],
                                  (index) => index + 1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _CustomDropDown<int>(
                                title: 'Month',
                                enabled: editing,
                                onChanged: (month) => changeDate(
                                  month: month! + 1,
                                ),
                                value: date.month - 1,
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
                                enabled: editing,
                                onChanged: (year) => changeDate(year: year),
                                value: date.year,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      color: gray,
                    ),
                    CustomButton(
                      text: 'Create User',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          User newUser = User(
                            type: type,
                            name: controllers['name']!.text,
                            lastName: controllers['lastName']!.text,
                            email: controllers['email']!.text,
                            username: controllers['username']!.text,
                            password: controllers['password']!.text,
                            company: controllers['company']!.text,
                            number: controllers['number']!.text,
                            registerDate: DateTime.now().toIso8601String(),
                            birthday: date.birthdayFormat,
                          );

                          widget.createNewUser.call(newUser);
                        }
                      },
                      color: teal.add(black, 0.2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validate(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    } else {
      return null;
    }
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
        Expanded(
          child: AutoSizeText(
            widget.title,
          ),
        ),
        Expanded(
          flex: 2,
          child: Card(
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
        Expanded(
          child: Row(
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
        ),
        Expanded(
          flex: 2,
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
      ],
    );
  }
}
