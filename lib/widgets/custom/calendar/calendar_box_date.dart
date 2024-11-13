import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CalendarBoxDate extends StatelessWidget {
  final DateTime date;
  final Color? color;
  final bool inMonth;
  final bool isCurrDate;

  final Function(DateTime newDate) changeDate;

  const CalendarBoxDate(
    this.date, {
    Key? key,
    this.color,
    this.isCurrDate = false,
    this.inMonth = true,
    required this.changeDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => changeDate(date),
      iconSize: 60,
      splashRadius: 35,
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color != null ? color!.withOpacity(0.5) : null,
          border: isCurrDate ? Border.all(color: Colors.teal, width: 3) : null,
        ),
        child: Center(
          child: AutoSizeText(
            '${date.day}',
            style: TextStyle(
              color: inMonth && date.isAfter(DateTime.now()) || isCurrDate
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
