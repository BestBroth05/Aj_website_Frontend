import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/GeneratePageRoute.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/sideMenu.dart';
import 'package:guadalajarav2/utils/tools.dart';

bool alreadySearching = false;

class MainScreen extends StatefulWidget {
  final Widget display;

  MainScreen({required this.display});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget? display;

  @override
  void initState() {
    super.initState();
    display = widget.display;

    Timer(Duration(milliseconds: 1), () async {
      if (user == null && !alreadySearching) {
        //   print('varias');
        //   alreadySearching = true;
        //   User? tempUser = await getUserFromToken(context);
        setState(() {
          user = null;
        });
        //   alreadySearching = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: height * 0.05,
            color: darkNight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'AJ Electronic Design - ${RoutesName.getCurrent()}',
                        style: TextStyle(
                          color: white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: darkNight,
                border: Border.all(
                  color: darkNight,
                ),
              ),
              child: Row(
                children: [
                  SideMenu(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedSideMenuButton != 3
                            ? backgroundColor
                            : white,
                        border: null,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      child: display!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
