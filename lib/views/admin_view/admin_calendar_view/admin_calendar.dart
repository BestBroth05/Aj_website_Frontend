import 'package:flutter/material.dart';
import 'package:guadalajarav2/widgets/custom/calendar/calendar.dart';

class AdminCalendar extends StatefulWidget {
  AdminCalendar({Key? key}) : super(key: key);

  @override
  State<AdminCalendar> createState() => _AdminCalendarState();
}

class _AdminCalendarState extends State<AdminCalendar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Calendar(),
      ),
    );
  }
}
