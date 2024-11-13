import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/CustomClasses/gradientIcon.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/GeneratePageRoute.dart';
import 'package:guadalajarav2/administration/adminView.dart';
import 'package:guadalajarav2/classes/user.dart';
import 'package:guadalajarav2/administration/user/userPermissions.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'package:guadalajarav2/views/login/loginController.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/mainScreen.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

int get selectedSideMenuButton {
  return RoutesName.getMainMenuRoutes().indexOf(RoutesName.current) + 1;
}

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Color buttonColor = backgroundColor;
  Color sideMenuColor = darkNight;

  List<IconData> icons = [
    Icons.bento_rounded,
    Icons.inventory_2_rounded,
    Icons.admin_panel_settings,
    Icons.assignment_rounded,
    Icons.attach_money_rounded,
  ];

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1), () async {
      if (user == null && !alreadySearching) {
        User? usertemp = await getUserFromToken();
        this.setState(() {
          if (usertemp != null) {
            user = usertemp;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container(
        width: width * 0.04,
        height: height,
        color: darkNight,
      );
    }

    return Container(
      width: width * 0.04,
      height: height,
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            flex: 95,
            child: Container(
              child: Column(
                children: createselectedSideMenuButtonDesign(),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                border: null,
                color: sideMenuColor,
              ),
              child: sideMenuButton(
                route: AJRoute.home.url,
                icon: Icons.settings_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> createselectedSideMenuButtonDesign() {
    int buttonSize = 2;

    List<Widget> children = [];

    List<Widget> topColumn = [];
    List<Widget> bottomColumn = [];

    Set<String> routes = {};

    for (UserPermission permission in user!.permissions) {
      routes.addAll(permission.routes);
    }

    for (int i = 0; i < selectedSideMenuButton; i++) {
      if (i == 0) {
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
              route: routes.elementAt(i - 1),
              icon: icons[i - 1],
              index: i,
            ),
          ),
        );
      }
    }
    for (int i = selectedSideMenuButton + 1; i <= routes.length + 20; i++) {
      if (i >= routes.length + 1) {
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
              route: routes.elementAt(i - 1),
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
            border: null,
            color: sideMenuColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(
                10,
              ),
            ),
          ),
          child: Column(
            children: topColumn,
          ),
        ),
      ),
    );
    if (selectedSideMenuButton > 0) {
      children.add(
        Expanded(
          flex: buttonSize,
          child: Container(
            color: buttonColor,
            child: sideMenuButton(
              route: routes.elementAt(selectedSideMenuButton - 1),
              icon: icons[selectedSideMenuButton - 1],
              index: selectedSideMenuButton,
            ),
          ),
        ),
      );
    }

    children.add(
      Expanded(
        flex: (bottomColumn.length - 20) * buttonSize + 20,
        child: Container(
          decoration: BoxDecoration(
            border: null,
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

  TextButton sideMenuButton(
      {required String route, required IconData icon, int? index}) {
    return TextButton(
      child: Center(
        // child: Icon(
        //   icon,
        //   color: index != null && index == selectedSideMenuButton
        //       ? sideMenuColor
        //       : white,
        // ),
        child: GradientIcon(
          icon: icon,
          size: 25,
          gradient: index != null && index == selectedSideMenuButton
              ? linearGradient(
                  colors: [addColor(darkNight, white, 0.5), darkNight],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : linearGradient(
                  colors: [white, addColor(darkNight, white, 0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
      ),
      onPressed: () async {
        if (index == null) {
          logout(context);
        }
        changeScreen(context, route);
        mainState!.setState(() {
          // if (route != RoutesName.INVENTORY) {
          //   floatingButton = null;
          // }
        });
      },
    );
  }
}
