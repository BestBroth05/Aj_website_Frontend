import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';

class AJCartDialogTile extends StatelessWidget {
  final Map<String, dynamic> part;
  final bool isOdd;
  AJCartDialogTile(
    this.part, {
    Key? key,
    this.isOdd = false,
  }) : super(key: key);

  final Map<String, int> headers = {
    'MPN': 2,
    'designator': 2,
    'description': 2,
    'manufacturer': 2,
    'provider': 2,
    'required': 1,
    'going to be used': 1,
    'total cost': 1,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: isOdd ? white : backgroundColor,
      child: Row(
        children: headers.entries.map((e) {
          String key = e.key.toLowerCase().split(' ').join('_');
          int flex = e.value;

          String value = part[key].toString();

          return Expanded(
            flex: flex,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: gray.add(white, 0.5),
                  ),
                ),
              ),
              child: Center(
                child: AutoSizeText(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: value == 'null' ? gray.add(white, 0.1) : black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
