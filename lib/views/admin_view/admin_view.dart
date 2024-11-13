import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/views/admin_view/admin_menu_view/admin_menu_view.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';

class AdminView extends StatefulWidget {
  AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          DashboardTopBar(selected: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(elevation: 5, child: AdminMenuView()),
            ),
          ),
        ],
      ),
    );
  }
}
