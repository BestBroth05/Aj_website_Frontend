import 'dart:convert';

import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:guadalajarav2/utils/SuperGlobalVariables/ObjVar.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';
import 'package:guadalajarav2/views/Quotes/Manofacture/PreviewManofacture.dart';

import '../../Delivery_Certificate/Controllers/DAO.dart';
import '../../Delivery_Certificate/adminClases/CustomerClass.dart';
import '../../Delivery_Certificate/adminClases/OrdenCompraClass.dart';
import '../../Delivery_Certificate/adminClases/productClass.dart';
import '../../Delivery_Certificate/widgets/Texts.dart';
import '../../Delivery_Certificate/widgets/deliverFieldWidget.dart';

class Manofacture extends StatefulWidget {
  const Manofacture({super.key});

  @override
  State<Manofacture> createState() => _ManofactureState();
}

class _ManofactureState extends State<Manofacture> {
// ************************************************************************************* //
// ************************************* Variables ************************************* //
// ************************************************************************************* //
  //General data
  TextEditingController quoteNumber = TextEditingController();
  String? fecha;
  TextEditingController attentionTo = TextEditingController();
  TextEditingController requestedByName = TextEditingController();
  TextEditingController requestedByEmail = TextEditingController();
  TextEditingController proyectName = TextEditingController();
  String? customerName;
  // Informative
  TextEditingController dollarSell = TextEditingController();
  TextEditingController dollarBuy = TextEditingController();
  String? days = "30 days";
  String? currency = "MXN";
  bool? conIva = false;
  //Add Product
  TextEditingController cantidad = TextEditingController();
  TextEditingController unitario = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController notes = TextEditingController();
  int totalProducts = 0;
  double? importe;
  List<ProductCertificateDelivery> products = [];
  List<OrdenCompraClass> OC = [];
  TextEditingController imageName = TextEditingController();
  //Porcentajes
  TextEditingController porcentajeIva = TextEditingController();
  TextEditingController porcentajeIsr = TextEditingController();
  TextEditingController porcentajeAj = TextEditingController();
  // GlobalKeys
  final _formKeyGeneralData = GlobalKey<FormState>();
  final _formKeyInformative = GlobalKey<FormState>();
  final _formKeyProduct = GlobalKey<FormState>();
  final _formKeyImage = GlobalKey<FormState>();
  //Tools
  String selcFile = "";
  String fileName = '';
  Uint8List? selectedImageInBytes;
  QuoteClass? quote;
  List<CustomersClass> allCustomers = [];
  String? day;
  String? month;
  String? year;
  String usdOrMxn = "MXN";
  bool isPressed = false;
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  ValueChanged<String>? onChanged;
// ************************************************************************************* //
// ************************************* InitState ************************************* //
// ************************************************************************************* //
  @override
  void initState() {
    porcentajeIva.text = "1.16";
    porcentajeIsr.text = "1.32";
    porcentajeAj.text = "1.1";
    customerName = currentUser.customerNameQuotes!.name;
    attentionTo.text = "Departamento de Compras";
    getAllCustomers();
    getDollarCost();
    getAllQuotesPerCustomer();
    super.initState();
    // ***** Getting date ***** \\
    DateTime now = DateTime.now();
    day = DateFormat.d().format(now);
    month = DateFormat.M().format(now);
    year = DateFormat.y().format(now);
    fecha = now.toString();
  }

// ************************************************************************************ //
// ************************************* Gobal Functions ****************************** //
// ************************************************************************************ //
  getAllCustomers() async {
    List<CustomersClass> allCustomers1 = await DataAccessObject.getCustomer();
    setState(() {
      allCustomers = allCustomers1;
    });
  }

  getDollarCost() async {
    // final fx = Forex();
    // List<String> availableCurrencies = await fx.getAvailableCurrencies();
    // print("The list of all available currencies: ${availableCurrencies}");
    dollarSell.text = currentUser.dollarSell;
    dollarBuy.text = currentUser.dollarBuy;
  }

  getAllQuotesPerCustomer() async {
    String number;
    int quoteNumberInt = 0;
    List<QuoteClass> quotes = await DataAccessObject.getQuotesByCustomer(
        currentUser.customerNameQuotes!.id_customer);
    setState(() {
      List split = customerName!.split(' ');
      if (quotes.isNotEmpty) {
        quoteNumberInt = int.parse(quotes[quotes.length - 1]
            .quoteNumber!
            .replaceAll("${split[0]}_", ""));
      }
      switch (quoteNumberInt) {
        case < 9:
          number = "0000${quoteNumberInt + 1}";
          break;
        case < 99:
          number = "000${quoteNumberInt + 1}";
          break;
        case < 999:
          number = "00${quoteNumberInt + 1}";
          break;
        case < 9999:
          number = "0${quoteNumberInt + 1}";
          break;
        default:
          number = "${quoteNumberInt + 1}";
      }
      quoteNumber.text = "${split[0]}_$number";
    });
  }

  Future getImage() async {
    FilePickerResult? fileResult =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);
    if (fileResult != null) {
      setState(() {
        selcFile = fileResult.files.first.name;
        selectedImageInBytes = fileResult.files.first.bytes;
        imageName.text = fileResult.files.first.name;
      });
    }
  }

  operationComponentsEmpty() {
    return onChanged = (value) {};
  }

  operationComponentsISR() {
    return onChanged = (value) {
      setState(() {});
    };
  }

  operationComponentsIVA() {
    return onChanged = (value) {
      setState(() {});
    };
  }

  operationComponentsAJ() {
    return onChanged = (value) {
      setState(() {});
    };
  }

// ************************************************************************************* //
// ************************************** Widgets ************************************* //
// ************************************************************************************ //
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
            "Services/Material",
            style: titleh1,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [generalData(), informative(), addProduct(), buttons()],
          ),
        ));
  }

  Widget generalData() {
    return Form(
      key: _formKeyGeneralData,
      child: Column(
        children: [
          //Title
          Container(
            alignment: Alignment.center,
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: Colors.teal,
            margin: EdgeInsets.only(top: 0),
            child: Text("General data",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
                            color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 5),
                      width: 360,
                      child: DropdownDatePicker(
                        boxDecoration: const BoxDecoration(color: Colors.white),
                        textStyle:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        dayFlex: 2,
                        inputDecoration: InputDecoration(
                            fillColor: Colors.white,
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
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
                        hintTextStyle: const TextStyle(
                            color: Colors.grey, fontSize: 14), // optional
                      ),
                    ),
                  ],
                ),
                //Customer
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 360,
                          child: DropdownButtonFormField(
                            value: customerName,
                            validator: (value) {
                              if (value == null) {
                                return 'Customer is required';
                              }
                              return null;
                            },
                            style: fieldStyle,
                            decoration: InputDecoration(
                                labelText: "* Customer",
                                labelStyle: TextStyle(
                                  color: Colors.teal,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.green),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.redAccent),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.redAccent),
                                )),
                            isExpanded: true,
                            hint: Text("--Select Option--", style: fieldStyle),
                            onChanged: (value) {},
                            items: allCustomers
                                .map((category) => DropdownMenuItem(
                                    value: category.name,
                                    onTap: () {
                                      setState(() {
                                        customerName = category.name;
                                        List split = customerName!.split(' ');

                                        quoteNumber.text = "${split[0]}_";
                                      });
                                    },
                                    child: Text(category.name!,
                                        style: fieldStyle)))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Folio
                fieldDeliver(quoteNumber, "#Quote", TextInputType.text,
                    FilteringTextInputFormatter.singleLineFormatter),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25, left: 100, right: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Ordenar por
                fieldDeliver(proyectName, "Proyect Name", TextInputType.text,
                    FilteringTextInputFormatter.singleLineFormatter),
                //Entrega a
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "* Requested by:",
                          style: TextStyle(
                              color: Colors.teal, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 360,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            controller: requestedByName,
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter
                            ],
                            style: fieldStyle,
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(
                                color: Colors.teal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.green),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.redAccent),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.redAccent),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      )),
                      Container(
                          child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: SizedBox(
                          width: 360,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            controller: requestedByEmail,
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter
                            ],
                            style: fieldStyle,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Colors.teal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.green),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.redAccent),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.redAccent),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      )),
                    ],
                  ),
                ),

                //Enviado y validado por
                fieldDeliver(attentionTo, "Attention To", TextInputType.name,
                    FilteringTextInputFormatter.singleLineFormatter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget informative() {
    return Form(
      key: _formKeyInformative,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: Colors.teal,
            margin: EdgeInsets.only(top: 50),
            child: Text("Informative",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white)),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
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
                        operationComponentsEmpty(),
                        false),
                    fieldDeliver(
                        dollarBuy,
                        "Dollar Buy",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}'))),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 360,
                              child: DropdownButtonFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Days is required';
                                    }
                                    return null;
                                  },
                                  style: fieldStyle,
                                  decoration: InputDecoration(
                                      labelText: "* Days",
                                      labelStyle: TextStyle(
                                        color: Colors.teal,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.green),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent),
                                      )),
                                  isExpanded: true,
                                  hint: Text("--Select Option--",
                                      style: fieldStyle),
                                  items: [
                                    DropdownMenuItem<String>(
                                        child: Text(
                                          'In cash',
                                          style: fieldStyle,
                                        ),
                                        value: 'In cash'),
                                    DropdownMenuItem<String>(
                                        child: Text(
                                          '30 days',
                                          style: fieldStyle,
                                        ),
                                        value: '30 days'),
                                    DropdownMenuItem<String>(
                                        child: Text(
                                          '60 days',
                                          style: fieldStyle,
                                        ),
                                        value: '60 days'),
                                    DropdownMenuItem<String>(
                                        child: Text(
                                          '90 days',
                                          style: fieldStyle,
                                        ),
                                        value: '90 days')
                                  ],
                                  value: days,
                                  onChanged: (value) {
                                    setState(() {
                                      days = value;
                                      switch (value) {
                                        case "In cash":
                                          porcentajeAj.text = "1.0";
                                        case "30 days":
                                          porcentajeAj.text = "1.1";
                                          break;
                                        case "60 days":
                                          porcentajeAj.text = "1.15";
                                          break;
                                        case "90 days":
                                          porcentajeAj.text = "1.2";
                                          break;
                                        default:
                                      }
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 360,
                              child: DropdownButtonFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Currency is required';
                                    }
                                    return null;
                                  },
                                  style: fieldStyle,
                                  decoration: InputDecoration(
                                      labelText: "* Currency",
                                      labelStyle: TextStyle(
                                        color: Colors.teal,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.green),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent),
                                      )),
                                  isExpanded: true,
                                  hint: Text("--Select Option--",
                                      style: fieldStyle),
                                  items: [
                                    DropdownMenuItem<String>(
                                        child: Text(
                                          'MXN',
                                          style: fieldStyle,
                                        ),
                                        value: 'MXN'),
                                    DropdownMenuItem<String>(
                                        child: Text(
                                          'USD',
                                          style: fieldStyle,
                                        ),
                                        value: 'USD')
                                  ],
                                  value: currency,
                                  onChanged: (value) {
                                    setState(() {
                                      currency = value;
                                      if (value == "USD") {
                                        dollarBuy.text = "1";
                                        dollarSell.text = "1";
                                        usdOrMxn = "USD";
                                        //dollarSellOperationsDropdown(1.0);
                                      } else {
                                        dollarBuy.text = "18";
                                        dollarSell.text = "20";
                                        usdOrMxn = "MXN";
                                        //dollarSellOperationsDropdown(20.0);
                                      }
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Add IVA",
                            style: TextStyle(
                              color: Colors.teal,
                            ),
                          ),
                          Checkbox(
                              value: conIva,
                              onChanged: (value) {
                                setState(() {
                                  conIva = value;
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addProduct() {
    return Column(
      children: [
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Porcentajes
                      Container(
                        child: Column(
                          children: [
                            fieldPercentages(
                                porcentajeIva,
                                Icon(Icons.percent),
                                "Iva",
                                TextInputType.numberWithOptions(decimal: true),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}')),
                                operationComponentsIVA(),
                                150),
                            SizedBox(height: 10),
                            fieldPercentages(
                                porcentajeIsr,
                                Icon(Icons.percent),
                                "ISR",
                                TextInputType.numberWithOptions(decimal: true),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}')),
                                operationComponentsISR(),
                                150),
                            SizedBox(height: 10),
                            fieldPercentages(
                                porcentajeAj,
                                Icon(Icons.percent),
                                "AJ",
                                TextInputType.numberWithOptions(decimal: true),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}')),
                                operationComponentsAJ(),
                                150),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Cantidad
                          fieldDeliver(
                              cantidad,
                              "Quantity",
                              TextInputType.number,
                              FilteringTextInputFormatter.digitsOnly),
                          //Descripcion
                          fieldDeliver(
                              descripcion,
                              "Description",
                              TextInputType.text,
                              FilteringTextInputFormatter.singleLineFormatter),
                          //Unitario
                          fieldDeliver(
                              unitario,
                              "Unit price",
                              TextInputType.numberWithOptions(decimal: true),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'))),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      imageFieldWidget(),
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
                                if (_formKeyProduct.currentState!.validate()) {
                                  double precioUnitario =
                                      (double.parse(unitario.text) *
                                          double.parse(porcentajeIva.text) *
                                          double.parse(porcentajeIsr.text) *
                                          double.parse(porcentajeAj.text));
                                  importe =
                                      precioUnitario * int.parse(cantidad.text);
                                  products.add(ProductCertificateDelivery(
                                      image: imageName.text.isNotEmpty
                                          ? base64.encode(selectedImageInBytes!)
                                          : "",
                                      descripcion: descripcion.text,
                                      cantidad: int.parse(cantidad.text),
                                      precioUnitario: precioUnitario,
                                      importe: importe));

                                  totalProducts += int.parse(cantidad.text);
                                  //notes.text = "$totalProducts/${OC[0].cantidad}";
                                  cantidad = TextEditingController();
                                  descripcion = TextEditingController();
                                  unitario = TextEditingController();
                                  imageName = TextEditingController();
                                  selcFile = "";
                                  fileName = '';
                                  selectedImageInBytes = Uint8List(0);
                                }
                              });
                            }),
                      )
                    ],
                  ),
                  SizedBox(height: 25)
                ],
              )),
        ),
        SelectionArea(
          child: Container(
            margin: EdgeInsets.only(top: 25),
            child: DataTable(
                border: TableBorder.all(
                  width: 1.0,
                ),
                sortColumnIndex: 0,
                sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Unit price\n($usdOrMxn)')),
                  DataColumn(label: Text('Amount\n($usdOrMxn)')),
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Delete/Edit'))
                ],
                rows:
                    products.map<DataRow>((ProductCertificateDelivery product) {
                  return DataRow(cells: <DataCell>[
                    DataCell(Text(product.cantidad!.toString())),
                    DataCell(Text(product.descripcion!)),
                    DataCell(
                        Text("\$ ${formatter.format(product.precioUnitario)}")),
                    DataCell(Text("\$ ${formatter.format(product.importe!)}")),
                    DataCell(product.image!.isNotEmpty
                        ? Image.memory(
                            base64.decode(product.image!),
                            height: 50,
                            width: 50,
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.transparent,
                          )),
                    DataCell(SizedBox(
                        //width: 15,
                        child: Row(
                      children: [
                        IconButton(
                          //splashRadius: 15,
                          onPressed: () {
                            setState(() {
                              totalProducts -= product.cantidad!;
                              //notes.text = "$totalProducts/${OC[0].cantidad}";
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
                              unitario.text = product.precioUnitario.toString();
                              imageName.text =
                                  product.image!.isNotEmpty ? "file.png" : "";
                              selectedImageInBytes = product.image!.isNotEmpty
                                  ? base64.decode(product.image!)
                                  : Uint8List(0);
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
        SizedBox(height: 25)
      ],
    );
  }

  Widget imageFieldWidget() {
    return Form(
      key: _formKeyImage,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 10),
        child: SizedBox(
          width: 360,
          child: TextFormField(
            //initialValue: "Select image",
            readOnly: true,
            keyboardType: TextInputType.text,
            controller: imageName,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            style: TextStyle(),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () => getImage(),
                  icon: Icon(
                    Icons.search,
                    color: Colors.teal,
                  )),
              hintText: "Select image",
              labelText: "Image",
              labelStyle: TextStyle(
                color: Colors.teal,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.green),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
            ),
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }

  Widget buttons() {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.all(50),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPressed ? Colors.grey : Colors.teal,
                  foregroundColor: white,
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  if (_formKeyGeneralData.currentState!.validate()) {
                    if (_formKeyInformative.currentState!.validate()) {}
                  }
                })),
        Container(
            margin: EdgeInsets.all(0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: white,
                ),
                child: Text(
                  "Generate quote",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  if (_formKeyGeneralData.currentState!.validate()) {
                    if (_formKeyInformative.currentState!.validate()) {
                      quote = QuoteClass(
                        id_Customer:
                            currentUser.customerNameQuotes!.id_customer,
                        iva: double.parse(porcentajeIva.text),
                        isr: double.parse(porcentajeIsr.text),
                        date: fecha,
                        customerName: customerName,
                        quoteNumber: quoteNumber.text,
                        proyectName: proyectName.text,
                        requestedByEmail: requestedByEmail.text,
                        requestedByName: requestedByName.text,
                        attentionTo: attentionTo.text,
                        quantity: 0,
                        dollarSell: double.parse(dollarSell.text),
                        dollarBuy: double.parse(dollarBuy.text),
                        deliverTimeInfo: days,
                        excelName: "",
                        componentsMPN: 0,
                        componentsAvailables: 0,
                        componentsDeliverTime: "",
                        dhlCostComponent: 0.0,
                        componentsAJPercentage: 0.0,
                        digikeysAJPercentage: 0.0,
                        componentsMouserCost: 0.0,
                        componentsIVA: 0.0,
                        componentsAJ: double.parse(porcentajeAj.text),
                        conIva: conIva,
                        currency: currency,
                        totalComponentsUSD: 0.0,
                        totalComponentsMXN: 0.0,
                        perComponentMXN: 0.0,
                        PCBName: "",
                        PCBLayers: "",
                        PCBSize: "",
                        PCBImage: "",
                        PCBColor: "",
                        PCBDeliveryTime: "",
                        PCBdhlCost: 0.0,
                        PCBAJPercentage: 0.0,
                        PCBReleasePercentage: 0.0,
                        PCBPurchase: 0.0,
                        PCBShipment: 0.0,
                        PCBTax: 0.0,
                        PCBRelease: 0.0,
                        PCBAJ: 0.0,
                        PCBTotalUSD: 0.0,
                        PCBTotalMXN: 0.0,
                        PCBPerMXN: 0.0,
                        assemblyLayers: "",
                        assemblyMPN: 0,
                        assemblySMT: 0,
                        assemblyTH: 0,
                        assemblyDeliveryTime: "",
                        assemblyAJPercentage: 0.0,
                        assembly: 0.0,
                        assemblyTax: 0.0,
                        assemblyAJ: 0.0,
                        assemblyTotalMXN: 0.0,
                        perAssemblyMXN: 0.0,
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviewManofacture(
                                  products: products,
                                  isSavedQuote: isPressed,
                                  quote: quote!,
                                  customer: currentUser.customerNameQuotes!)));
                    }
                  }
                }))
      ],
    );
  }
}
