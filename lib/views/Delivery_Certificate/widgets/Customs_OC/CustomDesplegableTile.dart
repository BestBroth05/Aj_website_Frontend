// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/OrdenCompraClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/admin_OC/EditOC.dart';
import '../../../../utils/colors.dart';
import '../../Controllers/DAO.dart';
import '../../adminClases/CertificadoEntregaClass.dart';
import '../../adminClases/productClass.dart';
import '../../../../Popups.dart';
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
  TextEditingController status = TextEditingController();
  int totalProducts = 0;
  String? date_start;
  List<Icon> statusList = [
    Icon(
      FontAwesome.attention,
      color: Colors.red,
    ),
    Icon(FontAwesome.ok, color: Colors.green),
    Icon(Fontelico.spin3, color: Colors.orange)
  ];
  Icon currentStatusIcon = Icon(Fontelico.spin3, color: Colors.orange);
  String currentStatusProducts = "0/0";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List separated = widget.OC.fecha_inicio!.split("T");
    date_start = separated[0];
    await getStatus();
    setState(() {
      isLoading = false;
    });
  }

  getProducts(id_entrega) async {
    List<ProductCertificateDelivery> products1 =
        await DataAccessObject.selectProductOC(id_entrega);

    setState(() {
      products = products1;
    });
  }

  Future updateOC(int status) async {
    int result = await DataAccessObject.updateOC(
        widget.OC.id_OC,
        widget.OC.id_customer,
        widget.OC.OC,
        widget.OC.fecha_inicio,
        widget.OC.fecha_fin,
        widget.OC.solicitante,
        widget.OC.pais,
        widget.OC.estado,
        widget.OC.ciudad,
        widget.OC.cp,
        widget.OC.street,
        widget.OC.prioridad,
        widget.OC.moneda,
        widget.OC.descripcion,
        widget.OC.cantidad,
        status,
        widget.OC.prefijo,
        widget.OC.precioUnitario,
        widget.OC.tag);
    if (result == 200) {
      setState(() {
        totalProducts = status;
      });
      getIconStatus();
    }
  }

  void getIconStatus() {
    setState(() {
      //Por surtir
      if (totalProducts == 0) {
        currentStatusIcon = statusList[0];
      }
      // Entregado
      else if (totalProducts == widget.OC.cantidad!) {
        currentStatusIcon = statusList[1];
      }
      //En progreso de entrega
      else {
        currentStatusIcon = statusList[2];
      }
    });
  }

  getStatus() async {
    //if (widget.OC.status == null) {
    List<ProductCertificateDelivery> products1 =
        await DataAccessObject.selectProductPerOC(widget.OC.id_OC);
    if (products1.isNotEmpty) {
      for (var i = 0; i < products1.length; i++) {
        totalProducts = totalProducts + products1[i].cantidad!;
      }
    }
    // } else {
    //   totalProducts = widget.OC.status!;
    // }
    getIconStatus();
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
                            : key == "purchase order"
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          widget.OC.OC.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          widget.OC.tag == null
                                              ? ""
                                              : widget.OC.tag!,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  )
                                : key == "status"
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            EditableDeliveryCount(
                                                entregados: totalProducts,
                                                total: widget.OC.cantidad!,
                                                onUpdated: (newValue) async {
                                                  await updateOC(newValue);
                                                }),
                                            IconButton(
                                                onPressed: () {},
                                                icon: currentStatusIcon),
                                          ],
                                        ),
                                      )
                                    : Text("")),
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
                                    id_entrega: entrega.certificadoEntrega!),
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
                              widget.OC.moneda,
                              totalProducts);
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
                        id_entrega: entrega.certificadoEntrega!),
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

class EditableDeliveryCount extends StatefulWidget {
  final int entregados;
  final int total;
  final Function(int) onUpdated;

  const EditableDeliveryCount({
    required this.entregados,
    required this.total,
    required this.onUpdated,
    super.key,
  });

  @override
  State<EditableDeliveryCount> createState() => _EditableDeliveryCountState();
}

class _EditableDeliveryCountState extends State<EditableDeliveryCount> {
  bool isEditing = false;
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.entregados.toString());
    focusNode = FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus && isEditing) {
        _save();
      }
    });
  }

  Future<void> _save() async {
    final value = int.tryParse(controller.text);
    if (value != null) {
      await widget.onUpdated(value);
    }
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          isEditing = true;
          controller.text = widget.entregados.toString();
        });
        Future.delayed(Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
      },
      child: isEditing
          ? SizedBox(
              width: 60,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _save(),
                autofocus: true,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
              ),
            )
          : RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: '${widget.entregados}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' / '),
                  TextSpan(text: '${widget.total}'),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
