// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/admin_view/admin_DeliverCertificate/LoadingData.dart';

import '../../../utils/colors.dart';
import '../../../views/Delivery_Certificate/Controllers/DAO.dart';
import '../../../views/Delivery_Certificate/adminClases/OrdenCompraClass.dart';
import '../../../views/Delivery_Certificate/adminClases/productClass.dart';
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

  List<Icon> statusList = [
    Icon(Fontelico.spin3, color: Colors.orange),
    Icon(FontAwesome.ok, color: Colors.green)
  ];
  String currentStatusProducts = "0/0";
  Icon currentStatusIcon = Icon(Fontelico.spin3, color: Colors.orange);
  bool isLoading = true;
  Map<String, List<OrdenCompraClass>> ordenesPorConsumidor = {};
  List<Icon> statusListPerCustomer = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await getStatus();
    setState(() {
      isLoading = false;
    });
  }

  Future<List<OrdenCompraClass>> getOCPerCustomer(id_customer) async {
    List<OrdenCompraClass> OC1 =
        await DataAccessObject.selectOCCustomer(id_customer);
    return OC1;
  }

  void addOrder(String consumidor, List<OrdenCompraClass> ordenCompra) {
    ordenesPorConsumidor.putIfAbsent(consumidor, () => ordenCompra);
  }

  getStatus() async {
    //List OC per customer
    bool isAllDelivered = false;
    for (var customer in widget.customers) {
      addOrder(customer.name!, await getOCPerCustomer(customer.id_customer));
    }
    print(ordenesPorConsumidor);
    for (var entry in ordenesPorConsumidor.entries) {
      if (entry.value.isNotEmpty) {
        for (var i = 0; i < entry.value.length; i++) {
          int totalProducts = 0;
          List<ProductCertificateDelivery> products1 =
              await DataAccessObject.selectProductPerOC(entry.value[i].id_OC);
          if (products1.isNotEmpty) {
            for (var i = 0; i < products1.length; i++) {
              totalProducts = totalProducts + products1[i].cantidad!;
            }
          }
          currentStatusProducts = "${totalProducts}/${entry.value[i].cantidad}";
          if (totalProducts == entry.value[i].cantidad!) {
            isAllDelivered = true;
          } else {
            isAllDelivered = false;
            break;
          }
        }
        //Todo entregado
        if (isAllDelivered) {
          statusListPerCustomer.add(statusList[1]);
        }
        //Por entregar
        else {
          statusListPerCustomer.add(statusList[0]);
        }
      }
      //Lista vacia
      else {
        statusListPerCustomer
            .add(Icon(Icons.hourglass_empty, color: Colors.grey));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.customers.isEmpty
        ? Center(child: Text("No Data"))
        : isLoading
            ? LoadingData()
            : Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: teal.add(black, 0.3),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
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
                          status: statusListPerCustomer[i],
                          widget.customers[i],
                          attributesFlex: headers,
                          isOdd: i % 2 != 0,
                          isOC: widget.isOC,
                        ),
                        separatorBuilder: (context, index) =>
                            Container(height: 2),
                      ),
                    ),
                  )
                ],
              );
  }
}
