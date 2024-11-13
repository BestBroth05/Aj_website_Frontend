import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/administration/Movements/movement.dart';
import 'package:guadalajarav2/administration/Movements/movementType.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';

class MovementCard extends StatefulWidget {
  final Movement movement;

  MovementCard({required this.movement});

  @override
  _MovementCardState createState() => _MovementCardState();
}

class _MovementCardState extends State<MovementCard> {
  late Movement movement;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    movement = widget.movement;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: AutoSizeText(
                invertWords(movement.subtype.name),
                style: movementCardTitleStyle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.025),
            child: Divider(),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: AutoSizeText(
                '${movement.date}    ${movement.time}',
                style: movementCardDateTimeStyle,
              ),
            ),
          ),
          Expanded(
            flex: 94,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.05,
                horizontal: width * 0.025,
              ),
              child: Column(
                children: [
                  infoSection(
                    'Movement by',
                    movement.username,
                  ),
                  infoSection(
                    'Description',
                    movement.description,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoSection(String subtitle, String info) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Column(
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
      ),
    );
  }
}
