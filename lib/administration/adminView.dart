import 'package:flutter/material.dart';
import 'package:guadalajarav2/CustomClasses/gradientIcon.dart';
import 'package:guadalajarav2/administration/ManageUsers/manageUsers.dart';
import 'package:guadalajarav2/administration/Movements/movement.dart';
import 'package:guadalajarav2/administration/Movements/movementsView.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/styles.dart';

List<User> users = [];
List<Movement> movements = [];
_AdminState adminState = _AdminState();

class AdminView extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<AdminView> {
  int selectedAdminButton = 1;

  Color buttonColor = white;
  Color sideMenuColor = backgroundColor;

  List<IconData> icons = [
    Icons.supervised_user_circle_rounded,
    Icons.receipt_rounded,
    Icons.verified_user_sharp,
    Icons.verified_user_sharp,
    Icons.verified_user_sharp,
  ];

  List<String> texts = [
    'Manage Users',
    'Movements',
    'Manage Users',
    'Manage Users',
    'Manage Users',
  ];
  List<Widget> displays = [
    ManageUsersScreen(),
    MovementsView(),
  ];

  @override
  void initState() {
    super.initState();
    adminState = this;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 95,
                    child: Column(
                      children: createselectedButtonDesign(),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: backgroundColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: selectedAdminButton <= displays.length
                ? displays[selectedAdminButton - 1]
                : Container(),
          ),
        ],
      ),
    );
  }

  List<Widget> createselectedButtonDesign() {
    int buttonSize = 2;

    List<Widget> children = [];

    List<Widget> topColumn = [];
    List<Widget> bottomColumn = [];

    for (int i = 0; i < selectedAdminButton; i++) {
      if (i <= 0) {
        topColumn.add(
          Expanded(
            child: Container(),
          ),
        );
      } else {
        topColumn.add(
          Expanded(
            flex: buttonSize,
            child: sideMenuButton(
              text: texts[i - 1],
              icon: icons[i - 1],
              index: i,
            ),
          ),
        );
      }
    }
    for (int i = selectedAdminButton + 1; i <= texts.length + 20; i++) {
      if (i >= texts.length + 1) {
        bottomColumn.add(
          Expanded(
            child: Container(),
          ),
        );
      } else {
        bottomColumn.add(
          Expanded(
            flex: buttonSize,
            child: sideMenuButton(
              text: texts[i - 1],
              icon: icons[i - 1],
              index: i,
            ),
          ),
        );
      }
    }

    children.add(
      Expanded(
        flex: (topColumn.length - 1) * buttonSize + 1,
        child: Container(
          decoration: BoxDecoration(
            color: sideMenuColor,
            border: Border.all(color: sideMenuColor),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(
                10,
              ),
              topLeft: Radius.circular(
                20,
              ),
            ),
          ),
          child: Column(
            children: topColumn,
          ),
        ),
      ),
    );

    children.add(
      Expanded(
        flex: buttonSize,
        child: Container(
          color: sideMenuColor,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              decoration: BoxDecoration(
                color: buttonColor,
                border: null,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    20,
                  ),
                  topLeft: Radius.circular(
                    20,
                  ),
                ),
              ),
              child: sideMenuButton(
                text: texts[selectedAdminButton - 1],
                icon: icons[selectedAdminButton - 1],
                index: selectedAdminButton,
              ),
            ),
          ),
        ),
      ),
    );

    children.add(
      Expanded(
        flex: (bottomColumn.length - 20) * buttonSize + 20,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: sideMenuColor),
            color: sideMenuColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                10,
              ),
            ),
          ),
          child: Column(
            children: bottomColumn,
          ),
        ),
      ),
    );

    return children;
  }

  Theme sideMenuButton(
      {required String text, required IconData icon, required int index}) {
    return Theme(
      data: ThemeData(splashColor: green),
      child: TextButton(
        child: Row(
          children: [
            Expanded(
              // child: Icon(
              //   icon,
              //   color: index == selectedAdminButton ? darkNight : gray,
              // ),
              child: GradientIcon(
                icon: icon,
                size: 22,
                gradient: linearGradient(
                  colors: index == selectedAdminButton
                      ? [darkNight, darkNight.withOpacity(0.5)]
                      : [gray, gray.withOpacity(0.5)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '$text',
                style: index == selectedAdminButton
                    ? adminSelectedButtonStyle
                    : adminButtonStyle,
              ),
            ),
          ],
        ),
        onPressed: () async {
          setState(() {
            selectedAdminButton = index;
          });
        },
      ),
    );
  }
}
