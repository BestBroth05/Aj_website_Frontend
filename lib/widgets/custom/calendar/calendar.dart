import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/widgets/custom/calendar/calendar_box_date.dart';
import 'package:guadalajarav2/widgets/custom/calendar/calendar_side_panel.dart';
import 'package:guadalajarav2/widgets/custom/calendar/calendar_utils/enum_date.dart';

class Calendar extends StatefulWidget {
  Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  double width = 0;
  double height = 0;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 25,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CalendarSidePanel(
                date,
                changeDate: (newDate) => changeDate(newDate),
              ),
            ),
          ),
          Expanded(
            flex: 75,
            child: _CalendarMonth(
              date,
              changeDate: (newDate) => changeDate(newDate),
            ),
          ),
        ],
      ),
    );
  }

  void changeDate(DateTime newDate) => setState(() => date = newDate);
}

class _CalendarMonth extends StatelessWidget {
  final DateTime date;
  final Function(DateTime newDate) changeDate;
  _CalendarMonth(
    this.date, {
    Key? key,
    required this.changeDate,
  }) : super(key: key);

  final TextStyle dayNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    CalendarMonths month = months[date.month - 1];
    int offset = DateTime(date.year, date.month, 1).weekday - 1;
    int days = month.days(date.year) + offset;

    List<List<Widget>> rows = generateRows(days, offset);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                children: CalendarDays.values
                    .map(
                      (e) => Expanded(
                        child: Center(
                          child: AutoSizeText(
                            e.name.substring(0, 3).toUpperCase(),
                            style: dayNameStyle,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: rows
                      .map(
                        (row) => Expanded(
                          child: Row(
                            children: row.map((widget) => widget).toList(),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<List<Widget>> generateRows(int days, int offset) {
    List<List<Widget>> rows = [];
    for (int i = 0; i < days; i += 7) {
      List<Widget> row = [];
      for (int j = 1; j <= 7; j++) {
        int day = i + j - offset;
        DateTime _date = DateTime(date.year, date.month, day);
        bool inCurrMonth = day > 0 && day <= (days - offset);

        bool isSelected = _date.day == date.day && inCurrMonth;

        Color? color = isSelected ? Colors.teal : null;

        row.add(
          Expanded(
            child: CalendarBoxDate(
              _date,
              changeDate: changeDate,
              inMonth: inCurrMonth,
              color: color,
              isCurrDate: DateTime(_date.year, _date.month, _date.day) ==
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day),
            ),
          ),
        );
      }
      rows.add(row);
    }
    return rows;
  }
}
