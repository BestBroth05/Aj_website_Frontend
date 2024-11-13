import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/ManageUsers/manageUsers.dart';
import 'package:guadalajarav2/administration/adminView.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ConfirmUserDeletion extends StatefulWidget {
  final User user;

  ConfirmUserDeletion({required this.user});

  @override
  _ConfirmUserDeletion createState() => _ConfirmUserDeletion();
}

class _ConfirmUserDeletion extends State<ConfirmUserDeletion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.2,
      height: height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: white,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    10,
                  ),
                ),
                color: red,
              ),
              child: Center(
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: white,
                  size: height * 0.05,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Center(
                      child: Text(
                        'Delete user:\n${widget.user.toString()}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (await deleteUserInDatabase(widget.user)) {
                            Navigator.pop(context);
                            containerDialog(
                              context,
                              true,
                              AlertNotification(
                                icon: Icons.check_rounded,
                                color: green,
                                str: 'User Deleted',
                              ),
                              0.5,
                            );
                            List<User> refreshUsers =
                                await getAllUsersInDatabase();
                            adminState.setState(() {
                              selectedUserInAdmin = -1;
                              users = refreshUsers;
                            });
                          } else {
                            containerDialog(
                              context,
                              true,
                              AlertNotification(
                                icon: Icons.error_rounded,
                                color: red,
                                str: 'Error while deleting User',
                              ),
                              0.5,
                            );
                          }
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
