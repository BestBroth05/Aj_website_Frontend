// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';

import '../../../../utils/colors.dart';
import '../../adminClases/CertificadoEntregaClass.dart';
import '../../adminClases/OrdenCompraClass.dart';
import 'CustomDesplegableTile.dart';

class CustomDesplegable extends StatefulWidget {
  String customerName;
  int id_customer;
  List<OrdenCompraClass> OC = [];
  List<List<ClassCertificadoEntrega>> EntregasGlobal = [];
  CustomDesplegable(
      {super.key,
      required this.EntregasGlobal,
      required this.OC,
      required this.id_customer,
      required this.customerName});

  @override
  State<CustomDesplegable> createState() => _CustomDesplegableState();
}

class _CustomDesplegableState extends State<CustomDesplegable> {
  List<OrdenCompraClass> OC = [];
  List<ClassCertificadoEntrega> Entrega = [];
  List<List<ClassCertificadoEntrega>> EntregasGlobal = [];
  String? date_start;
  bool isAllCustomersLoaded = false;
  bool areThereData = false;
  Map<String, int> headers = {
    'purchase order': 2,
    'date': 2,
    'actions': 2,
    'status': 1
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
              ),
              child: ListView.separated(
                itemCount: widget.OC.length,
                itemBuilder: (context, i) => CustomDesplegableTile(
                    widget.OC[i],
                    widget.EntregasGlobal[i],
                    widget.id_customer,
                    widget.customerName,
                    attributesFlex: headers,
                    isOdd: i % 2 != 0),
                separatorBuilder: (context, index) => Container(height: 2),
              ),
            ),
          )
        ],
      ),
    );
  }
}
