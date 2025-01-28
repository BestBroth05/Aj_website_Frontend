import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/ManageUsers/deleteConfirmatin.dart';
import 'package:guadalajarav2/administration/ManageUsers/editUser.dart';
import 'package:guadalajarav2/administration/ManageUsers/managePermissions.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class UserCard extends StatefulWidget {
  final User? user;

  UserCard({required this.user});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  User? user;
  Color primaryColor = darkNight;
  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    user = widget.user;
    return Container(
      color: backgroundColor,
      child: user == null
          ? sadFace()
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: primaryColor,
                          padding: EdgeInsets.only(bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: width * 0.01,
                                      ),
                                      child: SelectableText(
                                        'User ID: #${user!.id.toString().padLeft(7, '0')}',
                                        style: userTileTypeStyle.copyWith(
                                          color: gray,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(
                                  //     Icons.more_vert_rounded,
                                  //     color: white,
                                  //   ),
                                  // ),
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      color: white,
                                    ),
                                    onSelected: (String result) async {
                                      Widget container = Container();
                                      switch (result) {
                                        case 'edit':
                                          container =
                                              EditUserPopup(user: user!);
                                          break;
                                        case 'delete':
                                          container =
                                              ConfirmUserDeletion(user: user!);
                                          break;
                                        case 'permissions':
                                          user!.permissions =
                                              await getPermissions(user!);

                                          container =
                                              ManagePermissions(user: user!);
                                          break;
                                        default:
                                      }

                                      containerDialog(
                                        context,
                                        false,
                                        container,
                                        0.75,
                                      );
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'permissions',
                                        child: Text('Permissions'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(
                                child: getUserIconName(user.toString()),
                              ),
                              AutoSizeText(
                                user.toString(),
                                style: userTileNameStyle.copyWith(
                                  color: white,
                                ),
                              ),
                              AutoSizeText(
                                user!.type.name,
                                style: userTileTypeStyle.copyWith(
                                  color: white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      border: Border(
                        left: BorderSide(
                          color: backgroundColor,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.05,
                      horizontal: width * 0.025,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: allInfo(user!),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> allInfo(User _user) {
    Map<String, dynamic> info = _user.toJson();
    List<Widget> children = [];
    for (String key in info.keys.toList().sublist(2)) {
      dynamic value = info[key];
      key = toTitle(separateWords(key));
      if (key == 'Password' || key == 'Type' || key == 'Id') {
        continue;
      } else if (key == 'Is Active') {
        key = 'Status';
        value = value == 1 ? 'Active' : 'Not Active';
      }
      if (value == null) {
        continue;
      } else {
        children.add(Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            child: userInfo(key, value.toString())));
      }
    }
    return children;
  }

  Widget userInfo(String subtitle, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AutoSizeText(
                subtitle,
                style: userCardTitleStyle,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: SelectableText(
                info,
                style: userCardInfoStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget sadFace() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.face_rounded,
            size: 100,
            color: gray,
          ),
          AutoSizeText(
            'No user selected',
            maxFontSize: 15,
            style: subTitle.copyWith(color: gray),
          ),
        ],
      ),
    );
  }

  Widget getUserIconName(String name) {
    return Container(
      height: height * 0.15,
      width: height * 0.15,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Center(
          child: AutoSizeText(
            '${name[0]}${name.split(' ')[1][0]}'.toUpperCase(),
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
