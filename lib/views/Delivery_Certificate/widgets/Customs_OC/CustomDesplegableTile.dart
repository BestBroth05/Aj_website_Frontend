// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/OrdenCompraClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/admin_OC/EditOC.dart';
import '../../../../utils/colors.dart';
import '../../Controllers/DAO.dart';
import '../../adminClases/CertificadoEntregaClass.dart';
import '../../adminClases/productClass.dart';
import '../Popups.dart';
import '../Texts.dart';
import '../../Entregas/AddEntrega.dart';
import '../../Entregas/EditEntrega.dart';
import '../../admin_OC/OCList.dart';

class CustomDesplegableTile extends StatefulWidget {
  String customerName;
  int id_customer;
  List<ClassCertificadoEntrega> EntregasGlobal = [];
  OrdenCompraClass OC;
  final Map<String, int> attributesFlex;
  final bool isOdd;
  CustomDesplegableTile(
      this.OC, this.EntregasGlobal, this.id_customer, this.customerName,
      {Key? key, this.isOdd = true, required this.attributesFlex})
      : super(key: key);

  @override
  State<CustomDesplegableTile> createState() => _CustomDesplegableTileState();
}

class _CustomDesplegableTileState extends State<CustomDesplegableTile> {
  Color get color => widget.isOdd ? backgroundColor : white;
  List<ProductCertificateDelivery> products = [];
  String? date_start;

  getProducts(id_entrega) async {
    List<ProductCertificateDelivery> products1 =
        await DataAccessObject.selectProductOC(id_entrega);
    setState(() {
      products = products1;
    });
  }

  @override
  void initState() {
    super.initState();
    List separated = widget.OC.fecha_inicio!.split("T");
    date_start = separated[0];
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(
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
                    child: key == 'actions'
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Add Button
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddEntrega(
                                                          id_OC:
                                                              widget.OC.id_OC!,
                                                          id_customer: widget
                                                              .id_customer)));
                                        },
                                        icon: Icon(Icons.add)),
                                    //Edit Button
                                    IconButton(
                                        onPressed: () async {
                                          List<OrdenCompraClass> OCList1 =
                                              await DataAccessObject.selectOC(
                                                  widget.OC.id_OC!);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EditOC(
                                                      OrdenCompra: OCList1[0],
                                                      id_customer:
                                                          widget.id_customer)));
                                        },
                                        icon: Icon(Icons.edit)),
                                    //Delete Button
                                    IconButton(
                                        onPressed: () =>
                                            confirmationDeleteCustomer(
                                                context,
                                                widget.OC.id_OC,
                                                "oc",
                                                OCList(
                                                    id_customer:
                                                        widget.id_customer,
                                                    customerName:
                                                        widget.customerName)),
                                        icon: Icon(Icons.delete)),
                                  ],
                                ),
                              )
                            ],
                          )
                        : key == "date"
                            ? AutoSizeText(
                                date_start!,
                                textAlign: TextAlign.center,
                              )
                            : AutoSizeText(
                                widget.OC.OC.toString(),
                                textAlign: TextAlign.center,
                              )),
              );
            },
          ).toList(),
        ),
      ),
      children: [
        DataTable(
            sortColumnIndex: 0,
            sortAscending: true,
            columns: <DataColumn>[
              DataColumn(
                  label: Text(
                'Certificate',
                style: fieldText,
                textAlign: TextAlign.center,
              )),
              DataColumn(
                  label: Text(
                '    Date',
                style: fieldText,
                textAlign: TextAlign.center,
              )),
              DataColumn(
                  label: Text(
                '          Action',
                style: fieldText,
                textAlign: TextAlign.center,
              )),
            ],
            rows: widget.EntregasGlobal.map<DataRow>(
                (ClassCertificadoEntrega entrega) {
              return DataRow(cells: <DataCell>[
                DataCell(Text(entrega.certificadoEntrega!)),
                DataCell(Text(entrega.Fecha!)),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Edit Button
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEntrega(
                                  id_customer: widget.id_customer,
                                  id_OC: widget.OC.id_OC!,
                                  id_entrega: entrega.certificadoEntrega!,
                                ),
                              ));
                        },
                        icon: Icon(Icons.edit)),
                    //Delete Button
                    IconButton(
                        onPressed: () => confirmationDeleteCustomer(
                            context,
                            entrega.id_Entrega,
                            "entrega",
                            OCList(
                                id_customer: widget.id_customer,
                                customerName: widget.customerName)),
                        icon: Icon(Icons.delete)),
                    //Download Buttons
                    IconButton(
                        onPressed: () async {
                          await getProducts(entrega.id_Entrega);

                          PDFLanguage(
                              context,
                              widget.OC.id_OC,
                              entrega,
                              widget.OC.OC,
                              widget.customerName,
                              products,
                              widget.OC.moneda);
                        },
                        // confirmationDeleteCustomer(context, id_customer),
                        icon: Icon(Icons.download)),
                  ],
                )),
              ]);
            }).toList())
      ],
    );
  }

  Widget tableEntrega() {
    return DataTable(
        sortColumnIndex: 0,
        sortAscending: true,
        columns: <DataColumn>[
          DataColumn(
              label: Text(
            'Certificado',
            style: fieldText,
            textAlign: TextAlign.center,
          )),
          DataColumn(
              label: Text(
            '    Fecha',
            style: fieldText,
            textAlign: TextAlign.center,
          )),
          DataColumn(
              label: Text(
            '          Accion',
            style: fieldText,
            textAlign: TextAlign.center,
          )),
        ],
        rows: widget.EntregasGlobal.map<DataRow>(
            (ClassCertificadoEntrega entrega) {
          return DataRow(cells: <DataCell>[
            DataCell(Text(entrega.certificadoEntrega!)),
            DataCell(Text(entrega.Fecha!)),
            DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Edit Button
                IconButton(
                    onPressed: () => EditEntrega(
                          id_customer: widget.id_customer,
                          id_OC: widget.OC.id_OC!,
                          id_entrega: entrega.certificadoEntrega!,
                        ),
                    icon: Icon(Icons.edit)),
                //Delete Button
                IconButton(
                    onPressed: () => confirmationDeleteCustomer(
                        context,
                        entrega.id_Entrega,
                        "entrega",
                        OCList(
                            id_customer: widget.id_customer,
                            customerName: widget.customerName)),
                    icon: Icon(Icons.delete)),
                IconButton(
                    onPressed: () {},
                    // confirmationDeleteCustomer(context, id_customer),
                    icon: Icon(Icons.download)),
              ],
            )),
          ]);
        }).toList());
  }
}
