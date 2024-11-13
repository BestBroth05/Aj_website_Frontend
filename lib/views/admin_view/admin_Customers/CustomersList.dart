import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../widgets/custom/Custom_Customers/CustomTableCustomers.dart';
import '../../Delivery_Certificate/Controllers/DAO.dart';
import '../../Delivery_Certificate/adminClases/CustomerClass.dart';
import '../admin_DeliverCertificate/LoadingData.dart';

class CustomersList extends StatefulWidget {
  const CustomersList({super.key});

  @override
  State<CustomersList> createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  List<CustomersClass> customers = [];
  List<Uint8List> images = [];
  bool isAllCustomersLoaded = false;
  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return !isAllCustomersLoaded
        ? LoadingData()
        : CustomTableCustomers(customers: customers, isOC: false);
  }

  getCustomers() async {
    List<CustomersClass> customers1 = await DataAccessObject.getCustomer();
    setState(() {
      customers = customers1;
      isAllCustomersLoaded = true;
    });
  }
}
//convertListToInt(customers[i].logo!)