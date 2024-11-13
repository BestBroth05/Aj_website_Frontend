import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/Movements/movement.dart';
import 'package:guadalajarav2/administration/Movements/movementCard.dart';
import 'package:guadalajarav2/administration/Movements/movementType.dart';
import 'package:guadalajarav2/administration/adminView.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class MovementsView extends StatefulWidget {
  @override
  _MovementsState createState() => _MovementsState();
}

class _MovementsState extends State<MovementsView> {
  Color primaryColor = darkNight;

  static int selectedSection = -1;
  static int selectedMovement = -1;

  double widthOpen = width * 0.2;
  double widthClose = width * 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 1), () async {
      List<Movement> moves = await getAllMovements(context);

      setState(() {
        movements = moves;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [sectionButton('All', -1)];
    for (int i = 0; i < MovementGType.values.length; i++) {
      tabs.add(sectionButton(MovementGType.values[i].name, i));
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

    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: Padding(
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
                              'Movements',
                              style: subTitle2,
                            ),
                          ),
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
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int row) =>
                            movementTile(row),
                        itemCount: movements.length,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          VerticalDivider(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedContainer(
              width: selectedMovement != -1 ? widthOpen : widthClose,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: selectedMovement > -1
                  ? MovementCard(movement: movements[selectedMovement])
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget movementTile(int index) {
    bool isSelected = index == selectedMovement;
    return Card(
      color: isSelected ? primaryColor : white,
      elevation: 5,
      child: ListTile(
        onTap: () => setState(() {
          if (isSelected) {
            selectedMovement = -1;
          } else {
            selectedMovement = index;
          }
        }),
        contentPadding: EdgeInsets.zero,
        title: Container(
          height: height * 0.05,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Icon(
                  movements[index].type.icon,
                  color: isSelected ? white : primaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.005),
                child: VerticalDivider(
                  width: 0,
                  color: isSelected ? white : lightDarkGrey,
                ),
              ),
              Expanded(
                flex: 95,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        movements[index].subtype.name,
                        maxLines: 1,
                        style: movementTileTypeStyle.copyWith(
                          color:
                              isSelected ? white : movementTileTypeStyle.color,
                        ),
                      ),
                      AutoSizeText(
                        'Date: ${movements[index].date} | User: ${movements[index].username}',
                        maxLines: 1,
                        style: movementTileDateStyle.copyWith(
                          color:
                              isSelected ? white : movementTileDateStyle.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionButton(String title, int index) {
    return Theme(
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
          });
        },
      ),
    );
  }
}
