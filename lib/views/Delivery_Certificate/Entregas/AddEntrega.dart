// ignore_for_file: must_be_immutable

import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import 'package:guadalajarav2/Popups.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/widgets/deliverFieldWidget.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/productClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/admin_OC/OCList.dart';
import 'package:intl/intl.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import '../../../main.dart';
import '../../admin_view/admin_DeliverCertificate/LoadingData.dart';
import '../adminClases/CertificadoEntregaClass.dart';
import '../adminClases/CustomerClass.dart';
import '../adminClases/OrdenCompraClass.dart';

class AddEntrega extends StatefulWidget {
  int id_customer;
  int id_OC;
  AddEntrega({Key? key, required this.id_customer, required this.id_OC})
      : super(key: key);

  @override
  State<AddEntrega> createState() => _AddEntregaState();
}

class _AddEntregaState extends State<AddEntrega> {
  TextEditingController folio = TextEditingController();
  TextEditingController OrdenCompra = TextEditingController();
  String? fecha;
  TextEditingController direccion = TextEditingController();
  TextEditingController solicitante = TextEditingController();
  TextEditingController cantidad = TextEditingController();
  TextEditingController unitario = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController emisor = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController relatedDeliveries = TextEditingController();
  List<ProductCertificateDelivery> products = [];
  List<CustomersClass> Customers = [];
  List<OrdenCompraClass> OC = [];
  List<ClassCertificadoEntrega> Entrega = [];
  double? importe;
  final _formKeyProduct = GlobalKey<FormState>();
  final _formKeyCertificate = GlobalKey<FormState>();
  double widthTable = 200;
  String companyName = "";
  String? day;
  String? month;
  String? year;
  String? moneda;
  bool isPressed = false;
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  List<ClassCertificadoEntrega> Entregas = [];
  List<ProductCertificateDelivery> allProducts = [];
  int totalProducts = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    emisor.text = "${user!.name} ${user!.lastName}";
    // ***** Getting date ***** \\
    DateTime now = DateTime.now();
    day = DateFormat.d().format(now);
    month = DateFormat.M().format(now);
    year = DateFormat.y().format(now);
    fecha = DateFormat.yMd().format(now);
    await getCustomer();
    await getOC();
    await getEntregasPerCustomer();
    await fillingRelatedDeliveries();
    setState(() {
      isLoading = false;
    });
  }

  getCustomer() async {
    List<CustomersClass> Customers1 =
        await DataAccessObject.selectCustomer(widget.id_customer);
    setState(() {
      Customers = Customers1;
      companyName = Customers1[0].name!;
    });
  }

  getEntregasPerCustomer() async {
    List<ClassCertificadoEntrega> Entrega1 =
        await DataAccessObject.selectEntregaByCustomer(widget.id_customer);
    return Entrega1;
  }

  getEntregasPerOC() async {
    List<ClassCertificadoEntrega> Entrega1 =
        await DataAccessObject.selectEntrega(widget.id_OC);
    return Entrega1;
  }

  postEntrega() async {
    try {
      Entregas = await getEntregasPerCustomer();
      bool isAlreadyStored = false;
      fecha = "$year-$month-$day";
      if (Entregas.isNotEmpty) {
        for (var i = 0; i < Entregas.length; i++) {
          if (folio.text == Entregas[i].certificadoEntrega) {
            isAlreadyStored = true;
          }
        }
      }

      if (!isAlreadyStored) {
        int result = await DataAccessObject.postEntrega(
            widget.id_OC,
            widget.id_customer,
            folio.text,
            fecha,
            direccion.text,
            solicitante.text,
            emisor.text,
            notes.text,
            relatedDeliveries.text);
        if (result == 200) {
          await postProducts();
        } else {
          setState(() => isPressed = false);
          wrongPopup(context, "Something went wrong");
          Future.delayed(const Duration(seconds: 3), () {
            setState(() => isPressed = false);
            Navigator.pop(context);
          });
        }
      } else {
        setState(() => isPressed = false);
        wrongPopup(context, "The Certificate already exists");
        Future.delayed(const Duration(seconds: 3), () {
          setState(() => isPressed = false);
          Navigator.pop(context);
        });
      }
    } catch (e) {
      setState(() => isPressed = false);
      wrongPopup(context, "Something went wrong");
      Future.delayed(const Duration(seconds: 3), () {
        setState(() => isPressed = false);
        Navigator.pop(context);
      });
    }
  }

  postProducts() async {
    bool status = false;
    Entrega = await DataAccessObject.selectEntrega(widget.id_OC);
    for (var i = 0; i < products.length; i++) {
      print(
          "id = ${Entrega[(Entrega.length - 1)].id_Entrega} cantidad = ${products[i].cantidad!} descripcion = ${products[i].descripcion} unitario = ${products[i].precioUnitario!} importe = ${products[i].importe}");
      int result = await DataAccessObject.postProductoOC(
          Entrega[(Entrega.length - 1)].id_Entrega,
          widget.id_OC,
          0,
          "",
          products[i].cantidad!,
          products[i].descripcion,
          products[i].precioUnitario!,
          products[i].importe);
      if (result == 200) {
        status = true;
      } else {
        status = false;
        wrongPopup(context, "Something went wrong");
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        break;
      }
    }
    if (status) {
      succesfullyPopUp(context, "Succesfully added");
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OCList(
                    id_customer: widget.id_customer,
                    customerName: companyName)));
      });
    } else {
      wrongPopup(context, "Something went wrong");
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }

  getProducts() async {
    List<ProductCertificateDelivery> products1 =
        await DataAccessObject.getProductosOC();
    setState(() {
      for (var i = 0; i < products1.length; i++) {
        if (products1[i].id_OC == widget.id_OC) {
          allProducts.add(products1[i]);
        }
      }
    });
  }

  getOC() async {
    List<OrdenCompraClass> OC1 = await DataAccessObject.selectOC(widget.id_OC);
    List<ClassCertificadoEntrega> Entrega1 = await getEntregasPerCustomer();
    if (OC1[0].precioUnitario == null) {
      unitario.text = "0.00";
    } else {
      unitario.text = OC1[0].precioUnitario.toString();
    }

    await getProducts();

    setState(() {
      OC = OC1;
      if (Entrega1.isNotEmpty) {
        var string = Entrega1[Entrega1.length - 1].certificadoEntrega!;
        var newString = string.substring(string.length - 5);
        int value = (int.parse(newString) + 1);
        switch (value.toString().length) {
          case 1:
            folio.text = "${OC1[0].prefijo!}0000$value";
            break;
          case 2:
            folio.text = "${OC1[0].prefijo!}000$value";
            break;
          case 3:
            folio.text = "${OC1[0].prefijo!}00$value";
            break;
          case 4:
            folio.text = "${OC1[0].prefijo!}0$value";
            break;
          default:
            folio.text = "${OC1[0].prefijo!}$value";
        }
        print("subString = $newString");
      } else {
        folio.text = "${OC1[0].prefijo!}00001";
      }

      OrdenCompra.text = OC1[0].OC!;
      solicitante.text = OC1[0].solicitante!;
      direccion.text =
          "${OC1[0].street} ${OC1[0].cp} ${OC1[0].ciudad} ${OC1[0].estado} ${OC1[0].pais}";
      moneda = OC1[0].moneda;
      if (allProducts.isNotEmpty) {
        for (var i = 0; i < allProducts.length; i++) {
          totalProducts = totalProducts + allProducts[i].cantidad!;
        }
      }
      descripcion.text = OC1[0].descripcion!;
      notes.text = "$totalProducts/${OC1[0].cantidad}";
    });
  }

  fillingRelatedDeliveries() async {
    List<ClassCertificadoEntrega> allEntregas = await getEntregasPerOC();
    relatedDeliveries.text =
        allEntregas.map((p) => "- ${p.certificadoEntrega}").join("\n");
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingData()
        : SingleChildScrollView(
            child: Form(
            key: _formKeyCertificate,
            child: Column(children: [
              DashboardTopBar(selected: 4),
              //Title
              Container(
                alignment: Alignment.center,
                color: Colors.teal,
                height: 40,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                child: Text("DELIVERY CERTIFICATE $companyName",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
              ),
              //Data
              Container(
                margin: EdgeInsets.only(top: 25, left: 100, right: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Fecha
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "* Date:",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, bottom: 5),
                          width: 360,
                          child: DropdownDatePicker(
                            boxDecoration:
                                const BoxDecoration(color: Colors.white),
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            dayFlex: 2,
                            inputDecoration: InputDecoration(
                                fillColor: Colors.white,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10))), // optional
                            isDropdownHideUnderline: true, // optional
                            isFormValidator: false, // optional
                            startYear: 2000, // optional
                            endYear: int.parse(year!), // optional
                            width: 10, // optional

                            selectedDay: int.parse(day!), // optional
                            selectedMonth: int.parse(month!), // optional
                            selectedYear: int.parse(year!), // optional
                            onChangedDay: (valueDay) {
                              day = valueDay!;
                              print('onChangedDay: $valueDay');
                            },

                            onChangedMonth: (valueMonth) {
                              month = valueMonth!;
                              print('onChangedMonth: $valueMonth');
                            },

                            onChangedYear: (valueYear) {
                              year = valueYear!;
                              print('onChangedYear: $valueYear');
                            },

                            //boxDecoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                            // showDay: false,// optional
                            // dayFlex: 2,// optional
                            // locale: "zh_CN",// optional
                            hintDay: 'Day', // optional
                            hintMonth: 'Month', // optional
                            hintYear: 'Year', // optional
                            hintTextStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14), // optional
                          ),
                        ),
                      ],
                    ),

                    //Folio
                    fieldDeliver(folio, "Folio", TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    //Entrega a
                    fieldDeliver(
                        direccion,
                        "Delivery address",
                        TextInputType.name,
                        FilteringTextInputFormatter.singleLineFormatter),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, left: 100, right: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Orden de compra
                    fieldDeliver(
                        OrdenCompra,
                        "Purchase order $companyName",
                        TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    //Ordenar por
                    fieldDeliver(solicitante, "Applicant", TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    //Enviado y validado por
                    fieldDeliver(
                        emisor,
                        "Send and validate by",
                        TextInputType.name,
                        FilteringTextInputFormatter.singleLineFormatter),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, left: 100, right: 100),
                child: Row(
                  //direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Notes
                    textArea(notes, "Notes", TextInputType.name,
                        FilteringTextInputFormatter.singleLineFormatter),
                    //Entregas relacionadas
                    textArea(
                        relatedDeliveries,
                        "Related deliveries",
                        TextInputType.name,
                        FilteringTextInputFormatter.singleLineFormatter),
                  ],
                ),
              ),
              //Title 2
              Container(
                alignment: Alignment.center,
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.teal,
                margin: EdgeInsets.only(top: 50),
                child: Text("Product delivered",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white)),
              ),
              Form(
                key: _formKeyProduct,
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Cantidad
                      fieldDeliver(cantidad, "Quantity", TextInputType.number,
                          FilteringTextInputFormatter.digitsOnly),
                      //Descripcion
                      textArea(
                          descripcion,
                          "Description",
                          TextInputType.multiline,
                          FilteringTextInputFormatter.singleLineFormatter),
                      //Unitario
                      fieldDeliver(
                          unitario,
                          "Unit price",
                          TextInputType.numberWithOptions(decimal: true),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}'))),
                      // -------------- Button more -------------- //
                      Container(
                        margin: const EdgeInsets.only(
                          left: 15,
                        ),
                        alignment: Alignment.topRight,
                        height: 35,
                        child: FloatingActionButton(
                            backgroundColor: Colors.teal,
                            child: const Icon(
                              Entypo.plus,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                importe = double.parse(unitario.text) *
                                    int.parse(cantidad.text);
                                if (_formKeyProduct.currentState!.validate()) {
                                  products.add(ProductCertificateDelivery(
                                      descripcion: descripcion.text,
                                      cantidad: int.parse(cantidad.text),
                                      precioUnitario:
                                          double.parse(unitario.text),
                                      importe: importe));
                                  totalProducts += int.parse(cantidad.text);
                                  notes.text =
                                      "$totalProducts/${OC[0].cantidad}";
                                  cantidad = TextEditingController();
                                  descripcion.text = OC[0].descripcion!;
                                  if (OC[0].precioUnitario == null) {
                                    unitario.text = "0.00";
                                  } else {
                                    unitario.text =
                                        OC[0].precioUnitario.toString();
                                  }
                                }
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              SelectionArea(
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  child: DataTable(
                      sortColumnIndex: 0,
                      sortAscending: true,
                      columns: <DataColumn>[
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Unit price\n($moneda)')),
                        DataColumn(label: Text('Amount\n($moneda)')),
                        DataColumn(label: Text('Delete/Edit'))
                      ],
                      rows: products
                          .map<DataRow>((ProductCertificateDelivery product) {
                        return DataRow(cells: <DataCell>[
                          DataCell(Text(product.cantidad!.toString())),
                          DataCell(Text(product.descripcion!)),
                          DataCell(Text(
                              "\$ ${formatter.format(product.precioUnitario)}")),
                          DataCell(
                              Text("\$ ${formatter.format(product.importe!)}")),
                          DataCell(SizedBox(
                              //width: 15,
                              child: Row(
                            children: [
                              IconButton(
                                //splashRadius: 15,
                                onPressed: () {
                                  setState(() {
                                    totalProducts -= product.cantidad!;
                                    notes.text =
                                        "$totalProducts/${OC[0].cantidad}";
                                    products.remove(product);
                                  });
                                },
                                icon: Icon(
                                  Entypo.cancel_circled,
                                  //size: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                //splashRadius: 15,
                                onPressed: () {
                                  setState(() {
                                    cantidad.text = product.cantidad.toString();
                                    descripcion.text = product.descripcion!;
                                    unitario.text =
                                        product.precioUnitario.toString();
                                    products.remove(product);
                                  });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  //size: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )))
                        ]);
                      }).toList()),
                ),
              ),

              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.all(50),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                !isPressed ? Colors.teal : Colors.grey,
                            foregroundColor: white,
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            if (!isPressed) {
                              setState(() => isPressed = true);
                              if (_formKeyCertificate.currentState!
                                  .validate()) {
                                if (notes.text.isEmpty) {
                                  notes.text = " ";
                                }
                                await postEntrega();
                                // PDFLanguage(
                                //     context,
                                //     fecha,
                                //     folio.text,
                                //     OrdenCompra.text,
                                //     direccion.text,
                                //     emisor.text,
                                //     companyName,
                                //     solicitante.text,
                                //     products,
                                //     notes.text,
                                //     moneda);
                              }
                            }
                          }))
                ],
              ),
            ]),
          ));
  }
}
