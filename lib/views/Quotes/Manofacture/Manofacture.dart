// ignore_for_file: must_be_immutable

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

import '../../../utils/tools.dart';
import '../../Delivery_Certificate/Controllers/DAO.dart';
import '../../Delivery_Certificate/adminClases/CustomerClass.dart';
import '../../Delivery_Certificate/adminClases/OrdenCompraClass.dart';
import '../../Delivery_Certificate/adminClases/productClass.dart';
import '../../Delivery_Certificate/widgets/Popups.dart';
import '../../Delivery_Certificate/widgets/Texts.dart';
import '../../Delivery_Certificate/widgets/deliverFieldWidget.dart';
import '../Clases/PorcentajesClass.dart';

class Manofacture extends StatefulWidget {
  QuoteClass? quote;
  bool isEdit;
  Manofacture({super.key, required this.isEdit, this.quote});

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
  List<ProductCertificateDelivery> productsStart = [];
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
  String? buttonText;
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
    getAllCustomers();
    isEditing();
    super.initState();
  }

// ************************************************************************************ //
// ************************************* Gobal Functions ****************************** //
// ************************************************************************************ //
  isEditing() async {
    if (widget.isEdit) {
      buttonText = "Update";
      DateTime now = DateTime.parse(widget.quote!.date!);
      day = DateFormat.d().format(now);
      month = DateFormat.M().format(now);
      year = DateFormat.y().format(now);
      //General data
      customerName = widget.quote!.customerName!;
      quoteNumber.text = widget.quote!.quoteNumber!;
      fecha = widget.quote!.date!;
      attentionTo.text = widget.quote!.attentionTo!;
      requestedByName.text = widget.quote!.requestedByName!;
      requestedByEmail.text = widget.quote!.requestedByEmail!;
      proyectName.text = widget.quote!.proyectName!;
      //Informative
      dollarSell.text = widget.quote!.dollarSell!.toString();
      dollarBuy.text = widget.quote!.dollarBuy.toString();
      days = widget.quote!.deliverTimeInfo;
      currency = widget.quote!.currency;
      conIva = widget.quote!.conIva;
      //Percentages
      porcentajeIva.text = widget.quote!.iva!.toString();
      porcentajeIsr.text = widget.quote!.isr.toString();
      porcentajeAj.text = widget.quote!.componentsAJ.toString();
      //Products delivered
      await getProductsPerQuote();
    } else {
      buttonText = "Save";
      // ***** Getting date ***** \\
      DateTime now = DateTime.now();
      day = DateFormat.d().format(now);
      month = DateFormat.M().format(now);
      year = DateFormat.y().format(now);
      fecha = now.toString();
      attentionTo.text = "Departamento de Compras";
      customerName = currentUser.customerNameQuotes!.name;
      await getAllQuotesPerCustomer();
      await getPercetages();
      await getDollarCost();
    }
  }

  getProductsPerQuote() async {
    List<ProductCertificateDelivery> allProducts =
        await DataAccessObject.getProductosOC();

    setState(() {
      for (var i = 0; i < allProducts.length; i++) {
        if (allProducts[i].id_quote == widget.quote!.id_Quote) {
          products.add(allProducts[i]);
        }
      }
      productsStart = products;
    });
  }

  updateQuote(
      QuoteClass quote, List<ProductCertificateDelivery> productstoPost) async {
    try {
      int code = await DataAccessObject.updateQuote(
          quote.id_Quote,
          quote.id_Customer,
          quote.id_Percentages,
          quote.iva,
          quote.isr,
          quote.quoteType,
          quote.date,
          quote.customerName,
          quote.quoteNumber,
          quote.proyectName,
          quote.requestedByName,
          quote.requestedByEmail,
          quote.attentionTo,
          quote.quantity,
          quote.dollarSell,
          quote.dollarBuy,
          quote.deliverTimeInfo,
          quote.currency,
          quote.conIva,
          quote.excelName,
          quote.componentsMPN,
          quote.componentsAvailables,
          quote.componentsDeliverTime,
          quote.componentsAJPercentage,
          quote.digikeysAJPercentage,
          quote.dhlCostComponent,
          quote.componentsMouserCost,
          quote.componentsIVA,
          quote.componentsAJ,
          quote.totalComponentsUSD,
          quote.totalComponentsMXN,
          quote.perComponentMXN,
          quote.PCBName,
          quote.PCBLayers,
          quote.PCBSize,
          quote.PCBImage,
          quote.PCBColor,
          quote.PCBDeliveryTime,
          quote.PCBdhlCost,
          quote.PCBAJPercentage,
          quote.PCBReleasePercentage,
          quote.PCBPurchase,
          quote.PCBShipment,
          quote.PCBTax,
          quote.PCBRelease,
          quote.PCBAJ,
          quote.PCBTotalUSD,
          quote.PCBTotalMXN,
          quote.PCBPerMXN,
          quote.assemblyLayers,
          quote.assemblyMPN,
          quote.assemblySMT,
          quote.assemblyTH,
          quote.assemblyDeliveryTime,
          quote.assemblyAJPercentage,
          quote.assembly,
          quote.assemblyTax,
          quote.assemblyAJ,
          quote.assemblyDhlCost,
          quote.assemblyTotalMXN,
          quote.perAssemblyMXN);

      print("Error numero: $code");
      if (code == 200) {
        await deleteProducts(productsStart);
        int idQuote = await getIdQuote();
        int codeP = await postProducts(productstoPost, idQuote);
        if (codeP == 200) {
          setState(() => isPressed = true);
          GoodPopup(context, "Saved");
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        } else {
          setState(() => isPressed = false);
          wrongPopup(context, "Error to send quote");
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        }
      } else {
        setState(() => isPressed = false);
        wrongPopup(context, "Error to send quote");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      setState(() => isPressed = false);
      print("error $e");
      PopupError(context);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return 1005;
    }
  }

  deleteProducts(List<ProductCertificateDelivery> productsToDelete) async {
    for (var i = 0; i < productsToDelete.length; i++) {
      if (productsToDelete[i].id_producto != null) {
        await DataAccessObject.deleteProductOC(productsToDelete[i].id_producto);
      }
    }
  }

  getPercetages() async {
    List<PorcentajesClass> porcentajes1 =
        await DataAccessObject.selectPorcentajesByCustomer(
            currentUser.customerNameQuotes!.id_customer);
    setState(() {
      if (porcentajes1.isNotEmpty) {
        porcentajeIva.text = porcentajes1[0].iva.toString();
        porcentajeIsr.text = porcentajes1[0].isr.toString();
        porcentajeAj.text = porcentajes1[0].ajComponents.toString();
      } else {
        porcentajeIva.text = "1.16";
        porcentajeIsr.text = "1.32";
        porcentajeAj.text = "1.1";
      }
    });
  }

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

  getIdQuote() async {
    int id_quote = 0;
    List<QuoteClass> allQuotes = await DataAccessObject.getQuotes();

    setState(() {
      id_quote = allQuotes[allQuotes.length - 1].id_Quote!;
    });
    return id_quote;
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

  postQuote(
      QuoteClass quote, List<ProductCertificateDelivery> productstoPost) async {
    try {
      int code = await DataAccessObject.postQuote(
          quote.id_Customer,
          quote.id_Percentages,
          quote.iva,
          quote.isr,
          quote.quoteType,
          quote.date,
          quote.customerName,
          quote.quoteNumber,
          quote.proyectName,
          quote.requestedByName,
          quote.requestedByEmail,
          quote.attentionTo,
          quote.quantity,
          quote.dollarSell,
          quote.dollarBuy,
          quote.deliverTimeInfo,
          quote.currency,
          quote.conIva,
          quote.excelName,
          quote.componentsMPN,
          quote.componentsAvailables,
          quote.componentsDeliverTime,
          quote.componentsAJPercentage,
          quote.digikeysAJPercentage,
          quote.dhlCostComponent,
          quote.componentsMouserCost,
          quote.componentsIVA,
          quote.componentsAJ,
          quote.totalComponentsUSD,
          quote.totalComponentsMXN,
          quote.perComponentMXN,
          quote.PCBName,
          quote.PCBLayers,
          quote.PCBSize,
          quote.PCBImage,
          quote.PCBColor,
          quote.PCBDeliveryTime,
          quote.PCBdhlCost,
          quote.PCBAJPercentage,
          quote.PCBReleasePercentage,
          quote.PCBPurchase,
          quote.PCBShipment,
          quote.PCBTax,
          quote.PCBRelease,
          quote.PCBAJ,
          quote.PCBTotalUSD,
          quote.PCBTotalMXN,
          quote.PCBPerMXN,
          quote.assemblyLayers,
          quote.assemblyMPN,
          quote.assemblySMT,
          quote.assemblyTH,
          quote.assemblyDeliveryTime,
          quote.assemblyAJPercentage,
          quote.assembly,
          quote.assemblyTax,
          quote.assemblyAJ,
          quote.assemblyDhlCost,
          quote.assemblyTotalMXN,
          quote.perAssemblyMXN);

      print("Error numero: $code");
      if (code == 200) {
        int idQuote = await getIdQuote();
        int codeP = await postProducts(productstoPost, idQuote);
        if (codeP == 200) {
          setState(() => isPressed = true);
          GoodPopup(context, "Saved");
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        } else {
          setState(() => isPressed = false);
          wrongPopup(context, "Error to send quote");
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        }
      } else {
        setState(() => isPressed = false);
        wrongPopup(context, "Error to send quote");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      setState(() => isPressed = false);
      print("error $e");
      PopupError(context);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return 1005;
    }
  }

  postProducts(
      List<ProductCertificateDelivery> productstoPost, int id_quote) async {
    int code = 0;
    for (var i = 0; i < productstoPost.length; i++) {
      productstoPost[i].id_quote = id_quote;
    }
    for (var i = 0; i < productstoPost.length; i++) {
      try {
        code = await DataAccessObject.postProductoOC(
            productstoPost[i].id_entrega,
            productstoPost[i].id_OC,
            productstoPost[i].id_quote,
            productstoPost[i].image,
            productstoPost[i].cantidad,
            productstoPost[i].descripcion,
            productstoPost[i].precioUnitario,
            productstoPost[i].importe);
        if (code != 200) {
          setState(() => isPressed = false);
          wrongPopup(context, "Error to send products");
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        }
      } catch (e) {
        setState(() => isPressed = false);
        wrongPopup(context, "Error to send products");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    }
    if (code == 200) {
      return 200;
    } else {
      return 1005;
    }
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
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Align(
                                //   alignment: Alignment.topLeft,
                                //   child: Text(
                                //     "* $text:",
                                //     style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                Container(
                                    child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 360,
                                    child: TextFormField(
                                      maxLines: null,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Description is required';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      controller: descripcion,
                                      style: TextStyle(),
                                      decoration: InputDecoration(
                                        labelText: "* Description",
                                        labelStyle: TextStyle(
                                          color: Colors.teal,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.green),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.redAccent),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
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
                                      id_entrega: 0,
                                      id_OC: 0,
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
            width: (currentUser.width! - 500),
            margin: EdgeInsets.only(top: 25, left: 50, right: 50),
            child: DataTable(
                border: TableBorder.all(
                  width: 1.0,
                ),
                dataRowMinHeight: 50,
                dataRowMaxHeight: 150,
                // sortColumnIndex: 0,
                // sortAscending: true,
                columns: <DataColumn>[
                  DataColumn(
                      label: Container(
                    child: Text('Quantity'),
                  )),
                  DataColumn(
                      label: Container(
                    child: Text('Description'),
                  )),
                  DataColumn(
                      label: Container(child: Text('Unit price\n($usdOrMxn)'))),
                  DataColumn(
                      label: Container(child: Text('Amount\n($usdOrMxn)'))),
                  DataColumn(label: Text('Image')),
                  DataColumn(
                      label: Container(
                    child: Text('Delete/Edit'),
                  ))
                ],
                rows:
                    products.map<DataRow>((ProductCertificateDelivery product) {
                  return DataRow(cells: <DataCell>[
                    DataCell(
                        Container(child: Text(product.cantidad!.toString()))),
                    DataCell(Container(
                        width: 300, child: Text(product.descripcion!))),
                    DataCell(Container(
                      child: Text(
                          "\$ ${formatter.format(product.precioUnitario)}"),
                    )),
                    DataCell(Container(
                      child: Text("\$ ${formatter.format(product.importe!)}"),
                    )),
                    DataCell(product.image!.isNotEmpty
                        ? Center(
                            child: Image.memory(
                              base64.decode(product.image!),
                              height: 75,
                              width: 100,
                            ),
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.transparent,
                          )),
                    DataCell(SizedBox(
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
                  buttonText!,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  if (_formKeyGeneralData.currentState!.validate()) {
                    if (_formKeyInformative.currentState!.validate()) {
                      if (widget.isEdit) {
                        quote = QuoteClass(
                          id_Quote: widget.quote!.id_Quote,
                          id_Customer: widget.quote!.id_Customer,
                          id_Percentages: 0,
                          iva: double.parse(porcentajeIva.text),
                          isr: double.parse(porcentajeIsr.text),
                          quoteType: widget.quote!.quoteType,
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
                          assemblyDhlCost: 0.0,
                          assemblyDeliveryTime: "",
                          assemblyAJPercentage: 0.0,
                          assembly: 0.0,
                          assemblyTax: 0.0,
                          assemblyAJ: 0.0,
                          assemblyTotalMXN: 0.0,
                          perAssemblyMXN: 0.0,
                        );
                        await updateQuote(quote!, products);
                      } else {
                        quote = QuoteClass(
                          id_Customer:
                              currentUser.customerNameQuotes!.id_customer,
                          id_Percentages: 0,
                          iva: double.parse(porcentajeIva.text),
                          isr: double.parse(porcentajeIsr.text),
                          quoteType: currentUser.quoteType,
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
                          assemblyDhlCost: 0.0,
                          assemblyDeliveryTime: "",
                          assemblyAJPercentage: 0.0,
                          assembly: 0.0,
                          assemblyTax: 0.0,
                          assemblyAJ: 0.0,
                          assemblyTotalMXN: 0.0,
                          perAssemblyMXN: 0.0,
                        );
                        await postQuote(quote!, products);
                      }
                    }
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
                        quoteType: currentUser.quoteType,
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
