// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Quotes/DesplegableQuotes.dart';
import 'package:guadalajarav2/views/admin_view/admin_Customers/CustomersView.dart';
import '../../../utils/colors.dart';
import '../../../views/admin_view/Tools.dart';
import '../../../views/admin_view/admin_Customers/EditCustomer.dart';
import '../../../views/Delivery_Certificate/widgets/Popups.dart';
import '../../../views/Delivery_Certificate/admin_OC/AddOC.dart';
import '../../../views/Delivery_Certificate/admin_OC/OCList.dart';
import '../../../views/Delivery_Certificate/widgets/customCircleAvatar.dart';

class CustomTableCustomerTile extends StatefulWidget {
  CustomersClass customers;
  final Map<String, int> attributesFlex;
  final bool isOdd;
  final bool isOC;
  CustomTableCustomerTile(this.customers,
      {Key? key,
      this.isOdd = true,
      required this.attributesFlex,
      required this.isOC})
      : super(key: key);

  @override
  State<CustomTableCustomerTile> createState() =>
      _CustomTableCustomerTileState();
}

class _CustomTableCustomerTileState extends State<CustomTableCustomerTile> {
  Color get color => widget.isOdd ? backgroundColor : white;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: color,
      child: Row(
        children: widget.attributesFlex.entries.map(
          (e) {
            String key = e.key;
            int flex = e.value;

            return Expanded(
              flex: flex,
              child: Container(
                  height: 75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                      color: gray,
                    )),
                  ),
                  child: key == 'logo'
                      ? CustomCicleAvatar(
                          convertListToInt(widget.customers.logo!))
                      : key == 'name'
                          ? AutoSizeText(
                              widget.customers.name.toString(),
                              textAlign: TextAlign.center,
                            )
                          : widget.isOC
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => OCList(
                                                      id_customer: widget
                                                          .customers
                                                          .id_customer!,
                                                      customerName: widget
                                                          .customers.name!)));
                                        },
                                        icon: Icon(Icons.view_headline)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddOC(
                                                      id_customer: widget
                                                          .customers
                                                          .id_customer!)));
                                        },
                                        icon: Icon(Icons.add)),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Certificados de entrega
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => OCList(
                                                      id_customer: widget
                                                          .customers
                                                          .id_customer!,
                                                      customerName: widget
                                                          .customers.name!)));
                                        },
                                        icon: Icon(Icons.delivery_dining)),
                                    //Quotes
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DesplegableQuotes(
                                                          customer: widget
                                                              .customers)));
                                        },
                                        icon: Icon(Icons.price_check)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditCustomer(
                                                          id_customer: widget
                                                              .customers
                                                              .id_customer!)));
                                        },
                                        icon: Icon(Icons.edit)),

                                    //Delete
                                    IconButton(
                                        onPressed: () =>
                                            confirmationDeleteCustomer(
                                                context,
                                                widget.customers.id_customer!,
                                                "customer",
                                                CustomersView()),
                                        icon: Icon(Icons.delete)),
                                  ],
                                )),
            );
          },
        ).toList(),
      ),
    );
  }
}
