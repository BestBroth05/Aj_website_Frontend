import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/widgets/custom/calendar/calendar_utils/enum_date.dart';

class CalendarSidePanel extends StatelessWidget {
  final DateTime date;
  final TextStyle monthStyle = TextStyle(
    fontSize: 20,
  );
  final TextStyle yearStyle = TextStyle(
    fontSize: 20,
  );

  final Function(DateTime newDate) changeDate;
  CalendarSidePanel(
    this.date, {
    Key? key,
    required this.changeDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                  child: _CalendarDateWidget(date),
                ),
                Expanded(
                  child: _CalendarNavButtons(
                    date,
                    changeDate: createDate,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 90, child: Container()),
        ],
      ),
    );
  }

  void createDate({int? year, int? month, int? day}) {
    year = year ?? date.year;
    month = month ?? date.month;
    day = day ?? date.day;
    if (month < 1) {
      year -= 1;
      month = 12;
    } else if (month > 12) {
      year += 1;
      month = 1;
    }
    if (day > months[month - 1].days(year)) {
      day = months[month - 1].days(year);
    }

    DateTime newDate = DateTime(year, month, day);

    changeDate(newDate);
  }
}

class _ArrowButton extends StatelessWidget {
  final bool isLeft;
  final VoidCallback onPressed;
  const _ArrowButton({
    Key? key,
    this.isLeft = true,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      onPressed: onPressed,
      icon: Icon(
        isLeft ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
      ),
    );
  }
}

class _CalendarDateWidget extends StatelessWidget {
  final DateTime date;
  _CalendarDateWidget(this.date, {Key? key}) : super(key: key);

  final TextStyle dayStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 50,
  );
  final TextStyle otherStyle = TextStyle(
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    String day = '${date.day}'.padLeft(2, '0');
    String month = months[date.month - 1].name;
    String year = date.year.toString();
    String weekday = weekdays[date.weekday - 1].name;

    return Container(
      child: Row(
        children: [
          Text('$day', style: dayStyle),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText('$month $year'.toTitle(), style: otherStyle),
                  AutoSizeText('$weekday'.toTitle(), style: otherStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarNavButtons extends StatelessWidget {
  final DateTime date;
  final Function({int? year, int? month, int? day}) changeDate;

  const _CalendarNavButtons(
    this.date, {
    Key? key,
    required this.changeDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime currDate = DateTime.now();

    return Container(
        child: Row(
      children: [
        _ArrowButton(
          onPressed: () => changeDate(month: date.month - 1),
        ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: AutoSizeText(
              'Today',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => changeDate(
              year: currDate.year,
              month: currDate.month,
              day: currDate.day,
            ),
          ),
        ),
        _ArrowButton(
          isLeft: false,
          onPressed: () => changeDate(month: date.month + 1),
        ),
      ],
    ));
  }
}
