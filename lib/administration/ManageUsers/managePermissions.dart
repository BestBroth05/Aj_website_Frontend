import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/administration/user/userPermissions.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ManagePermissions extends StatefulWidget {
  final User user;

  ManagePermissions({required this.user});

  @override
  _ManagePermissionsState createState() => _ManagePermissionsState();
}

class _ManagePermissionsState extends State<ManagePermissions> {
  int selected = -1;

  List<UserPermission> notPermitted = [];
  List<UserPermission> permitted = [];

  @override
  void initState() {
    super.initState();
    permitted = widget.user.permissions;

    for (UserPermission p in UserPermission.values) {
      if (!permitted.contains(p)) {
        notPermitted.add(p);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.6,
      height: height * 0.8,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.025,
        vertical: height * 0.01,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(
          25,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: AutoSizeText(
                '${widget.user.fullName}\nPermissions',
                maxLines: 2,
                style: subtitleEdit,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 18,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      AutoSizeText('Denied', style: subtitleEdit),
                      Expanded(child: permissionsContainer(notPermitted, 0)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      children: [
                        AutoSizeText('', style: subtitleEdit),
                        Expanded(
                          flex: 2,
                          child: changeButton(
                            Icons.chevron_right_rounded,
                            0,
                            notPermitted.length,
                            notPermitted,
                            permitted,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: changeButton(
                            Icons.chevron_left_rounded,
                            notPermitted.length,
                            notPermitted.length + permitted.length,
                            permitted,
                            notPermitted,
                          ),
                        ),
                        Expanded(
                          flex: 16,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      AutoSizeText('Permitted', style: subtitleEdit),
                      Expanded(
                        child: permissionsContainer(
                          permitted,
                          notPermitted.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: confirmButton()),
        ],
      ),
    );
  }

  Widget confirmButton() {
    return Container(
      width: width * 0.1,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: blue,
        ),
        onPressed: () async {
          widget.user.permissions = permitted;
          bool couldUpdate = await updatePermissions(widget.user, context);
          Widget notification = Container();
          if (couldUpdate) {
            Navigator.pop(context);
            notification = AlertNotification(
                icon: Icons.check_rounded,
                color: green,
                str: 'Permissions Updated');
          } else {
            notification = AlertNotification(
                icon: Icons.error_rounded,
                color: red,
                str: 'Error while\nupdating Permissions');
          }

          containerDialog(
            context,
            true,
            notification,
            0.5,
          );
        },
        child: AutoSizeText('Confirm'),
      ),
    );
  }

  Widget item(String str, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.005,
        vertical: height * 0.005,
      ),
      child: Material(
        elevation: 5,
        child: ListTile(
            selected: selected == index,
            selectedTileColor: lightDarkGrey,
            title: AutoSizeText(str),
            tileColor: white,
            onTap: () => setState(() {
                  if (selected == index) {
                    selected = -1;
                  } else {
                    selected = index;
                  }
                })
            // print(selected);
            ),
      ),
    );
  }

  Widget permissionsContainer(
      List<UserPermission> permissions, int startingIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.020,
      ),
      child: Container(
        color: lightGrey,
        child: ListView.builder(
          itemCount: permissions.length,
          itemBuilder: (BuildContext context, int index) =>
              item(permissions[index].name, startingIndex + index),
        ),
      ),
    );
  }

  Widget changeButton(IconData icon, int min, int max,
      List<UserPermission> from, List<UserPermission> to) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: ElevatedButton(
        child: Container(
          width: width * 0.03,
          child: Center(child: Icon(icon)),
        ),
        onPressed: selected >= min && selected < max
            ? () => setState(() {
                  int index = selected;

                  if (selected >= notPermitted.length) {
                    index -= notPermitted.length;
                    selected = 0;
                  } else {
                    selected = notPermitted.length - 1;
                  }

                  UserPermission item = from[index];

                  from.remove(item);
                  to.insert(0, item);
                })
            : null,
      ),
    );
  }
}
