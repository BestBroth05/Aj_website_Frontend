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
import '../adminClases/CertificadoEntregaClass.dart';
import '../adminClases/CustomerClass.dart';
import '../adminClases/OrdenCompraClass.dart';
import '../../admin_view/admin_DeliverCertificate/LoadingData.dart';

class EditEntrega extends StatefulWidget {
  int id_customer;
  int id_OC;
  String id_entrega;
  EditEntrega(
      {Key? key,
      required this.id_customer,
      required this.id_OC,
      required this.id_entrega})
      : super(key: key);

  @override
  State<EditEntrega> createState() => _EditEntregaState();
}

class _EditEntregaState extends State<EditEntrega> {
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
  List<ProductCertificateDelivery> productsToDelete = [];
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
  bool isAllCustomersLoaded = false;
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  List<ClassCertificadoEntrega> Entregas = [];
  String? folioCertificate;
  ClassCertificadoEntrega? certificadoEntrega;
  int totalProducts = 0;
  bool isNotesCountable = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    folioCertificate = widget.id_entrega;
    await getCustomer();
    setState(() {
      isLoading = false;
    });
  }

// *********************************** GETs *********************************** \\
  getCustomer() async {
    List<CustomersClass> Customers1 =
        await DataAccessObject.selectCustomer(widget.id_customer);
    await getOC();
    setState(() {
      Customers = Customers1;
      companyName = Customers1[0].name!;
    });
  }

  getOC() async {
    List<OrdenCompraClass> OC1 = await DataAccessObject.selectOC(widget.id_OC);
    await getEntrega();
    setState(() {
      OC = OC1;
      OrdenCompra.text = OC1[0].OC!;
      // solicitante.text = OC1[0].solicitante!;
      // direccion.text =
      //     "${OC1[0].street} ${OC1[0].cp} ${OC1[0].ciudad} ${OC1[0].estado} ${OC1[0].pais}";
      moneda = OC1[0].moneda;
      descripcion.text = OC1[0].descripcion!;
    });
  }

  getEntrega() async {
    List<ClassCertificadoEntrega> Entrega1 =
        await DataAccessObject.selectEntrega(widget.id_OC);
    for (var i = 0; i < Entrega1.length; i++) {
      if (Entrega1[i].certificadoEntrega == widget.id_entrega) {
        certificadoEntrega = Entrega1[i];
      }
    }
    setState(() {
      Entrega = Entrega1;
      // ***** Getting date ***** \\
      List date = certificadoEntrega!.Fecha!.split("-");
      year = date[0];
      month = date[1];
      day = date[2];
      solicitante.text = certificadoEntrega!.Solicitante!;
      direccion.text = certificadoEntrega!.Direccion!;
      emisor.text = certificadoEntrega!.Remitente!;
      folio.text = certificadoEntrega!.certificadoEntrega!;
      fecha = certificadoEntrega!.Fecha!;
      notes.text = certificadoEntrega!.Notes!;
      relatedDeliveries.text = certificadoEntrega!.entregasRelacionadas ?? "";
      if (notes.text.contains("/")) {
        List separateNotes = notes.text.split("/");
        totalProducts = int.parse(separateNotes[0]);
        isNotesCountable = true;
      }
    });
    await getProducts();
  }

  getProducts() async {
    List<ProductCertificateDelivery> products1 =
        await DataAccessObject.selectProductOC(certificadoEntrega!.id_Entrega);
    setState(() {
      products = products1;
      isAllCustomersLoaded = true;
    });
  }

  getAllEntregas() async {
    List<ClassCertificadoEntrega> Entrega1 =
        await DataAccessObject.getEntrega();
    return Entrega1;
  }

// *********************************** POSTs *********************************** \\
  updateEntrega() async {
    fecha = "$year-$month-$day";
    if (notes.text.isEmpty) {
      notes.text = '';
    } else {
      //nothing to do
    }
    Entregas = await getAllEntregas();
    bool isAlreadyStored = false;
    fecha = "$year-$month-$day";
    if (folio.text != folioCertificate) {
      for (var i = 0; i < Entregas.length; i++) {
        if (folio.text == Entregas[i].certificadoEntrega) {
          isAlreadyStored = true;
        }
      }
    }

    if (!isAlreadyStored) {
      int result = await DataAccessObject.updateEntrega(
          widget.id_OC,
          certificadoEntrega!.id_Entrega,
          widget.id_customer,
          folio.text,
          fecha,
          direccion.text,
          solicitante.text,
          emisor.text,
          notes.text,
          relatedDeliveries.text);
      if (result == 200) {
        if (products.isEmpty) {
          //nothing to do
        } else {
          await updateProducts();
        }
      } else {
        wrongPopup(context, "Something went wrong");
        Future.delayed(const Duration(seconds: 3), () {
          setState(() => isPressed = false);
          Navigator.pop(context);
        });
      }
    } else {
      wrongPopup(context, "The Certificate already exists");
      Future.delayed(const Duration(seconds: 3), () {
        setState(() => isPressed = false);
        Navigator.pop(context);
      });
    }
  }

  updateProducts() async {
    if (productsToDelete.isNotEmpty) {
      await deleteProductOC();
    }
    bool status = false;
    for (var i = 0; i < products.length; i++) {
      print(
          "id = ${folio.text} cantidad = ${products[i].cantidad!} descripcion = ${products[i].descripcion} unitario = ${products[i].precioUnitario!} importe = ${products[i].importe}");
      int result = await DataAccessObject.updateProductOC(
          products[i].id_producto,
          certificadoEntrega!.id_Entrega,
          widget.id_OC,
          0,
          "",
          products[i].precioUnitario!,
          products[i].cantidad!,
          products[i].descripcion,
          products[i].importe);
      if (result == 200) {
        status = true;
      } else if (result == 404) {
        await postProducts(products[i]);
      } else {
        status = false;
        wrongPopup(context, "Something went wrong");
        Future.delayed(const Duration(seconds: 3), () {
          setState(() => isPressed = false);
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
                      customerName: companyName,
                    )));
      });
    } else {
      wrongPopup(context, "Something went wrong");
      Future.delayed(const Duration(seconds: 3), () {
        setState(() => isPressed = false);
        Navigator.pop(context);
      });
    }
  }

  postProducts(ProductCertificateDelivery product) async {
    int result = await DataAccessObject.postProductoOC(
        certificadoEntrega!.id_Entrega,
        widget.id_OC,
        0,
        "",
        product.cantidad!,
        product.descripcion,
        product.precioUnitario!,
        product.importe);
    if (result == 200) {
    } else {
      wrongPopup(context, "Something went wrong");
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }

  deleteProductOC() async {
    bool status = false;
    for (var i = 0; i < productsToDelete.length; i++) {
      int result = await DataAccessObject.deleteProductOC(
          productsToDelete[i].id_producto);
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
                      customerName: companyName,
                    )));
      });
    } else {
      wrongPopup(context, "Something went wrong");
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Notes
                    textArea(notes, "Notes", TextInputType.multiline,
                        FilteringTextInputFormatter.singleLineFormatter),
                    //Related Deliveries
                    textArea(
                        relatedDeliveries,
                        "Related Deliveries",
                        TextInputType.multiline,
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
                                      id_entrega:
                                          certificadoEntrega!.id_Entrega,
                                      descripcion: descripcion.text,
                                      cantidad: int.parse(cantidad.text),
                                      precioUnitario:
                                          double.parse(unitario.text),
                                      importe: importe));
                                  if (isNotesCountable) {
                                    totalProducts += int.parse(cantidad.text);
                                    notes.text =
                                        "$totalProducts/${OC[0].cantidad}";
                                  }
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
                        DataColumn(label: Text('Delete/Edit')),
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
                                    productsToDelete.add(product);
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
                                    productsToDelete.add(product);
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
                          onPressed: () {
                            if (!isPressed) {
                              setState(() => isPressed = true);
                              if (_formKeyCertificate.currentState!
                                  .validate()) {
                                if (notes.text.isEmpty) {
                                  notes.text = " ";
                                }
                                updateEntrega();
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
                                //     notes.text);
                              }
                            }
                          }))
                ],
              ),
            ]),
          ));
  }
}
