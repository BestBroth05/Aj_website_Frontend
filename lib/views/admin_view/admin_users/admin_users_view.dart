import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/admin_users/admin_user_card.dart';
import 'package:guadalajarav2/views/admin_view/admin_users/admin_users_bar.dart';
import 'package:guadalajarav2/views/admin_view/admin_users/admin_users_headers.dart';
import 'package:guadalajarav2/views/admin_view/admin_users/admin_users_tile.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';

class AdminUsersView extends StatefulWidget {
  AdminUsersView({Key? key}) : super(key: key);

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  List<User> users = [];
  User? selectedUser;

  Map<String, int> headers = {
    'id': 2,
    'name': 3,
    'username': 3,
    'type': 2,
    'company': 3,
    'status': 2,
  };

  Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'lastName': TextEditingController(),
    'username': TextEditingController(),
    'company': TextEditingController(),
    'email': TextEditingController(),
    'number': TextEditingController(),
    'password': TextEditingController(),
  };

  Map<String, dynamic> values = {
    'type': UserType.employee,
    'status': true,
    'date': DateTime.now(),
  };

  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      openDialog(context, container: BasicTextDialog('Loading users'));
      await getUsers();
      Navigator.pop(context);
    });
  }

  Future<void> getUsers() async {
    List<User> _users = await getAllUsersInDatabase();
    if (_users.length > 0) {
      updateSelectedUser(_users.last);
    }
    setState(() => users = _users);
    // openDialog(context, container: AdminNewUser());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DashboardTopBar(selected: 4),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                elevation: 5,
                child: Container(
                  child: Column(
                    children: [
                      AdminUsersBar(
                        createNewUser: (newUser) async {
                          // print(newUser);
                          if (await addUsersToDatabase(newUser)) {
                            Navigator.pop(context);
                            openDialog(
                              context,
                              container: TimedDialog(
                                text: newUser.name + '\nAdded to Database',
                              ),
                            );
                            await getUsers();
                          } else {
                            openDialog(
                              context,
                              container: TimedDialog(
                                text: 'An error occured',
                              ),
                            );
                          }
                        },
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 3,
                                  child: Column(
                                    children: [
                                      AdminUsersHeaders(headers),
                                      Expanded(
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              AdminUserTile(
                                            users[index],
                                            values: {
                                              'id': 2,
                                              'name': 3,
                                              'username': 3,
                                              'type': 2,
                                              'company': 3,
                                              'isActive': 2,
                                            },
                                            changeUser: (selected) => setState(
                                              () => updateSelectedUser(
                                                selected,
                                              ),
                                            ),
                                            isSelected:
                                                selectedUser == users[index],
                                            isOdd: index % 2 != 0,
                                          ),
                                          itemCount: users.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: AdminUserCard(
                                  selectedUser,
                                  controllers: controllers,
                                  values: values,
                                  deleteUser: (_user) async {
                                    // if (await deleteUserInDatabase(_user)) {
                                    //   openDialog(
                                    //     context,
                                    //     container: TimedDialog(
                                    //       text: _user.name + '\nDeleted',
                                    //     ),
                                    //   );
                                    //   await getUsers();
                                    // } else {
                                    //   openDialog(
                                    //     context,
                                    //     container: TimedDialog(
                                    //       text: 'An error ocurred',
                                    //     ),
                                    //   );
                                    // }
                                  },
                                  editUser: (_user) async {
                                    if (await editUserInDatabase(_user)) {
                                      openDialog(
                                        context,
                                        container: TimedDialog(
                                          text: _user.name + '\nEdited',
                                        ),
                                      );
                                      await getUsers();
                                    } else {
                                      openDialog(
                                        context,
                                        container: TimedDialog(
                                          text: 'An error ocurred',
                                        ),
                                      );
                                    }
                                  },
                                  onValuesChange: (key, value) => setState(
                                    () => values[key] = value,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void updateSelectedUser(User? newUser) {
    selectedUser = newUser;

    if (selectedUser != null) {
      AdminUserCard.editing = false;
      controllers.forEach(
        (key, value) {
          controllers[key] = TextEditingController(
            text: selectedUser!.toJson()[key].toString(),
          );
        },
      );

      values['type'] = selectedUser!.type;
      values['status'] = selectedUser!.isActive;

      int year = int.parse(selectedUser!.birthday!.split('/')[2]);
      int month = int.parse(selectedUser!.birthday!.split('/')[1]);
      int day = int.parse(selectedUser!.birthday!.split('/')[0]);

      values['date'] = DateTime(year, month, day);
    }
  }
}
