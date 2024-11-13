import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/admin_view/admin_calendar_view/admin_calendar.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';

class AdminCalendarView extends StatefulWidget {
  AdminCalendarView({Key? key}) : super(key: key);

  @override
  State<AdminCalendarView> createState() => _AdminCalendarViewState();
}

class _AdminCalendarViewState extends State<AdminCalendarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DashboardTopBar(selected: 4),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Card(
                color: backgroundColor,
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: [
                              IconButton(
                                splashRadius: 15,
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: teal.add(black, 0.3),
                                ),
                                onPressed: () => openLink(
                                  context,
                                  AJRoute.admin.url,
                                  isRoute: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 28, child: AdminCalendar()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
