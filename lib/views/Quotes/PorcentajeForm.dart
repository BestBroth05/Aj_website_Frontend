// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:guadalajarav2/utils/SuperGlobalVariables/ObjVar.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Quotes/Clases/PorcentajesClass.dart';
import '../../utils/colors.dart';
import '../Delivery_Certificate/widgets/Popups.dart';
import '../Delivery_Certificate/widgets/Texts.dart';
import '../Delivery_Certificate/widgets/deliverFieldWidget.dart';
import 'Quotes.dart';

class PorcentajesForm extends StatefulWidget {
  CustomersClass? customer;
  PorcentajesForm({super.key, this.customer});

  @override
  State<PorcentajesForm> createState() => _PorcentajesFormState();
}

class _PorcentajesFormState extends State<PorcentajesForm> {
  List<PorcentajesClass> porcentajes = [];
  TextEditingController iva = TextEditingController();
  TextEditingController isr = TextEditingController();
  TextEditingController dhlComponent = TextEditingController();
  TextEditingController dhlPCB = TextEditingController();
  TextEditingController dhlAssambly = TextEditingController();
  TextEditingController liberation = TextEditingController();
  TextEditingController ajComponents = TextEditingController();
  TextEditingController ajDigikey = TextEditingController();
  TextEditingController ajPCB = TextEditingController();
  TextEditingController ajEnsamble = TextEditingController();
  ValueChanged<String>? onChanged;
  bool isNew = false;
  @override
  void initState() {
    super.initState();
    getPorcentajes();
  }

  getPorcentajes() async {
    List<PorcentajesClass> porcentajes1 =
        await DataAccessObject.selectPorcentajesByCustomer(
            widget.customer!.id_customer);
    setState(() {
      if (porcentajes1.isNotEmpty) {
        porcentajes = porcentajes1;
        ajComponents.text = porcentajes1[0].ajComponents.toString();
        ajDigikey.text = porcentajes1[0].ajDigikey.toString();
        ajPCB.text = porcentajes1[0].ajPCB.toString();
        ajEnsamble.text = porcentajes1[0].ajEnsamble.toString();
        iva.text = porcentajes1[0].iva.toString();
        isr.text = porcentajes1[0].isr.toString();
        dhlComponent.text = porcentajes1[0].dhlComponent.toString();
        dhlPCB.text = porcentajes1[0].dhlPCB.toString();
        dhlAssambly.text = porcentajes1[0].dhlAssambly.toString();
        liberation.text = porcentajes1[0].liberation.toString();
      } else {
        isNew = true;
        ajComponents.text = "1.1";
        ajDigikey.text = "1.18";
        ajPCB.text = "3.35";
        ajEnsamble.text = "1.4";
        iva.text = "1.16";
        isr.text = "1.32";
        dhlComponent.text = "0";
        dhlPCB.text = "0";
        dhlAssambly.text = "0";
        liberation.text = "0.19";
      }
    });
  }

  updateOrPostPorcentajes() {
    if (isNew) {
      postPorcentajes();
    } else {
      updatePorcentajes();
    }
  }

  updatePorcentajes() async {
    double dhlC =
        double.parse(dhlComponent.text) / double.parse(currentUser.dollarSell);
    double dhlP =
        double.parse(dhlPCB.text) / double.parse(currentUser.dollarSell);
    double dhlA =
        double.parse(dhlAssambly.text) / double.parse(currentUser.dollarSell);
    try {
      int code = await DataAccessObject.updatePorcentajes(
          porcentajes[0].id_porcentaje,
          widget.customer!.id_customer,
          double.parse(iva.text),
          double.parse(isr.text),
          dhlC,
          dhlP,
          dhlA,
          double.parse(liberation.text),
          double.parse(ajComponents.text),
          double.parse(ajDigikey.text),
          double.parse(ajPCB.text),
          double.parse(ajEnsamble.text));
      if (code != 200) {
        wrongPopup(context, "Error to send percentage");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => CotizacionesHome()),
            (route) => false);
      }
    } catch (e) {
      wrongPopup(context, "Error to send percentage");
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
    }
  }

  postPorcentajes() async {
    double dhlC =
        double.parse(dhlComponent.text) / double.parse(currentUser.dollarSell);
    double dhlP =
        double.parse(dhlPCB.text) / double.parse(currentUser.dollarSell);
    double dhlA =
        double.parse(dhlAssambly.text) / double.parse(currentUser.dollarSell);
    try {
      int code = await DataAccessObject.postPorcentajes(
          widget.customer!.id_customer,
          double.parse(iva.text),
          double.parse(isr.text),
          dhlC,
          dhlP,
          dhlA,
          double.parse(liberation.text),
          double.parse(ajComponents.text),
          double.parse(ajDigikey.text),
          double.parse(ajPCB.text),
          double.parse(ajEnsamble.text));
      if (code != 200) {
        wrongPopup(context, "Error to send percentage");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => CotizacionesHome()),
            (route) => false);
      }
    } catch (e) {
      wrongPopup(context, "Error to send percentage");
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
    }
  }

  operationComponentsEmpty() {
    return onChanged = (value) {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: teal.add(black, 0.3),
        foregroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          "${widget.customer!.name} Percentages",
          style: titleh1,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fieldPercentages(
                        iva,
                        Icon(Icons.percent),
                        "IVA",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                    fieldPercentages(
                        isr,
                        Icon(Icons.percent),
                        "ISR",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                    fieldPercentages(
                        dhlComponent,
                        Icon(FontAwesome.dollar),
                        "DHL Cost Component (MXN)",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                    fieldPercentages(
                        dhlPCB,
                        Icon(FontAwesome.dollar),
                        "DHL Cost PCB (MXN)",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                    fieldPercentages(
                        dhlAssambly,
                        Icon(FontAwesome.dollar),
                        "DHL Cost Assambly (MXN)",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                    fieldPercentages(
                        liberation,
                        Icon(Icons.percent),
                        "Release",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.teal,
                  margin: EdgeInsets.only(top: 0, bottom: 25),
                  child: Text("AJ Percentages",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fieldPercentages(
                        ajComponents,
                        Icon(Icons.percent),
                        "AJ Components",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                    fieldPercentages(
                        ajDigikey,
                        Icon(Icons.percent),
                        "AJ Digikey",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                    fieldPercentages(
                        ajPCB,
                        Icon(Icons.percent),
                        "AJ PCB",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                    fieldPercentages(
                        ajEnsamble,
                        Icon(Icons.percent),
                        "AJ Assambly",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        200),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white),
                onPressed: () => updateOrPostPorcentajes(),
                child: Text("Apply")),
          )
        ],
      ),
    );
  }
}
