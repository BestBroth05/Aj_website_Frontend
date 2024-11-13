import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class AdminMenuView extends StatefulWidget {
  AdminMenuView({Key? key}) : super(key: key);

  @override
  State<AdminMenuView> createState() => _AdminMenuViewState();
}

class _AdminMenuViewState extends State<AdminMenuView> {
  Map<AJRoute, Map<String, dynamic>> routes = {
    AJRoute.adminCart: {
      'name': 'Cart',
      'icon': Icons.shopping_bag_outlined,
      'isHovering': false,
    },
    AJRoute.adminProjects: {
      'name': 'Projects',
      'icon': Icons.inventory_outlined,
      'isHovering': false,
    },
    AJRoute.adminUsers: {
      'name': 'Users',
      'icon': Icons.people_alt_rounded,
      'isHovering': false,
    },
    AJRoute.adminHistory: {
      'name': 'History',
      'icon': Icons.history,
      'isHovering': false,
    },
    AJRoute.adminCalendar: {
      'name': 'Calendar',
      'icon': Icons.calendar_month_rounded,
      'isHovering': false,
    },
    AJRoute.adminDeliverCertificate: {
      'name': 'Deliver Certificate',
      'icon': Icons.delivery_dining,
      'isHovering': false,
    },
    AJRoute.adminQuotes: {
      'name': 'Quotations',
      'icon': Icons.price_check,
      'isHovering': false,
    },
    AJRoute.adminAddCustomers: {
      'name': 'Customers',
      'icon': FontAwesome.building,
      'isHovering': false,
    },
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: SizedBox(
        width: width * 8,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: width / 4,
          ),
          itemCount: routes.length,
          itemBuilder:

              /*child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: List.generate(
            routes.length,*/
              (context, index) {
            AJRoute route = routes.keys.elementAt(index);
            String name = routes.values.elementAt(index)['name'];
            IconData icon = routes.values.elementAt(index)['icon'];
            bool isHovering = routes.values.elementAt(index)['isHovering'];

            return Container(
              margin: EdgeInsets.all(width * 0.02),
              child: InkWell(
                // style: ElevatedButton.styleFrom(primary: white),
                onTap: () => openLink(context, route.url, isRoute: true),
                onHover: (value) => setState(
                  () => routes.values.elementAt(index)['isHovering'] = value,
                ),
                child: Container(
                  width: width * 0.2,
                  height: width * 0.2,
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: isHovering ? 8 : 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          color: isHovering ? teal : gray,
                          size: width * 0.1,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AutoSizeText(
                          name,
                          style: TextStyle(
                            color: isHovering ? teal : gray,
                            fontSize: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          // ).toList(),
        ),
      ),
    );
  }
}
