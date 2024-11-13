import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/ManageUsers/addUser.dart';
import 'package:guadalajarav2/administration/ManageUsers/userCard.dart';
import 'package:guadalajarav2/administration/adminView.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsersScreen> {
  List<String> sections = ['All', 'Admins', 'Employees', 'Clients', 'Guests'];

  int userCardSize = 4;
  static int selectedSection = 0;
  static int selectedUser = -1;
  Color primaryColor = darkNight;

  double widthOpen = width * 0.3;
  double widthClose = width * 0.2;

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 10), () async {
      List<User> tempUsers = await getAllUsersInDatabase();
      setState(() {
        users = tempUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];
    for (int i = 0; i < sections.length; i++) {
      tabs.add(sectionButton(sections[i], i));
    }

    tabs.add(
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: primaryColor,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );

    if (users.isEmpty) {
      return Container();
    }

    return Container(
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: white,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025,
                  vertical: height * 0.025,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.01,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                'Users',
                                style: subTitle2,
                              ),
                            ),
                            addUserButton(),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Row(
                          children: tabs,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 92,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) =>
                              getTile(index * 2),
                          itemCount: (users.length / 2).ceil(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              width: selectedUser != -1 ? widthOpen : widthClose,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: UserCard(
                user: selectedUser != -1 ? users[selectedUser] : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addUserButton() {
    return ElevatedButton(
      onPressed: () => containerDialog(context, false, AddUserPopup(), 0.5),
      child: AutoSizeText('New User'),
    );
  }

  Widget sectionButton(String title, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.001),
      child: Theme(
        data: ThemeData(),
        child: TextButton(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: primaryColor,
                  width: selectedSection == index ? 2 : 1,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.01,
              ),
              child: Center(
                child: AutoSizeText(
                  '$title',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: primaryColor,
                    fontWeight: selectedSection == index
                        ? FontWeight.w800
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              selectedSection = index;
              selectedUser = -1;
            });
            List<User> refreshUsers = await getAllUsersInDatabase();

            adminState.setState(() {
              users = refreshUsers;
            });
          },
        ),
      ),
    );
  }

  Widget getUserIconName(String name, bool isSelected) {
    return Container(
      height: height * 0.04,
      width: height * 0.04,
      margin: EdgeInsets.symmetric(horizontal: width * 0.005),
      decoration: BoxDecoration(
        color: isSelected ? white : primaryColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Center(
          child: AutoSizeText(
            '${name[0]}${name.split(' ')[1][0]}'.toUpperCase(),
            style: TextStyle(
              color: isSelected ? primaryColor : white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getUserOverview(int index) {
    User user = users[index];
    bool isSelected = index == selectedUser;
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedUser = -1;
          } else {
            selectedUser = index;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: width * 0.01),
        height: height * 0.05,
        decoration: BoxDecoration(
          border:
              Border.all(color: isSelected ? primaryColor : backgroundColor),
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? primaryColor : Colors.transparent,
        ),
        child: Row(
          children: [
            getUserIconName(user.toString(), isSelected),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toTitle(user.toString()),
                    style: userTileNameStyle.copyWith(
                      color: isSelected ? white : userTileNameStyle.color,
                    ),
                  ),
                  Text(
                    user.type.name,
                    style: userTileTypeStyle.copyWith(
                      color: isSelected ? white : userTileTypeStyle.color,
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

  ListTile getTile(int index) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: getUserOverview(index),
          ),
          Expanded(
            child: index + 1 < users.length
                ? getUserOverview(index + 1)
                : Container(),
          ),
        ],
      ),
    );
  }
}

int get selectedSection {
  return _ManageUsersState.selectedSection;
}

set selectedUserInAdmin(int value) {
  _ManageUsersState.selectedUser = value;
}
