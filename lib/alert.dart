import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class AlertNotification extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String str;

  AlertNotification(
      {required this.icon, required this.color, required this.str});

  @override
  _AlertNotificationState createState() => _AlertNotificationState();
}

class _AlertNotificationState extends State<AlertNotification> {
  bool hasPressed = false;
  int counter = 300;
  int counterMax = 300;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
      if (hasPressed) {
        timer.cancel();
      } else {
        setState(() {
          counter -= 1;
        });

        // print(counter);
        if (counter == 0 && !hasPressed) {
          Navigator.pop(context);
          timer.cancel();
        }
      }
    });
  }

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
            flex: 39,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    10,
                  ),
                ),
                color: widget.color,
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  color: white,
                  size: height * 0.05,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: LinearProgressIndicator(
              color: Colors.black.withOpacity(0.3),
              backgroundColor: widget.color,
              value: counter / counterMax,
            ),
          ),
          Expanded(
            flex: 59,
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Center(
                      child: Text(
                        widget.str,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      hasPressed = true;
                    },
                    child: Text('ok'),
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
