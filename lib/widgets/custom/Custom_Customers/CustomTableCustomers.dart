// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';

import '../../../utils/colors.dart';
import 'CustomTableCustomerTile.dart';

class CustomTableCustomers extends StatefulWidget {
  bool isOC;
  List<CustomersClass> customers;
  CustomTableCustomers(
      {super.key, required this.customers, required this.isOC});

  @override
  State<CustomTableCustomers> createState() => _CustomTableCustomersState();
}

class _CustomTableCustomersState extends State<CustomTableCustomers> {
  Map<String, int> headers = {'logo': 1, 'name': 3, 'actions': 2};
  @override
  Widget build(BuildContext context) {
    return widget.customers.isEmpty
        ? Center(child: Text("No Data"))
        : Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: teal.add(black, 0.3),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                ),
                child: Row(
                  children: headers.entries
                      .map(
                        (e) => Expanded(
                          flex: e.value,
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                left: e.key != 'id'
                                    ? BorderSide(
                                        color: white,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: AutoSizeText(
                              e.key.split('_').join(' ').toTitle(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: white),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                  child: ListView.separated(
                    itemCount: widget.customers.length,
                    itemBuilder: (context, i) => CustomTableCustomerTile(
                      widget.customers[i],
                      attributesFlex: headers,
                      isOdd: i % 2 != 0,
                      isOC: widget.isOC,
                    ),
                    separatorBuilder: (context, index) => Container(height: 2),
                  ),
                ),
              )
            ],
          );
  }
}
