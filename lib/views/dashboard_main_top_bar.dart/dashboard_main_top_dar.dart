import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/user/userType.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/inventory/digikey_api_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_top_bar_button.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:guadalajarav2/views/login/loginController.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardTopBar extends StatefulWidget {
  final int selected;
  DashboardTopBar({
    Key? key,
    required this.selected,
  }) : super(key: key);

  @override
  State<DashboardTopBar> createState() => _DashboardTopBarState();
}

class _DashboardTopBarState extends State<DashboardTopBar> {
  List<String> get options => user == null
      ? []
      : user!.type == UserType.admin || user!.type == UserType.employee
          ? ['Dashboard', 'Inventory', 'BOM', 'Projects', 'Admin']
          : ['Projects'];
  List<AJRoute> get routes => user == null
      ? []
      : user!.type == UserType.admin || user!.type == UserType.employee
          ? [
              AJRoute.dashboard,
              AJRoute.inventory,
              AJRoute.bom,
              AJRoute.projects,
              AJRoute.admin,
            ]
          : [AJRoute.projects];

  @override
  void initState() {
    super.initState();
    if (user == null) {
      Timer(Duration(seconds: 1), () => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: width,
      color: white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: CustomButton(
              text: 'Log out',
              color: teal.add(black, 0.3),
              onPressed: () => logout(),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              user != null && user!.type == UserType.admin
                  ? options.length
                  : user == null
                      ? 0
                      : user!.type == UserType.employee
                          ? options.length - 1
                          : options.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: DashboardTopBarButton(
                  options[index],
                  isPressed: widget.selected == index,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    routes[index].url,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logout() async {
    removeTokenFromDatabase(context, token!);
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('token')) {
      _preferences.remove('token');
    }
    token = null;
    user = null;
    print('[WEBSITE] Logged out');
    openLink(context, AJRoute.home.url, isRoute: true);
  }
}
