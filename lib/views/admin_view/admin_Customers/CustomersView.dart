import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:guadalajarav2/views/admin_view/admin_Customers/AddCustomer.dart';
import 'package:guadalajarav2/views/admin_view/admin_Customers/CustomersList.dart';
import '../../dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import '../AdminWidgets/Title.dart';

class CustomersView extends StatefulWidget {
  const CustomersView({super.key});

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DashboardTopBar(selected: 4),
        Container(
            margin: EdgeInsets.only(top: 75),
            child: TitleH1(context, "Customers")),
        Container(
          margin: EdgeInsets.only(right: 20, bottom: 20),
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCustomer()),
            ),
            child: Icon(Entypo.plus),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 125),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 220,
            child: Container(
                margin: EdgeInsets.only(top: 20), child: CustomersList()),
          ),
        )
      ],
    );
  }
}
