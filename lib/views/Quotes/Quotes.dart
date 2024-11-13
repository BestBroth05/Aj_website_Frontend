import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:guadalajarav2/utils/SuperGlobalVariables/ObjVar.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/widgets/deliverFieldWidget.dart';
import '../../utils/colors.dart';
import '../Delivery_Certificate/Controllers/DAO.dart';
import '../Delivery_Certificate/adminClases/CustomerClass.dart';
import '../admin_view/AdminWidgets/Title.dart';
import '../admin_view/admin_DeliverCertificate/LoadingData.dart';
import '../dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import 'TableCustomerQuotes.dart';

class CotizacionesHome extends StatefulWidget {
  const CotizacionesHome({super.key});

  @override
  State<CotizacionesHome> createState() => _CotizacionesHomeState();
}

class _CotizacionesHomeState extends State<CotizacionesHome> {
  List<CustomersClass> customers = [];
  Color backgroundColorButton = Colors.teal;
  bool isAllCustomersLoaded = false;
  TextEditingController dollarSell = TextEditingController();
  TextEditingController dollarBuy = TextEditingController();
  final _formKeyInformative = GlobalKey<FormState>();
  ValueChanged<String>? onChanged;
  @override
  void initState() {
    dollarSell.text = "20";
    dollarBuy.text = "18";
    super.initState();
    getCustomers();
  }

  sendValues(type) {
    return onChanged = (value) {
      setState(() {
        if (type == "sell") {
          currentUser.dollarSell = value;
        } else {
          currentUser.dollarBuy = value;
        }
      });
    };
  }

  getCustomers() async {
    List<CustomersClass> customers1 = await DataAccessObject.getCustomer();
    setState(() {
      customers = customers1;
      isAllCustomersLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DashboardTopBar(selected: 4),
          TitleH1(context, "Quotation"),
          Informative(),
          Container(
            height: 650,
            child: SetImages(),
          )
        ],
      ),
    );
  }

  Widget SetImages() {
    return !isAllCustomersLoaded
        ? LoadingData()
        : TableCustomerQuotes(
            customers: customers,
            isOC: false,
          );
  }

  Widget Informative() {
    return Form(
      key: _formKeyInformative,
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: teal.add(black, 0.3),
              child: Text("General data",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white)),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fieldQuotesOperations(
                          dollarSell,
                          "Dollar Sell",
                          TextInputType.numberWithOptions(decimal: true),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                          sendValues("sell"),
                          false),
                      fieldQuotesOperations(
                          dollarBuy,
                          "Dollar Buy",
                          TextInputType.numberWithOptions(decimal: true),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                          sendValues("buy"),
                          false),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
