// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';

import '../../utils/colors.dart';
import '../admin_view/AdminWidgets/Title.dart';
import '../admin_view/admin_DeliverCertificate/LoadingData.dart';
import 'QuoteType.dart';
import 'Quotes.dart';
import 'TableQuotes.dart';

class DesplegableQuotes extends StatefulWidget {
  CustomersClass customer;
  DesplegableQuotes({super.key, required this.customer});

  @override
  State<DesplegableQuotes> createState() => _DesplegableQuotesState();
}

class _DesplegableQuotesState extends State<DesplegableQuotes> {
  bool isAllCustomersLoaded = false;
  bool areThereData = false;
  List<QuoteClass> quotes = [];

  getAllQuotes() async {
    List<QuoteClass> quotes1 =
        await DataAccessObject.getQuotesByCustomer(widget.customer.id_customer);
    setState(() {
      if (quotes1.isNotEmpty) {
        areThereData = true;
      }
      quotes = quotes1;
      isAllCustomersLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: teal.add(black, 0.3),
          title: TitleH1(context, "${widget.customer.name} Quotations"),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CotizacionesHome()));
              },
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        QuoteType(customer: widget.customer)));
          },
          foregroundColor: Colors.white,
          backgroundColor: teal,
          shape: const CircleBorder(),
          child: Icon(Icons.add),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 15),
            child: isAllCustomersLoaded
                ? areThereData
                    ? TableQuotes(
                        customer: widget.customer,
                        quotes: quotes,
                        isOC: false,
                      )
                    : NoData()
                : LoadingData()));
  }

  Widget NoData() {
    return Center(
      child: Text("No Data"),
    );
  }
}
