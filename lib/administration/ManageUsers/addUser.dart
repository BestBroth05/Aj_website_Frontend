import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/adminView.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class AddUserPopup extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUserPopup> {
  UserType selectedType = UserType.guest;
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController birthdayController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();

  List<String> subtitles = [
    'Username*',
    'Name*',
    'Last Name*',
    'Email*',
    'Telephone',
    'Password*',
    'Confirm Password*',
    'Birthday',
    'Company',
  ];
  List<TextEditingController> controllers = [];
  List<bool> correctTextFields = [];

  @override
  void initState() {
    super.initState();
    controllers = [
      usernameController,
      nameController,
      lastNameController,
      emailController,
      numberController,
      passwordController,
      confirmPasswordController,
      birthdayController,
      companyController,
    ];

    for (int i = 0; i < controllers.length; i++) {
      correctTextFields.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.5,
      height: height * 0.525,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.01,
          vertical: height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Row(
                children: [
                  Expanded(
                    child: AutoSizeText('New User', style: subTitle2),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              flex: 86,
              child: body(),
            ),
            Divider(),
            Expanded(
              flex: 7,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                      child: confirmButton(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool verifyFields() {
    for (int i = 0; i < correctTextFields.length; i++) {
      if (subtitles[i].contains('*')) {
        correctTextFields[i] = controllers[i].text.isNotEmpty;
      }
    }

    correctTextFields[6] =
        confirmPasswordController.text == passwordController.text &&
            confirmPasswordController.text.isNotEmpty;

    if (birthdayController.text.isNotEmpty) {
      correctTextFields[7] = validateDate(birthdayController.text);
    }

    return !correctTextFields.contains(false);
  }

  Widget confirmButton() {
    return ElevatedButton(
        onPressed: () async {
          bool isCorrect = false;
          setState(() {
            isCorrect = verifyFields();
          });
          if (isCorrect) {
            User newUser = new User(
              type: selectedType,
              name: toTitle(nameController.text),
              lastName: toTitle(lastNameController.text),
              email: emailController.text,
              username: usernameController.text,
              password: passwordController.text,
              number: numberController.text.isNotEmpty
                  ? numberController.text
                  : null,
              company: companyController.text.isNotEmpty
                  ? companyController.text
                  : null,
              birthday: birthdayController.text.isNotEmpty
                  ? birthdayController.text
                  : null,
              registerDate: DateTime.now().toString(),
            );

            if (await addUsersToDatabase(newUser)) {
              Navigator.pop(context);
              containerDialog(
                context,
                true,
                AlertNotification(
                  icon: Icons.check_rounded,
                  color: green,
                  str: 'User Added',
                ),
                0.5,
              );
              List<User> refreshUsers = await getAllUsersInDatabase();
              adminState.setState(() {
                users = refreshUsers;
              });
            } else {
              containerDialog(
                context,
                true,
                AlertNotification(
                  icon: Icons.error_rounded,
                  color: red,
                  str: 'Error while adding User',
                ),
                0.5,
              );
            }
          } else {}
        },
        child: AutoSizeText('Add'));
  }

  Widget body() {
    List<Widget> column = [
      Container(
        height: height * 0.075,
        child: Row(
          children: [
            Expanded(child: fillText(subtitles[0], 0)),
            Expanded(child: typeUserDropdown(UserType.values)),
          ],
        ),
      ),
    ];
    for (int i = 1; i < controllers.length; i += 2) {
      column.add(
        Container(
          height: height * 0.075,
          child: Row(
            children: [
              Expanded(child: fillText(subtitles[i], i)),
              Expanded(child: fillText(subtitles[i + 1], i + 1)),
            ],
          ),
        ),
      );
    }
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: Column(
            children: column,
          ),
        ),
      ),
    );
  }

  Widget fillText(
    String title,
    int index,
  ) {
    TextEditingController controller = controllers[index];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText('$title', style: subtitleAddUser),
          Container(
            height: height * 0.035,
            child: TextField(
              textAlign: TextAlign.center,
              minLines: 1,
              maxLines: 1,
              style: TextStyle(color: darkGrey),
              obscureText: title.contains('Password'),
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: title == 'Birthday' ? 'DD/MM/YYYY' : '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: width * 0.01,
                ),
                filled: true,
                fillColor: correctTextFields[index]
                    ? backgroundColor
                    : red.withOpacity(0.2),
                border: null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: correctTextFields[index] ? backgroundColor : red,
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: correctTextFields[index] ? backgroundColor : red,
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget typeUserDropdown(List<UserType> values) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText('Role', style: subtitleAddUser),
          Container(
            height: height * 0.035,
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: DropdownButton<UserType>(
                underline: SizedBox(),
                icon: SizedBox(),
                isExpanded: true,
                selectedItemBuilder: (BuildContext context) => values
                    .map(
                      (UserType value) => Center(
                        child: AutoSizeText(
                          value.name,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
                items: values
                    .map((UserType value) => DropdownMenuItem(
                          child: Center(
                            child: AutoSizeText(value.name),
                          ),
                          value: value,
                        ))
                    .toList(),
                value: selectedType,
                onChanged: (UserType? newValue) {
                  setState(() {
                    selectedType = newValue!;
                    if (selectedType == UserType.employee) {
                      companyController.text = 'AJ Electronic Design';
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
