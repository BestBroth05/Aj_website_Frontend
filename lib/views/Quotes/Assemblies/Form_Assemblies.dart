// ignore_for_file: must_be_immutable, unnecessary_import

import 'dart:convert';

import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guadalajarav2/utils/SuperGlobalVariables/ObjVar.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/widgets/deliverFieldWidget.dart';
import 'package:guadalajarav2/views/Quotes/Clases/PorcentajesClass.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';
import 'package:intl/intl.dart';
import 'package:fluttericon/entypo_icons.dart';
import '../../../utils/tools.dart';
import '../../Delivery_Certificate/adminClases/CustomerClass.dart';
import '../../Delivery_Certificate/widgets/Popups.dart';
import '../../Delivery_Certificate/widgets/Texts.dart';
import '../Clases/DigikeyClass.dart';
import 'Preview_Assemblies.dart';

class Form_Assemblies extends StatefulWidget {
  String? quoteType;
  CustomersClass customer;
  Form_Assemblies({
    Key? key,
    required this.customer,
    required this.quoteType,
  }) : super(key: key);

  @override
  State<Form_Assemblies> createState() => _Form_AssembliesState();
}

class _Form_AssembliesState extends State<Form_Assemblies> {
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
  TextEditingController quantity = TextEditingController();
  TextEditingController dollarSell = TextEditingController();
  TextEditingController dollarBuy = TextEditingController();
  String? days = "30 days";
  String? currency = "MXN";
  bool? conIva = false;
  //Components
  TextEditingController excelName = TextEditingController();
  TextEditingController componentsNumber = TextEditingController();
  TextEditingController componentsAvailable = TextEditingController();
  TextEditingController deliverComponent = TextEditingController();
  TextEditingController mouser = TextEditingController();
  TextEditingController ivaComponents = TextEditingController();
  TextEditingController ajComponents = TextEditingController();
  TextEditingController digikeyComponents = TextEditingController();
  TextEditingController impuestosComponents = TextEditingController();
  TextEditingController ajDigikeyComponents = TextEditingController();
  TextEditingController totalComponentsDlls = TextEditingController();
  TextEditingController totalComponentsPesos = TextEditingController();
  TextEditingController perComponentsPesos = TextEditingController();
//PCB's
  TextEditingController pcbName = TextEditingController();
  String? layers;
  String? color;
  TextEditingController imageName = TextEditingController();
  TextEditingController pcbSize = TextEditingController();
  TextEditingController pcbTime = TextEditingController();
  TextEditingController pcbCompra = TextEditingController();
  TextEditingController pcbEnvio = TextEditingController();
  TextEditingController pcbImpuesto = TextEditingController();
  TextEditingController pcbLiberacion = TextEditingController();
  TextEditingController pcbTotal = TextEditingController();
  TextEditingController pcbAJ = TextEditingController();
  TextEditingController pcbTotalPesos = TextEditingController();
  TextEditingController pcbPerPesos = TextEditingController();
//Ensambles
  String? faces;
  TextEditingController MPN = TextEditingController();
  TextEditingController SMT = TextEditingController();
  TextEditingController TH = TextEditingController();
  TextEditingController ensambleTime = TextEditingController();
  TextEditingController ensamble = TextEditingController();
  TextEditingController ensambleImpuesto = TextEditingController();
  TextEditingController ensambleAJ = TextEditingController();
  TextEditingController ensambleTotalPesos = TextEditingController();
  TextEditingController ensamblePerPesos = TextEditingController();
//Porcentajes
  TextEditingController porcentajeIva = TextEditingController();
  TextEditingController porcentajeIsr = TextEditingController();
  TextEditingController dhlCostComponent = TextEditingController();
  TextEditingController dhlCostPCB = TextEditingController();
  TextEditingController dhlCostEnsamble = TextEditingController();
  TextEditingController porcentajeAjComponents = TextEditingController();
  TextEditingController porcentajeAjDigikey = TextEditingController();
  TextEditingController porcentajeAjPCB = TextEditingController();
  TextEditingController porcentajeAjEnsamble = TextEditingController();
  TextEditingController porcentajeLiberacion = TextEditingController();
  // GlobalKeys
  final _formKeyGeneralData = GlobalKey<FormState>();
  final _formKeyInformative = GlobalKey<FormState>();
  final _formKeyComponents = GlobalKey<FormState>();
  final _formKeyDigikey = GlobalKey<FormState>();
  final _formKeyPCB = GlobalKey<FormState>();
  final _formKeyAssemblies = GlobalKey<FormState>();
  final _formKeyImage = GlobalKey<FormState>();
  //Tools
  QuoteClass? quote;
  List<DigikeyClass> products = [];
  double? importe;
  double widthTable = 200;
  String? day;
  String? month;
  String? year;
  bool isPressed = false;
  bool isPressedSave = false;
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  List<CustomersClass> allCustomers = [];
  String selcFile = "";
  String fileName = '';
  Uint8List? selectedImageInBytes;
  ValueChanged<String>? onChanged;
  bool addComponents = true;
  bool addPCB = true;
  PorcentajesClass? porcentajes;
  String usdOrMxn = "MXN";

// ************************************************************************************* //
// ************************************* InitState ************************************* //
// ************************************************************************************* //
  @override
  void initState() {
    getPercetages();
    print("id customer = ${widget.customer.id_customer}");
    getAllQuotesPerCustomer();
    contarComas();

    customerName = currentUser.customerNameQuotes!.name;
    ensambleTime.text = "5 to 6 days";
    pcbTime.text = "8 to 12 days";
    deliverComponent.text = "3 to 6 days";
    attentionTo.text = "Departamento de Compras";
    getAllCustomers();
    getDollarCost();
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
  getPercetages() async {
    List<PorcentajesClass> porcentajes1 =
        await DataAccessObject.selectPorcentajesByCustomer(
            widget.customer.id_customer);
    setState(() {
      if (porcentajes1.isNotEmpty) {
        porcentajes = porcentajes1[0];
        porcentajeLiberacion.text = porcentajes1[0].liberation.toString();
        porcentajeIva.text = porcentajes1[0].iva.toString();
        porcentajeIsr.text = porcentajes1[0].isr.toString();
        dhlCostComponent.text = porcentajes1[0].dhlComponent.toString();
        dhlCostPCB.text = porcentajes1[0].dhlPCB.toString();
        dhlCostEnsamble.text = porcentajes1[0].dhlAssambly.toString();
        porcentajeAjComponents.text = porcentajes1[0].ajComponents.toString();
        porcentajeAjDigikey.text = porcentajes1[0].ajDigikey.toString();
        porcentajeAjPCB.text = porcentajes1[0].ajPCB.toString();
        porcentajeAjEnsamble.text = porcentajes1[0].ajEnsamble.toString();
      } else {
        porcentajes = PorcentajesClass(id_porcentaje: 0);
        porcentajeLiberacion.text = "0.19";
        porcentajeIva.text = "1.16";
        porcentajeIsr.text = "1.32";
        dhlCostComponent.text = "0";
        dhlCostPCB.text = "0";
        dhlCostEnsamble.text = "0";
        porcentajeAjComponents.text = "1.1";
        porcentajeAjDigikey.text = "1.18";
        porcentajeAjPCB.text = "3.35";
        porcentajeAjEnsamble.text = "1.4";
      }
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
    List<QuoteClass> quotes =
        await DataAccessObject.getQuotesByCustomer(widget.customer.id_customer);
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

// ************************************* Operations functions ************************************* //
// ********************** Operations Components Section ********************** //
  operationComponents() {
    return onChanged = (value) {
      setState(() {
        double opivaComponents =
            double.parse(mouser.text) * double.parse(porcentajeIva.text);
        ivaComponents.text = opivaComponents.toStringAsFixed(2);
        double opajComponents =
            opivaComponents * double.parse(porcentajeAjComponents.text);
        ajComponents.text = opajComponents.toStringAsFixed(2);
        totalComponentsDlls.text =
            formatter.format((double.parse(ajComponents.text)));
        totalComponentsPesos.text = formatter.format(
            (((double.parse(ajComponents.text))) *
                double.parse(dollarSell.text)));
        perComponentsPesos.text = formatter.format(
            ((((double.parse(ajComponents.text))) *
                    double.parse(dollarSell.text)) /
                int.parse(quantity.text)));
      });
    };
  }

  operationComponentsIVA() {
    return onChanged = (value) {
      setState(() {
        double opivaComponents =
            double.parse(mouser.text) * double.parse(value);
        ivaComponents.text = opivaComponents.toStringAsFixed(2);
        double opajComponents =
            opivaComponents * double.parse(porcentajeAjComponents.text);
        ajComponents.text = opajComponents.toStringAsFixed(2);

        totalComponentsDlls.text =
            formatter.format((double.parse(ajComponents.text)));
        totalComponentsPesos.text = formatter.format(
            (((double.parse(ajComponents.text))) *
                double.parse(dollarSell.text)));
        perComponentsPesos.text = formatter.format(
            ((((double.parse(ajComponents.text))) *
                    double.parse(dollarSell.text)) /
                int.parse(quantity.text)));
        double opimpuestosComponents =
            ((double.parse(digikeyComponents.text) * double.parse(value)) *
                    double.parse(porcentajeIsr.text)) +
                double.parse(dhlCostComponent.text);
        impuestosComponents.text = opimpuestosComponents.toStringAsFixed(2);
        double opajDigikeyComponents =
            opimpuestosComponents * double.parse(porcentajeAjDigikey.text);
        ajDigikeyComponents.text = opajDigikeyComponents.toStringAsFixed(2);
      });
    };
  }

  operationComponentsAJ() {
    return onChanged = (value) {
      setState(() {
        double opajComponents =
            double.parse(ivaComponents.text) * double.parse(value);
        ajComponents.text = opajComponents.toStringAsFixed(2);
        totalComponentsDlls.text =
            formatter.format((double.parse(ajComponents.text)));
        totalComponentsPesos.text = formatter.format(
            (((double.parse(ajComponents.text))) *
                double.parse(dollarSell.text)));
        perComponentsPesos.text = formatter.format(
            ((((double.parse(ajComponents.text))) *
                    double.parse(dollarSell.text)) /
                int.parse(quantity.text)));
      });
    };
  }

  operationComponentsDigikey() {
    return onChanged = (value) {
      setState(() {
        double opimpuestosComponents =
            ((double.parse(value) * double.parse(porcentajeIva.text)) *
                    double.parse(porcentajeIsr.text)) +
                double.parse(dhlCostComponent.text);
        impuestosComponents.text = opimpuestosComponents.toStringAsFixed(2);
        double opajDigikeyComponents =
            opimpuestosComponents * double.parse(porcentajeAjDigikey.text);
        ajDigikeyComponents.text = opajDigikeyComponents.toStringAsFixed(2);
      });
    };
  }

  operationComponentsAJDigikey() {
    return onChanged = (value) {
      setState(() {
        double opajDigikeyComponents =
            double.parse(impuestosComponents.text) * double.parse(value);
        ajDigikeyComponents.text = opajDigikeyComponents.toStringAsFixed(2);
      });
    };
  }

  operationComponentsISR() {
    return onChanged = (value) {
      setState(() {
        double opimpuestosComponents = ((double.parse(digikeyComponents.text) *
                    double.parse(porcentajeIva.text)) *
                double.parse(value)) +
            double.parse(dhlCostComponent.text);
        impuestosComponents.text = opimpuestosComponents.toStringAsFixed(2);
        double opajDigikeyComponents =
            opimpuestosComponents * double.parse(porcentajeAjDigikey.text);
        ajDigikeyComponents.text = opajDigikeyComponents.toStringAsFixed(2);
        totalComponentsDlls.text =
            formatter.format((double.parse(ajComponents.text)));
        totalComponentsPesos.text = formatter.format(
            (((double.parse(ajComponents.text))) *
                double.parse(dollarSell.text)));
        perComponentsPesos.text = formatter.format(
            ((((double.parse(ajComponents.text))) *
                    double.parse(dollarSell.text)) /
                int.parse(quantity.text)));
      });
    };
  }

  operationComponentsDHL() {
    return onChanged = (value) {
      setState(() {
        double opimpuestosComponents = ((double.parse(digikeyComponents.text) *
                    double.parse(porcentajeIva.text)) *
                double.parse(porcentajeIsr.text)) +
            double.parse(value);
        impuestosComponents.text = opimpuestosComponents.toStringAsFixed(2);
        double opajDigikeyComponents =
            opimpuestosComponents * double.parse(porcentajeAjDigikey.text);
        ajDigikeyComponents.text = opajDigikeyComponents.toStringAsFixed(2);
        totalComponentsDlls.text =
            formatter.format((double.parse(ajComponents.text)));
        totalComponentsPesos.text = formatter.format(
            (((double.parse(ajComponents.text))) *
                double.parse(dollarSell.text)));
        perComponentsPesos.text = formatter.format(
            ((((double.parse(ajComponents.text))) *
                    double.parse(dollarSell.text)) /
                int.parse(quantity.text)));
      });
    };
  }

  operationComponentsEmpty() {
    return onChanged = (value) {};
  }

  // ********************** Operations PCB Section ********************** //
  operationPCBShipment() {
    return onChanged = (envio) {
      setState(() {
        if (pcbCompra.text.isEmpty) {
          //Nothing to do
        } else {
          double impuesto =
              ((double.parse(pcbCompra.text) + double.parse(envio)) *
                      double.parse(porcentajeIva.text)) *
                  double.parse(porcentajeIsr.text);
          pcbImpuesto.text = impuesto.toStringAsFixed(2);
          double liberacion =
              (impuesto * double.parse(porcentajeLiberacion.text)) +
                  double.parse(dhlCostPCB.text);
          pcbLiberacion.text = liberacion.toStringAsFixed(2);
          double total = impuesto + liberacion;
          pcbTotal.text = total.toStringAsFixed(2);
          double ajdlls = total * double.parse(porcentajeAjPCB.text);
          pcbAJ.text = ajdlls.toStringAsFixed(2);
          double pcbpesos = ajdlls * double.parse(dollarSell.text);
          pcbTotalPesos.text = formatter.format(pcbpesos);
          double perpcb = pcbpesos / int.parse(quantity.text);
          pcbPerPesos.text = formatter.format(perpcb);
        }
      });
    };
  }

  operationPCBPurchase() {
    return onChanged = (compra) {
      setState(() {
        double impuesto =
            ((double.parse(compra) + double.parse(pcbEnvio.text)) *
                    double.parse(porcentajeIva.text)) *
                double.parse(porcentajeIsr.text);
        pcbImpuesto.text = impuesto.toStringAsFixed(2);
        double liberacion =
            (impuesto * double.parse(porcentajeLiberacion.text)) +
                double.parse(dhlCostPCB.text);
        pcbLiberacion.text = liberacion.toStringAsFixed(2);
        double total = impuesto + liberacion;
        pcbTotal.text = total.toStringAsFixed(2);
        double ajdlls = total * double.parse(porcentajeAjPCB.text);
        pcbAJ.text = ajdlls.toStringAsFixed(2);
        double pcbpesos = ajdlls * double.parse(dollarSell.text);
        pcbTotalPesos.text = formatter.format(pcbpesos);
        double perpcb = pcbpesos / int.parse(quantity.text);
        pcbPerPesos.text = formatter.format(perpcb);
      });
    };
  }

  operetionPCBDHLCost() {
    return onChanged = (value) {
      setState(() {
        double impuesto =
            ((double.parse(pcbCompra.text) + double.parse(pcbEnvio.text)) *
                    double.parse(porcentajeIva.text)) *
                double.parse(porcentajeIsr.text);
        pcbImpuesto.text = impuesto.toStringAsFixed(2);
        double liberacion =
            (impuesto * double.parse(porcentajeLiberacion.text)) +
                double.parse(value);
        pcbLiberacion.text = liberacion.toStringAsFixed(2);
        double total = impuesto + liberacion;
        pcbTotal.text = total.toStringAsFixed(2);
        double ajdlls = total * double.parse(porcentajeAjPCB.text);
        pcbAJ.text = ajdlls.toStringAsFixed(2);
        double pcbpesos = ajdlls * double.parse(dollarSell.text);
        pcbTotalPesos.text = formatter.format(pcbpesos);
        double perpcb = pcbpesos / int.parse(quantity.text);
        pcbPerPesos.text = formatter.format(perpcb);
      });
    };
  }

  operetionPCBLiberacion() {
    return onChanged = (value) {
      setState(() {
        double impuesto =
            ((double.parse(pcbCompra.text) + double.parse(pcbEnvio.text)) *
                    double.parse(porcentajeIva.text)) *
                double.parse(porcentajeIsr.text);
        pcbImpuesto.text = impuesto.toStringAsFixed(2);
        double liberacion =
            (impuesto * double.parse(value)) + double.parse(dhlCostPCB.text);
        pcbLiberacion.text = liberacion.toStringAsFixed(2);
        double total = impuesto + liberacion;
        pcbTotal.text = total.toStringAsFixed(2);
        double ajdlls = total * double.parse(porcentajeAjPCB.text);
        pcbAJ.text = ajdlls.toStringAsFixed(2);
        double pcbpesos = ajdlls * double.parse(dollarSell.text);
        pcbTotalPesos.text = formatter.format(pcbpesos);
        double perpcb = pcbpesos / int.parse(quantity.text);
        pcbPerPesos.text = formatter.format(perpcb);
      });
    };
  }

  operetionPCBAJ() {
    return onChanged = (value) {
      setState(() {
        double impuesto =
            ((double.parse(pcbCompra.text) + double.parse(pcbEnvio.text)) *
                    double.parse(porcentajeIva.text)) *
                double.parse(porcentajeIsr.text);
        pcbImpuesto.text = impuesto.toStringAsFixed(2);
        double liberacion =
            (impuesto * double.parse(porcentajeLiberacion.text)) +
                double.parse(dhlCostPCB.text);
        pcbLiberacion.text = liberacion.toStringAsFixed(2);
        double total = impuesto + liberacion;
        pcbTotal.text = total.toStringAsFixed(2);
        double ajdlls = total * double.parse(value);
        pcbAJ.text = ajdlls.toStringAsFixed(2);
        double pcbpesos = ajdlls * double.parse(dollarSell.text);
        pcbTotalPesos.text = formatter.format(pcbpesos);
        double perpcb = pcbpesos / int.parse(quantity.text);
        pcbPerPesos.text = formatter.format(perpcb);
      });
    };
  }

  operetionPCBIVA() {
    return onChanged = (value) {
      setState(() {
        double impuesto =
            ((double.parse(pcbCompra.text) + double.parse(pcbEnvio.text)) *
                    double.parse(value)) *
                double.parse(porcentajeIsr.text);
        pcbImpuesto.text = impuesto.toStringAsFixed(2);
        double liberacion =
            (impuesto * double.parse(porcentajeLiberacion.text)) +
                double.parse(dhlCostPCB.text);
        pcbLiberacion.text = liberacion.toStringAsFixed(2);
        double total = impuesto + liberacion;
        pcbTotal.text = total.toStringAsFixed(2);
        double ajdlls = total * double.parse(value);
        pcbAJ.text = ajdlls.toStringAsFixed(2);
        double pcbpesos = ajdlls * double.parse(dollarSell.text);
        pcbTotalPesos.text = formatter.format(pcbpesos);
        double perpcb = pcbpesos / int.parse(quantity.text);
        pcbPerPesos.text = formatter.format(perpcb);
      });
    };
  }

  operetionPCBISR() {
    return onChanged = (value) {
      setState(() {
        double impuesto =
            ((double.parse(pcbCompra.text) + double.parse(pcbEnvio.text)) *
                    double.parse(value)) *
                double.parse(value);
        pcbImpuesto.text = impuesto.toStringAsFixed(2);
        double liberacion =
            (impuesto * double.parse(porcentajeLiberacion.text)) +
                double.parse(dhlCostPCB.text);
        pcbLiberacion.text = liberacion.toStringAsFixed(2);
        double total = impuesto + liberacion;
        pcbTotal.text = total.toStringAsFixed(2);
        double ajdlls = total * double.parse(value);
        pcbAJ.text = ajdlls.toStringAsFixed(2);
        double pcbpesos = ajdlls * double.parse(dollarSell.text);
        pcbTotalPesos.text = formatter.format(pcbpesos);
        double perpcb = pcbpesos / int.parse(quantity.text);
        pcbPerPesos.text = formatter.format(perpcb);
      });
    };
  }

  // ********************** Operations Ensamble Section ********************** //
  operationEnsamble() {
    return onChanged = (assembly) {
      setState(() {
        double tax =
            (double.parse(assembly) * double.parse(porcentajeIva.text)) *
                double.parse(porcentajeIsr.text);
        ensambleImpuesto.text = tax.toStringAsFixed(2);
        double aj = tax * double.parse(porcentajeAjEnsamble.text);
        ensambleAJ.text = aj.toStringAsFixed(2);
        double totalEnsamble = aj * double.parse(dollarSell.text);
        ensambleTotalPesos.text = formatter.format(totalEnsamble);
        double perEnsamble = totalEnsamble / int.parse(quantity.text);
        ensamblePerPesos.text = formatter.format(perEnsamble);
      });
    };
  }

  operationEnsambleIVA() {
    return onChanged = (iva) {
      setState(() {
        double tax = (double.parse(ensamble.text) * double.parse(iva)) *
            double.parse(porcentajeIsr.text);
        ensambleImpuesto.text = tax.toStringAsFixed(2);
        double aj = tax * double.parse(porcentajeAjEnsamble.text);
        ensambleAJ.text = aj.toStringAsFixed(2);
        double totalEnsamble = aj * double.parse(dollarSell.text);
        ensambleTotalPesos.text = formatter.format(totalEnsamble);
        double perEnsamble = totalEnsamble / int.parse(quantity.text);
        ensamblePerPesos.text = formatter.format(perEnsamble);
      });
    };
  }

  operationEnsambleISR() {
    return onChanged = (isr) {
      setState(() {
        double tax =
            (double.parse(ensamble.text) * double.parse(porcentajeIva.text)) *
                double.parse(isr);
        ensambleImpuesto.text = tax.toStringAsFixed(2);
        double aj = tax * double.parse(porcentajeAjEnsamble.text);
        ensambleAJ.text = aj.toStringAsFixed(2);
        double totalEnsamble = aj * double.parse(dollarSell.text);
        ensambleTotalPesos.text = formatter.format(totalEnsamble);
        double perEnsamble = totalEnsamble / int.parse(quantity.text);
        ensamblePerPesos.text = formatter.format(perEnsamble);
      });
    };
  }

  operationEnsambleAJ() {
    return onChanged = (ajValue) {
      setState(() {
        double tax =
            (double.parse(ensamble.text) * double.parse(porcentajeIva.text)) *
                double.parse(porcentajeIsr.text);
        ensambleImpuesto.text = tax.toStringAsFixed(2);
        double aj = tax * double.parse(ajValue);
        ensambleAJ.text = aj.toStringAsFixed(2);
        double totalEnsamble = aj * double.parse(dollarSell.text);
        ensambleTotalPesos.text = formatter.format(totalEnsamble);
        double perEnsamble = totalEnsamble / int.parse(quantity.text);
        ensamblePerPesos.text = formatter.format(perEnsamble);
      });
    };
  }

// ********************** Information Operations Section ********************** //
  quantityOperactions() {
    return onChanged = (quantity) {
      setState(() {
        //operation Components
        perComponentsPesos.text = formatter.format(
            ((((double.parse(ajComponents.text))) *
                    double.parse(dollarSell.text)) /
                int.parse(quantity)));

        //operation PCB Purchase
        double perpcb = double.parse(pcbTotalPesos.text.replaceAll(",", "")) /
            int.parse(quantity);
        pcbPerPesos.text = formatter.format(perpcb);

        //operation Ensamble
        double perEnsamble =
            double.parse(ensambleTotalPesos.text.replaceAll(",", "")) /
                int.parse(quantity);
        ensamblePerPesos.text = formatter.format(perEnsamble);
      });
    };
  }

  dollarSellOperations() {
    return onChanged = (dollarSell) {
      setState(() {
        //operation Components
        perComponentsPesos.text = formatter.format(
            ((((double.parse(ajComponents.text))) * double.parse(dollarSell)) /
                int.parse(quantity.text)));

        double totalEnsamble =
            double.parse(ensambleAJ.text) * double.parse(dollarSell);
        ensambleTotalPesos.text = formatter.format(totalEnsamble);
        double perEnsamble = totalEnsamble / int.parse(quantity.text);
        ensamblePerPesos.text = formatter.format(perEnsamble);

        double pcbpesos = double.parse(pcbAJ.text) * double.parse(dollarSell);
        pcbTotalPesos.text = formatter.format(pcbpesos);
        double perpcb = pcbpesos / int.parse(quantity.text);
        pcbPerPesos.text = formatter.format(perpcb);

        totalComponentsPesos.text = formatter.format(
            (((double.parse(ajComponents.text))) * double.parse(dollarSell)));
        perComponentsPesos.text = formatter.format(
            ((((double.parse(ajComponents.text))) * double.parse(dollarSell)) /
                int.parse(quantity.text)));
      });
    };
  }

  dollarSellOperationsDropdown(dollarSell) {
    setState(() {
      if (totalComponentsDlls.text.isNotEmpty) {
        totalComponentsPesos.text = formatter.format(
            (((double.parse(totalComponentsDlls.text.replaceAll(",", "")))) *
                dollarSell));
        perComponentsPesos.text = formatter.format(
            ((((double.parse(totalComponentsDlls.text.replaceAll(",", "")))) *
                    dollarSell) /
                int.parse(quantity.text)));
        mouser.selection;
      }
      if (pcbAJ.text.isNotEmpty) {
        double pcbpesos = double.parse(pcbAJ.text) * dollarSell;
        pcbTotalPesos.text = formatter.format(pcbpesos);
        double perpcb = pcbpesos / int.parse(quantity.text);
        pcbPerPesos.text = formatter.format(perpcb);
      }
      if (ensambleAJ.text.isNotEmpty) {
        double totalEnsamble = double.parse(ensambleAJ.text) * dollarSell;
        ensambleTotalPesos.text = formatter.format(totalEnsamble);
        double perEnsamble = totalEnsamble / int.parse(quantity.text);
        ensamblePerPesos.text = formatter.format(perEnsamble);
      }
    });
  }

// ********************** Operations Ensamble Section ********************** //
  postQuoteDB() async {
    try {
      int code = 0;
      if (!addComponents && !addPCB) {
        code = await DataAccessObject.postQuote(
          //ID's
          widget.customer.id_customer,
          porcentajes!.id_porcentaje,
          //General percentages
          double.parse(porcentajeIva.text),
          double.parse(porcentajeIsr.text),
          //General data
          currentUser.quoteType,
          fecha,
          customerName,
          quoteNumber.text,
          proyectName.text,
          requestedByEmail.text,
          requestedByName.text,
          attentionTo.text,
          //Information
          int.parse(quantity.text),
          double.parse(dollarSell.text),
          double.parse(dollarBuy.text),
          days,
          currency,
          conIva == false ? 0 : 1,
          //Components
          " ",
          0,
          0,
          " ",
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          //PCB's
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          //Assemblies
          faces,
          int.parse(MPN.text),
          int.parse(SMT.text),
          int.parse(TH.text),
          ensambleTime.text,
          double.parse(porcentajeAjEnsamble.text),
          double.parse(ensamble.text),
          double.parse(ensambleImpuesto.text),
          double.parse(ensambleAJ.text),
          double.parse(dhlCostEnsamble.text),
          double.parse(ensambleTotalPesos.text.replaceAll(",", "")),
          double.parse(ensamblePerPesos.text.replaceAll(",", "")),
        );
      } else if (!addComponents) {
        code = await DataAccessObject.postQuote(
          //ID's
          widget.customer.id_customer,
          porcentajes!.id_porcentaje,
          //General percentages
          double.parse(porcentajeIva.text),
          double.parse(porcentajeIsr.text),
          //General data
          currentUser.quoteType,
          fecha,
          customerName,
          quoteNumber.text,
          proyectName.text,
          requestedByEmail.text,
          requestedByName.text,
          attentionTo.text,
          //Information
          int.parse(quantity.text),
          double.parse(dollarSell.text),
          double.parse(dollarBuy.text),
          days,
          currency,
          conIva == false ? 0 : 1,
          //Components
          " ",
          0,
          0,
          " ",
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          //PCB's
          pcbName.text,
          layers,
          pcbSize.text,
          base64.encode(selectedImageInBytes!),
          color,
          pcbTime.text,
          double.parse(dhlCostPCB.text),
          double.parse(porcentajeAjPCB.text),
          double.parse(porcentajeLiberacion.text),
          double.parse(pcbCompra.text),
          double.parse(pcbEnvio.text),
          double.parse(pcbImpuesto.text),
          double.parse(pcbLiberacion.text),
          double.parse(pcbAJ.text),
          double.parse(pcbTotal.text),
          double.parse(pcbTotalPesos.text.replaceAll(",", "")),
          double.parse(pcbPerPesos.text.replaceAll(",", "")),
          //Assemblies
          faces,
          int.parse(MPN.text),
          int.parse(SMT.text),
          int.parse(TH.text),
          ensambleTime.text,
          double.parse(porcentajeAjEnsamble.text),
          double.parse(ensamble.text),
          double.parse(ensambleImpuesto.text),
          double.parse(ensambleAJ.text),
          double.parse(dhlCostEnsamble.text),
          double.parse(ensambleTotalPesos.text.replaceAll(",", "")),
          double.parse(ensamblePerPesos.text.replaceAll(",", "")),
        );
      } else if (!addPCB) {
        code = await DataAccessObject.postQuote(
          //ID's
          widget.customer.id_customer,
          porcentajes!.id_porcentaje,
          //General percentages
          double.parse(porcentajeIva.text),
          double.parse(porcentajeIsr.text),
          //General data
          currentUser.quoteType,
          fecha,
          customerName,
          quoteNumber.text,
          proyectName.text,
          requestedByEmail.text,
          requestedByName.text,
          attentionTo.text,
          //Information
          int.parse(quantity.text),
          double.parse(dollarSell.text),
          double.parse(dollarBuy.text),
          days,
          currency,
          conIva == false ? 0 : 1,
          //Components
          excelName.text,
          int.parse(componentsNumber.text),
          int.parse(componentsAvailable.text),
          deliverComponent.text,
          double.parse(porcentajeAjComponents.text),
          double.parse(porcentajeAjDigikey.text),
          double.parse(dhlCostComponent.text),
          double.parse(mouser.text),
          double.parse(ivaComponents.text),
          double.parse(ajComponents.text),
          double.parse(totalComponentsDlls.text.replaceAll(",", "")),
          double.parse(totalComponentsPesos.text.replaceAll(",", "")),
          double.parse(perComponentsPesos.text.replaceAll(",", "")),
          //PCB's
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0,
          //Assemblies
          faces,
          int.parse(MPN.text),
          int.parse(SMT.text),
          int.parse(TH.text),
          ensambleTime.text,
          double.parse(porcentajeAjEnsamble.text),
          double.parse(ensamble.text),
          double.parse(ensambleImpuesto.text),
          double.parse(ensambleAJ.text),
          double.parse(dhlCostEnsamble.text),
          double.parse(ensambleTotalPesos.text.replaceAll(",", "")),
          double.parse(ensamblePerPesos.text.replaceAll(",", "")),
        );
      } else {
        code = await DataAccessObject.postQuote(
          //ID's
          widget.customer.id_customer,
          porcentajes!.id_porcentaje,
          //General percentages
          double.parse(porcentajeIva.text),
          double.parse(porcentajeIsr.text),
          //General data
          currentUser.quoteType,
          fecha,
          customerName,
          quoteNumber.text,
          proyectName.text,
          requestedByEmail.text,
          requestedByName.text,
          attentionTo.text,
          //Information
          int.parse(quantity.text),
          double.parse(dollarSell.text),
          double.parse(dollarBuy.text),
          days,
          currency,
          conIva == false ? 0 : 1,
          //Components
          excelName.text,
          int.parse(componentsNumber.text),
          int.parse(componentsAvailable.text),
          deliverComponent.text,
          double.parse(porcentajeAjComponents.text),
          double.parse(porcentajeAjDigikey.text),
          double.parse(dhlCostComponent.text),
          double.parse(mouser.text),
          double.parse(ivaComponents.text),
          double.parse(ajComponents.text),
          double.parse(totalComponentsDlls.text.replaceAll(",", "")),
          double.parse(totalComponentsPesos.text.replaceAll(",", "")),
          double.parse(perComponentsPesos.text.replaceAll(",", "")),
          //PCB's
          pcbName.text,
          layers,
          pcbSize.text,
          base64.encode(selectedImageInBytes!),
          color,
          pcbTime.text,
          double.parse(dhlCostPCB.text),
          double.parse(porcentajeAjPCB.text),
          double.parse(porcentajeLiberacion.text),
          double.parse(pcbCompra.text),
          double.parse(pcbEnvio.text),
          double.parse(pcbImpuesto.text),
          double.parse(pcbLiberacion.text),
          double.parse(pcbAJ.text),
          double.parse(pcbTotal.text),
          double.parse(pcbTotalPesos.text.replaceAll(",", "")),
          double.parse(pcbPerPesos.text.replaceAll(",", "")),
          //Assemblies
          faces,
          int.parse(MPN.text),
          int.parse(SMT.text),
          int.parse(TH.text),
          ensambleTime.text,
          double.parse(porcentajeAjEnsamble.text),
          double.parse(ensamble.text),
          double.parse(ensambleImpuesto.text),
          double.parse(ensambleAJ.text),
          double.parse(dhlCostEnsamble.text),
          double.parse(ensambleTotalPesos.text.replaceAll(",", "")),
          double.parse(ensamblePerPesos.text.replaceAll(",", "")),
        );
      }

      print("Error numero: $code");
      if (code == 200) {
        if (addComponents) {
          if (products.isNotEmpty) {
            await postDigikeys();
          } else {
            setState(() => isPressed = true);
            setState(() => isPressedSave = true);
            GoodPopup(context, "Saved");
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          }
        } else {
          setState(() => isPressed = true);
          setState(() => isPressedSave = true);
          GoodPopup(context, "Saved");
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

  postDigikeys() async {
    try {
      int code = 0;
      List<QuoteClass> quotes1 = await DataAccessObject.getQuotes();
      for (var i = 0; i < products.length; i++) {
        code = await DataAccessObject.postDigikey(
            quotes1[quotes1.length - 1].id_Quote,
            products[i].digikey,
            products[i].impuesto,
            products[i].aj);
      }

      if (code != 200) {
        setState(() => isPressed = false);
        setState(() => isPressedSave = false);
        wrongPopup(context, "Error to send Digikeys");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      } else {
        setState(() => isPressed = true);
        setState(() => isPressedSave = true);
        GoodPopup(context, "Saved");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      setState(() => isPressed = false);
      setState(() => isPressedSave = false);
      wrongPopup(context, "Error to send Digikeys");
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
    }
  }

  contarComas() {
    String com =
        "id_customer, id_percentages, iva, isr, date, customerName, quoteNumber, proyectName, requestedByName, requestedByEmail, attentionTo, quantity, dollarSell, dollarBuy, deliverTimeInfo, currency, conIva, excelName, componentsMPN, componentsAvailables, componentsDeliverTime, componentsAJPercentage, digikeyAJPercentage, dhlCostComponents, componentsMauserCost, componentsIva, componentsAJ, totalComponentsUSD, totalComponentsMXN, perComponentMXN, PCBName, PCBLayers, PCBSize, PCBImage, PCBColor, PCBDeliveryTime, PCBdhlCost, PCBAJPercentage, PCBReleasePercentage, PCBPurchase, PCBShipment, PCBTax, PCBRelease, PCBAJ, PCBTotalUSD, PCBTotalMXN, PCBPerMXN, assemblyLayers, assemblyMPN, assemblySMT, assemblyTH, assemblyDeliverTime, assemblyAJPercentage, assemblyCost, assemblyTax, assemblyAJ, assemblyTotalMXN, assemblyPerMXN";
    List comas = com.split(",");
    print("Hay ${comas.length} comas");
  }

//
// ************************************************************************************* //
// ************************************** Widgets ************************************* //
// ************************************************************************************ //
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      //General data
      generalData(),
      // Informative
      Informative(),
      // Components
      Components(),
      //PCB's
      PCB(),
      //Assembly
      Assembly(),
      //Buttons
      buttons()
    ]));
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
                  //TEST
                  // quote = quoteExample;
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Preview_Assemblies(
                  //               quote: quote,
                  //               customer: widget.customer,
                  //             )));
                  //RELEASE

                  if (_formKeyGeneralData.currentState!.validate()) {
                    if (_formKeyInformative.currentState!.validate()) {
                      if (addComponents) {
                        if (_formKeyComponents.currentState!.validate()) {
                          if (addPCB) {
                            if (_formKeyPCB.currentState!.validate()) {
                              if (_formKeyAssemblies.currentState!.validate()) {
                                if (!isPressed) {
                                  setState(() => isPressed = true);
                                  await postQuoteDB();
                                }
                              }
                            }
                          } else {
                            if (_formKeyAssemblies.currentState!.validate()) {
                              if (!isPressed) {
                                setState(() => isPressed = true);

                                await postQuoteDB();
                              }
                            }
                          }
                        }
                      } else {
                        if (addPCB) {
                          if (_formKeyPCB.currentState!.validate()) {
                            if (_formKeyAssemblies.currentState!.validate()) {
                              if (!isPressed) {
                                setState(() => isPressed = true);
                                await postQuoteDB();
                              }
                            }
                          }
                        } else {
                          if (_formKeyAssemblies.currentState!.validate()) {
                            if (!isPressed) {
                              setState(() => isPressed = true);

                              await postQuoteDB();
                            }
                          }
                        }
                      }
                    }
                  }
                })),
        Container(
            margin: EdgeInsets.all(0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPressedSave ? Colors.teal : Colors.grey,
                  foregroundColor: white,
                ),
                child: Text(
                  "Generate quote",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  if (isPressedSave) {
                    if (_formKeyGeneralData.currentState!.validate()) {
                      if (_formKeyInformative.currentState!.validate()) {
                        if (addComponents) {
                          if (_formKeyComponents.currentState!.validate()) {
                            if (addPCB) {
                              if (_formKeyPCB.currentState!.validate()) {
                                if (_formKeyImage.currentState!.validate()) {
                                  if (_formKeyAssemblies.currentState!
                                      .validate()) {
                                    quote = QuoteClass(
                                      id_Customer: widget.customer.id_customer,
                                      iva: double.parse(porcentajeIva.text),
                                      isr: double.parse(porcentajeIsr.text),
                                      date: fecha,
                                      customerName: customerName,
                                      quoteNumber: quoteNumber.text,
                                      proyectName: proyectName.text,
                                      requestedByEmail: requestedByEmail.text,
                                      requestedByName: requestedByName.text,
                                      attentionTo: attentionTo.text,
                                      quantity: int.parse(quantity.text),
                                      dollarSell: double.parse(dollarSell.text),
                                      dollarBuy: double.parse(dollarBuy.text),
                                      deliverTimeInfo: days,
                                      excelName: excelName.text,
                                      componentsMPN:
                                          int.parse(componentsNumber.text),
                                      componentsAvailables:
                                          int.parse(componentsAvailable.text),
                                      componentsDeliverTime:
                                          deliverComponent.text,
                                      dhlCostComponent:
                                          double.parse(dhlCostComponent.text),
                                      componentsAJPercentage: double.parse(
                                          porcentajeAjComponents.text),
                                      digikeysAJPercentage: double.parse(
                                          porcentajeAjDigikey.text),
                                      componentsMouserCost:
                                          double.parse(mouser.text),
                                      componentsIVA:
                                          double.parse(ivaComponents.text),
                                      componentsAJ:
                                          double.parse(ajComponents.text),
                                      conIva: conIva,
                                      currency: currency,
                                      totalComponentsUSD: double.parse(
                                          totalComponentsDlls.text
                                              .replaceAll(",", "")),
                                      totalComponentsMXN: double.parse(
                                          totalComponentsPesos.text
                                              .replaceAll(",", "")),
                                      perComponentMXN: double.parse(
                                          perComponentsPesos.text
                                              .replaceAll(",", "")),
                                      PCBName: pcbName.text,
                                      PCBLayers: layers,
                                      PCBSize: pcbSize.text,
                                      PCBImage:
                                          base64.encode(selectedImageInBytes!),
                                      PCBColor: color,
                                      PCBDeliveryTime: pcbTime.text,
                                      PCBdhlCost: double.parse(dhlCostPCB.text),
                                      PCBAJPercentage:
                                          double.parse(porcentajeAjPCB.text),
                                      PCBReleasePercentage: double.parse(
                                          porcentajeLiberacion.text),
                                      PCBPurchase: double.parse(pcbCompra.text),
                                      PCBShipment: double.parse(pcbEnvio.text),
                                      PCBTax: double.parse(pcbImpuesto.text),
                                      PCBRelease:
                                          double.parse(pcbLiberacion.text),
                                      PCBAJ: double.parse(pcbAJ.text),
                                      PCBTotalUSD: double.parse(pcbTotal.text),
                                      PCBTotalMXN: double.parse(pcbTotalPesos
                                          .text
                                          .replaceAll(",", "")),
                                      PCBPerMXN: double.parse(
                                          pcbPerPesos.text.replaceAll(",", "")),
                                      assemblyLayers: faces,
                                      assemblyMPN: int.parse(MPN.text),
                                      assemblySMT: int.parse(SMT.text),
                                      assemblyTH: int.parse(TH.text),
                                      assemblyDeliveryTime: ensambleTime.text,
                                      assemblyAJPercentage: double.parse(
                                          porcentajeAjEnsamble.text),
                                      assembly: double.parse(ensamble.text),
                                      assemblyTax:
                                          double.parse(ensambleImpuesto.text),
                                      assemblyAJ: double.parse(ensambleAJ.text),
                                      assemblyTotalMXN: double.parse(
                                          ensambleTotalPesos.text
                                              .replaceAll(",", "")),
                                      perAssemblyMXN: double.parse(
                                          ensamblePerPesos.text
                                              .replaceAll(",", "")),
                                    );
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Preview_Assemblies(
                                                    isSavedQuote: isPressed,
                                                    quote: quote!,
                                                    customer:
                                                        widget.customer)));
                                  }
                                }
                              }
                            } else {
                              if (_formKeyAssemblies.currentState!.validate()) {
                                quote = QuoteClass(
                                  id_Customer: widget.customer.id_customer,
                                  iva: double.parse(porcentajeIva.text),
                                  isr: double.parse(porcentajeIsr.text),
                                  date: fecha,
                                  customerName: customerName,
                                  quoteNumber: quoteNumber.text,
                                  proyectName: proyectName.text,
                                  requestedByEmail: requestedByEmail.text,
                                  requestedByName: requestedByName.text,
                                  attentionTo: attentionTo.text,
                                  quantity: int.parse(quantity.text),
                                  dollarSell: double.parse(dollarSell.text),
                                  dollarBuy: double.parse(dollarBuy.text),
                                  deliverTimeInfo: days,
                                  excelName: excelName.text,
                                  componentsMPN:
                                      int.parse(componentsNumber.text),
                                  componentsAvailables:
                                      int.parse(componentsAvailable.text),
                                  componentsDeliverTime: deliverComponent.text,
                                  dhlCostComponent:
                                      double.parse(dhlCostComponent.text),
                                  componentsAJPercentage:
                                      double.parse(porcentajeAjComponents.text),
                                  digikeysAJPercentage:
                                      double.parse(porcentajeAjDigikey.text),
                                  componentsMouserCost:
                                      double.parse(mouser.text),
                                  componentsIVA:
                                      double.parse(ivaComponents.text),
                                  componentsAJ: double.parse(ajComponents.text),
                                  conIva: conIva,
                                  currency: currency,
                                  totalComponentsUSD: double.parse(
                                      totalComponentsDlls.text
                                          .replaceAll(",", "")),
                                  totalComponentsMXN: double.parse(
                                      totalComponentsPesos.text
                                          .replaceAll(",", "")),
                                  perComponentMXN: double.parse(
                                      perComponentsPesos.text
                                          .replaceAll(",", "")),
                                  PCBName: " ",
                                  PCBLayers: " ",
                                  PCBSize: " ",
                                  PCBImage: " ",
                                  PCBColor: " ",
                                  PCBDeliveryTime: " ",
                                  PCBdhlCost: double.parse("0.0"),
                                  PCBAJPercentage: double.parse("0.0"),
                                  PCBReleasePercentage: double.parse("0.0"),
                                  PCBPurchase: double.parse("0.0"),
                                  PCBShipment: double.parse("0.0"),
                                  PCBTax: double.parse("0.0"),
                                  PCBRelease: double.parse("0.0"),
                                  PCBAJ: double.parse("0.0"),
                                  PCBTotalUSD: double.parse("0.0"),
                                  PCBTotalMXN: double.parse("0.0"),
                                  PCBPerMXN: double.parse("0.0"),
                                  assemblyLayers: faces,
                                  assemblyMPN: int.parse(MPN.text),
                                  assemblySMT: int.parse(SMT.text),
                                  assemblyTH: int.parse(TH.text),
                                  assemblyDeliveryTime: ensambleTime.text,
                                  assemblyAJPercentage:
                                      double.parse(porcentajeAjEnsamble.text),
                                  assembly: double.parse(ensamble.text),
                                  assemblyTax:
                                      double.parse(ensambleImpuesto.text),
                                  assemblyAJ: double.parse(ensambleAJ.text),
                                  assemblyTotalMXN: double.parse(
                                      ensambleTotalPesos.text
                                          .replaceAll(",", "")),
                                  perAssemblyMXN: double.parse(ensamblePerPesos
                                      .text
                                      .replaceAll(",", "")),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Preview_Assemblies(
                                                isSavedQuote: isPressed,
                                                quote: quote!,
                                                customer: widget.customer)));
                              }
                            }
                          }
                        } else {
                          excelName.text = " ";
                          componentsNumber.text = "0";
                          componentsAvailable.text = "0";
                          deliverComponent.text = " ";
                          porcentajeAjComponents.text = "0.0";
                          porcentajeAjDigikey.text = "0.0";
                          dhlCostComponent.text = "0.0";
                          mouser.text = "0.0";
                          ivaComponents.text = "0.0";
                          ajComponents.text = "0.0";
                          totalComponentsDlls.text = "0.0";
                          totalComponentsPesos.text = "0.0";
                          perComponentsPesos.text = "0.0";
                          if (addPCB) {
                            if (_formKeyPCB.currentState!.validate()) {
                              if (_formKeyImage.currentState!.validate()) {
                                if (_formKeyAssemblies.currentState!
                                    .validate()) {
                                  quote = QuoteClass(
                                    id_Customer: widget.customer.id_customer,
                                    iva: double.parse(porcentajeIva.text),
                                    isr: double.parse(porcentajeIsr.text),
                                    date: fecha,
                                    customerName: customerName,
                                    quoteNumber: quoteNumber.text,
                                    proyectName: proyectName.text,
                                    requestedByEmail: requestedByEmail.text,
                                    requestedByName: requestedByName.text,
                                    attentionTo: attentionTo.text,
                                    quantity: int.parse(quantity.text),
                                    dollarSell: double.parse(dollarSell.text),
                                    dollarBuy: double.parse(dollarBuy.text),
                                    deliverTimeInfo: days,
                                    excelName: excelName.text,
                                    componentsMPN:
                                        int.parse(componentsNumber.text),
                                    componentsAvailables:
                                        int.parse(componentsAvailable.text),
                                    componentsDeliverTime:
                                        deliverComponent.text,
                                    dhlCostComponent:
                                        double.parse(dhlCostComponent.text),
                                    componentsAJPercentage: double.parse(
                                        porcentajeAjComponents.text),
                                    digikeysAJPercentage:
                                        double.parse(porcentajeAjDigikey.text),
                                    componentsMouserCost:
                                        double.parse(mouser.text),
                                    componentsIVA:
                                        double.parse(ivaComponents.text),
                                    componentsAJ:
                                        double.parse(ajComponents.text),
                                    conIva: conIva,
                                    currency: currency,
                                    totalComponentsUSD: double.parse(
                                        totalComponentsDlls.text
                                            .replaceAll(",", "")),
                                    totalComponentsMXN: double.parse(
                                        totalComponentsPesos.text
                                            .replaceAll(",", "")),
                                    perComponentMXN: double.parse(
                                        perComponentsPesos.text
                                            .replaceAll(",", "")),
                                    PCBName: pcbName.text,
                                    PCBLayers: layers,
                                    PCBSize: pcbSize.text,
                                    PCBImage:
                                        base64.encode(selectedImageInBytes!),
                                    PCBColor: color,
                                    PCBDeliveryTime: pcbTime.text,
                                    PCBdhlCost: double.parse(dhlCostPCB.text),
                                    PCBAJPercentage:
                                        double.parse(porcentajeAjPCB.text),
                                    PCBReleasePercentage:
                                        double.parse(porcentajeLiberacion.text),
                                    PCBPurchase: double.parse(pcbCompra.text),
                                    PCBShipment: double.parse(pcbEnvio.text),
                                    PCBTax: double.parse(pcbImpuesto.text),
                                    PCBRelease:
                                        double.parse(pcbLiberacion.text),
                                    PCBAJ: double.parse(pcbAJ.text),
                                    PCBTotalUSD: double.parse(pcbTotal.text),
                                    PCBTotalMXN: double.parse(
                                        pcbTotalPesos.text.replaceAll(",", "")),
                                    PCBPerMXN: double.parse(
                                        pcbPerPesos.text.replaceAll(",", "")),
                                    assemblyLayers: faces,
                                    assemblyMPN: int.parse(MPN.text),
                                    assemblySMT: int.parse(SMT.text),
                                    assemblyTH: int.parse(TH.text),
                                    assemblyDeliveryTime: ensambleTime.text,
                                    assemblyAJPercentage:
                                        double.parse(porcentajeAjEnsamble.text),
                                    assembly: double.parse(ensamble.text),
                                    assemblyTax:
                                        double.parse(ensambleImpuesto.text),
                                    assemblyAJ: double.parse(ensambleAJ.text),
                                    assemblyTotalMXN: double.parse(
                                        ensambleTotalPesos.text
                                            .replaceAll(",", "")),
                                    perAssemblyMXN: double.parse(
                                        ensamblePerPesos.text
                                            .replaceAll(",", "")),
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Preview_Assemblies(
                                                  isSavedQuote: isPressed,
                                                  quote: quote!,
                                                  customer: widget.customer)));
                                }
                              }
                            }
                          } else {
                            if (_formKeyAssemblies.currentState!.validate()) {
                              quote = QuoteClass(
                                id_Customer: widget.customer.id_customer,
                                iva: double.parse(porcentajeIva.text),
                                isr: double.parse(porcentajeIsr.text),
                                date: fecha,
                                customerName: customerName,
                                quoteNumber: quoteNumber.text,
                                proyectName: proyectName.text,
                                requestedByEmail: requestedByEmail.text,
                                requestedByName: requestedByName.text,
                                attentionTo: attentionTo.text,
                                quantity: int.parse(quantity.text),
                                dollarSell: double.parse(dollarSell.text),
                                dollarBuy: double.parse(dollarBuy.text),
                                deliverTimeInfo: days,
                                excelName: excelName.text,
                                componentsMPN: int.parse(componentsNumber.text),
                                componentsAvailables:
                                    int.parse(componentsAvailable.text),
                                componentsDeliverTime: deliverComponent.text,
                                dhlCostComponent:
                                    double.parse(dhlCostComponent.text),
                                componentsAJPercentage:
                                    double.parse(porcentajeAjComponents.text),
                                digikeysAJPercentage:
                                    double.parse(porcentajeAjDigikey.text),
                                componentsMouserCost: double.parse(mouser.text),
                                componentsIVA: double.parse(ivaComponents.text),
                                componentsAJ: double.parse(ajComponents.text),
                                conIva: conIva,
                                currency: currency,
                                totalComponentsUSD: double.parse(
                                    totalComponentsDlls.text
                                        .replaceAll(",", "")),
                                totalComponentsMXN: double.parse(
                                    totalComponentsPesos.text
                                        .replaceAll(",", "")),
                                perComponentMXN: double.parse(perComponentsPesos
                                    .text
                                    .replaceAll(",", "")),
                                PCBName: " ",
                                PCBLayers: " ",
                                PCBSize: " ",
                                PCBImage: " ",
                                PCBColor: " ",
                                PCBDeliveryTime: " ",
                                PCBdhlCost: double.parse("0.0"),
                                PCBAJPercentage: double.parse("0.0"),
                                PCBReleasePercentage: double.parse("0.0"),
                                PCBPurchase: double.parse("0.0"),
                                PCBShipment: double.parse("0.0"),
                                PCBTax: double.parse("0.0"),
                                PCBRelease: double.parse("0.0"),
                                PCBAJ: double.parse("0.0"),
                                PCBTotalUSD: double.parse("0.0"),
                                PCBTotalMXN: double.parse("0.0"),
                                PCBPerMXN: double.parse("0.0"),
                                assemblyLayers: faces,
                                assemblyMPN: int.parse(MPN.text),
                                assemblySMT: int.parse(SMT.text),
                                assemblyTH: int.parse(TH.text),
                                assemblyDeliveryTime: ensambleTime.text,
                                assemblyAJPercentage:
                                    double.parse(porcentajeAjEnsamble.text),
                                assembly: double.parse(ensamble.text),
                                assemblyTax:
                                    double.parse(ensambleImpuesto.text),
                                assemblyAJ: double.parse(ensambleAJ.text),
                                assemblyTotalMXN: double.parse(
                                    ensambleTotalPesos.text
                                        .replaceAll(",", "")),
                                perAssemblyMXN: double.parse(
                                    ensamblePerPesos.text.replaceAll(",", "")),
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Preview_Assemblies(
                                          isSavedQuote: isPressed,
                                          quote: quote!,
                                          customer: widget.customer)));
                            }
                          }
                        }
                      }
                    }
                  } else {
                    wrongPopup(context, "Save the quote first");
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).pop();
                    });
                  }
                }))
      ],
    );
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

  Widget Informative() {
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
                        quantity,
                        "Quantity",
                        TextInputType.number,
                        FilteringTextInputFormatter.digitsOnly,
                        quantityOperactions(),
                        false),
                    fieldQuotesOperations(
                        dollarSell,
                        "Dollar Sell",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        dollarSellOperations(),
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
                                          porcentajeAjComponents.text = "1.0";
                                        case "30 days":
                                          porcentajeAjComponents.text = "1.1";
                                          break;
                                        case "60 days":
                                          porcentajeAjComponents.text = "1.15";
                                          break;
                                        case "90 days":
                                          porcentajeAjComponents.text = "1.2";
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
                                        dollarSellOperationsDropdown(1.0);
                                      } else {
                                        dollarBuy.text = "18";
                                        dollarSell.text = "20";
                                        usdOrMxn = "MXN";
                                        dollarSellOperationsDropdown(20.0);
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
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Add Components",
                            style: TextStyle(
                              color: Colors.teal,
                            ),
                          ),
                          Checkbox(
                              value: addComponents,
                              onChanged: (value) {
                                setState(() {
                                  addComponents = value!;
                                });
                              }),
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
                            "Add PCB",
                            style: TextStyle(
                              color: Colors.teal,
                            ),
                          ),
                          Checkbox(
                              value: addPCB,
                              onChanged: (value) {
                                setState(() {
                                  addPCB = value!;
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

  Widget Components() {
    return Visibility(
      visible: addComponents,
      child: Form(
        key: _formKeyComponents,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: Colors.teal,
              margin: EdgeInsets.only(top: 50),
              child: Text("Components",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white)),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fieldDeliver(excelName, "Excel name", TextInputType.text,
                          FilteringTextInputFormatter.singleLineFormatter),
                      fieldDeliver(
                          componentsNumber,
                          "Components to buy (MPN)",
                          TextInputType.number,
                          FilteringTextInputFormatter.digitsOnly),
                      fieldDeliver(
                          componentsAvailable,
                          "Components not availables",
                          TextInputType.number,
                          FilteringTextInputFormatter.digitsOnly),
                      fieldDeliver(
                          deliverComponent,
                          "Delivery time",
                          TextInputType.text,
                          FilteringTextInputFormatter.singleLineFormatter),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
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
                                  TextInputType.numberWithOptions(
                                      decimal: true),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                                  operationComponentsIVA(),
                                  150),
                              SizedBox(height: 10),
                              fieldPercentages(
                                  porcentajeIsr,
                                  Icon(Icons.percent),
                                  "ISR",
                                  TextInputType.numberWithOptions(
                                      decimal: true),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                                  operationComponentsISR(),
                                  150),
                              SizedBox(height: 10),
                              fieldPercentages(
                                  dhlCostComponent,
                                  Icon(FontAwesome.dollar),
                                  "DHL Cost (USD)",
                                  TextInputType.numberWithOptions(
                                      decimal: true),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                                  operationComponentsDHL(),
                                  150),
                              SizedBox(height: 10),
                              fieldPercentages(
                                  porcentajeAjComponents,
                                  Icon(Icons.percent),
                                  "AJ components",
                                  TextInputType.numberWithOptions(
                                      decimal: true),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                                  operationComponentsAJ(),
                                  150),
                              SizedBox(height: 10),
                              fieldPercentages(
                                  porcentajeAjDigikey,
                                  Icon(Icons.percent),
                                  "AJ Digikey",
                                  TextInputType.numberWithOptions(
                                      decimal: true),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                                  operationComponentsAJDigikey(),
                                  150),
                            ],
                          ),
                        ),
                        //Components
                        Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 0),
                                child: fieldQuotesOperations(
                                    mouser,
                                    "Mouser cost (USD)",
                                    TextInputType.numberWithOptions(
                                        decimal: true),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^(\d+)?\.?\d{0,2}')),
                                    operationComponents(),
                                    false),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: fieldQuotesOperations(
                                    ivaComponents,
                                    "IVA components (USD)",
                                    TextInputType.numberWithOptions(
                                        decimal: true),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^(\d+)?\.?\d{0,2}')),
                                    operationComponentsEmpty(),
                                    true),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: fieldQuotesOperations(
                                    ajComponents,
                                    "AJ components (USD)",
                                    TextInputType.numberWithOptions(
                                        decimal: true),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^(\d+)?\.?\d{0,2}')),
                                    operationComponentsEmpty(),
                                    true),
                              ),
                            ],
                          ),
                        ),
                        //Digikeys
                        Form(
                          key: _formKeyDigikey,
                          child: Container(
                            margin: EdgeInsets.only(top: 45),
                            child: Column(
                              children: [
                                Center(
                                  child: fieldQuotesOperations(
                                      digikeyComponents,
                                      "Digikey (USD)",
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      operationComponentsDigikey(),
                                      false),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: fieldQuotesOperations(
                                      impuestosComponents,
                                      "Tax (USD)",
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      operationComponentsEmpty(),
                                      true),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: fieldQuotesOperations(
                                      ajDigikeyComponents,
                                      "AJ digikey (USD)",
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      operationComponentsEmpty(),
                                      true),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // -------------- Button more -------------- //
                                Container(
                                  alignment: Alignment.topRight,
                                  height: 35,
                                  child: FloatingActionButton(
                                      backgroundColor: Colors.teal,
                                      child: const Icon(
                                        Entypo.plus,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        double totalComponentsDllsTotal = 0.0;
                                        setState(() {
                                          if (_formKeyDigikey.currentState!
                                              .validate()) {
                                            products.add(DigikeyClass(
                                                digikey: double.parse(
                                                    digikeyComponents.text),
                                                impuesto: double.parse(
                                                    impuestosComponents.text),
                                                aj: double.parse(
                                                    ajDigikeyComponents.text)));
                                            for (var i = 0;
                                                i < products.length;
                                                i++) {
                                              totalComponentsDllsTotal +=
                                                  products[i].aj!;
                                            }
                                            totalComponentsDlls.text =
                                                formatter.format((double.parse(
                                                        ajComponents.text) +
                                                    totalComponentsDllsTotal));
                                            totalComponentsPesos
                                                .text = formatter.format((((double
                                                        .parse(
                                                            ajComponents.text) +
                                                    totalComponentsDllsTotal)) *
                                                double.parse(dollarSell.text)));
                                            perComponentsPesos
                                                .text = formatter.format(((((double
                                                            .parse(ajComponents
                                                                .text) +
                                                        totalComponentsDllsTotal)) *
                                                    double.parse(
                                                        dollarSell.text)) /
                                                int.parse(quantity.text)));
                                            digikeyComponents.clear();
                                            impuestosComponents.clear();
                                            ajDigikeyComponents.clear();
                                          }
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Table
                        SelectionArea(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: DataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                columns: <DataColumn>[
                                  DataColumn(label: Text('Digikey (USD)')),
                                  DataColumn(label: Text('Impuestos (USD)')),
                                  DataColumn(label: Text('AJ (USD)')),
                                  DataColumn(label: Text('Delete/Edit'))
                                ],
                                rows: products
                                    .map<DataRow>((DigikeyClass product) {
                                  return DataRow(cells: <DataCell>[
                                    DataCell(Text(product.digikey!.toString())),
                                    DataCell(Text(
                                        "\$ ${formatter.format(product.impuesto)}")),
                                    DataCell(Text(
                                        "\$ ${formatter.format(product.aj!)}")),
                                    DataCell(SizedBox(
                                        //width: 15,
                                        child: Row(
                                      children: [
                                        IconButton(
                                          //splashRadius: 15,
                                          onPressed: () {
                                            setState(() {
                                              products.remove(product);
                                              totalComponentsDlls.text =
                                                  formatter.format((double.parse(
                                                          totalComponentsDlls
                                                              .text
                                                              .replaceAll(
                                                                  ",", "")) -
                                                      product.aj!));
                                              totalComponentsPesos.text =
                                                  formatter.format((double.parse(
                                                          totalComponentsDlls
                                                              .text
                                                              .replaceAll(
                                                                  ",", "")) *
                                                      double.parse(
                                                          dollarSell.text)));
                                              perComponentsPesos.text =
                                                  formatter.format((double.parse(
                                                          totalComponentsPesos
                                                              .text
                                                              .replaceAll(
                                                                  ",", "")) /
                                                      double.parse(
                                                          quantity.text)));
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
                                              totalComponentsDlls.text =
                                                  formatter.format((double.parse(
                                                          totalComponentsDlls
                                                              .text
                                                              .replaceAll(
                                                                  ",", "")) -
                                                      product.aj!));
                                              totalComponentsPesos.text =
                                                  formatter.format((double.parse(
                                                          totalComponentsDlls
                                                              .text
                                                              .replaceAll(
                                                                  ",", "")) *
                                                      double.parse(
                                                          dollarSell.text)));
                                              perComponentsPesos.text =
                                                  formatter.format((double.parse(
                                                          totalComponentsPesos
                                                              .text
                                                              .replaceAll(
                                                                  ",", "")) /
                                                      double.parse(
                                                          quantity.text)));
                                              digikeyComponents.text =
                                                  product.digikey.toString();
                                              impuestosComponents.text =
                                                  product.impuesto.toString();
                                              ajDigikeyComponents.text =
                                                  product.aj.toString();
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
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        fieldQuotesOperations(
                            totalComponentsDlls,
                            "Total components (USD)",
                            TextInputType.numberWithOptions(decimal: true),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                            operationComponentsEmpty(),
                            true),
                        fieldQuotesOperationsusdOrMxn(
                            totalComponentsPesos,
                            "Total components",
                            TextInputType.numberWithOptions(decimal: true),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                            operationComponentsEmpty(),
                            true,
                            usdOrMxn),
                        fieldQuotesOperationsusdOrMxn(
                            perComponentsPesos,
                            "Per component",
                            TextInputType.numberWithOptions(decimal: true),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}')),
                            operationComponentsEmpty(),
                            true,
                            usdOrMxn)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget PCB() {
    return Visibility(
      visible: addPCB,
      child: Form(
        key: _formKeyPCB,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: Colors.teal,
              margin: EdgeInsets.only(top: 50),
              child: Text("PCB's",
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
                      fieldDeliver(pcbName, "PCB name", TextInputType.text,
                          FilteringTextInputFormatter.singleLineFormatter),
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
                                        return 'Layers is required';
                                      }
                                      return null;
                                    },
                                    style: fieldStyle,
                                    decoration: InputDecoration(
                                        labelText: "* Layers",
                                        labelStyle: TextStyle(
                                          color: Colors.teal,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.green),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.redAccent),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.redAccent),
                                        )),
                                    isExpanded: true,
                                    hint: Text("--Select Option--",
                                        style: fieldStyle),
                                    items: [
                                      DropdownMenuItem<String>(
                                          child: Text(
                                            '2 Layers',
                                            style: fieldStyle,
                                          ),
                                          value: '2 Layers'),
                                      DropdownMenuItem<String>(
                                          child: Text(
                                            '4 Layers',
                                            style: fieldStyle,
                                          ),
                                          value: '4 Layers'),
                                      DropdownMenuItem<String>(
                                          child: Text(
                                            '6 Layers',
                                            style: fieldStyle,
                                          ),
                                          value: '6 Layers'),
                                      DropdownMenuItem<String>(
                                          child: Text(
                                            '8 Layers',
                                            style: fieldStyle,
                                          ),
                                          value: '8 Layers'),
                                      DropdownMenuItem<String>(
                                          child: Text(
                                            '10 Layers',
                                            style: fieldStyle,
                                          ),
                                          value: '10 Layers')
                                    ],
                                    value: layers,
                                    onChanged: (value) {
                                      setState(() {
                                        layers = value;
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      fieldDeliver(pcbSize, "Size", TextInputType.text,
                          FilteringTextInputFormatter.singleLineFormatter),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      imageFieldWidget(),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 360,
                          child: DropdownButtonFormField(
                              validator: (value) {
                                if (value == null) {
                                  return 'Color is required';
                                }
                                return null;
                              },
                              style: fieldStyle,
                              decoration: InputDecoration(
                                  labelText: "* Colors",
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
                                    borderSide: const BorderSide(
                                        color: Colors.redAccent),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.redAccent),
                                  )),
                              isExpanded: true,
                              hint:
                                  Text("--Select Option--", style: fieldStyle),
                              items: [
                                DropdownMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Green',
                                          style: fieldStyle,
                                        ),
                                      ],
                                    ),
                                    value: 'Green'),
                                DropdownMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.purple,
                                              shape: BoxShape.circle),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Purple',
                                          style: fieldStyle,
                                        ),
                                      ],
                                    ),
                                    value: 'Purple'),
                                DropdownMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Red',
                                          style: fieldStyle,
                                        ),
                                      ],
                                    ),
                                    value: 'Red'),
                                DropdownMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              shape: BoxShape.circle),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Yellow',
                                          style: fieldStyle,
                                        ),
                                      ],
                                    ),
                                    value: 'Yellow'),
                                DropdownMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Blue',
                                          style: fieldStyle,
                                        ),
                                      ],
                                    ),
                                    value: 'Blue'),
                                DropdownMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'White',
                                          style: fieldStyle,
                                        ),
                                      ],
                                    ),
                                    value: 'White'),
                                DropdownMenuItem<String>(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Black',
                                          style: fieldStyle,
                                        ),
                                      ],
                                    ),
                                    value: 'Black')
                              ],
                              value: color,
                              onChanged: (value) {
                                setState(() {
                                  color = value;
                                });
                              }),
                        ),
                      ),
                      fieldDeliver(pcbTime, "Time delivery", TextInputType.text,
                          FilteringTextInputFormatter.singleLineFormatter),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Porcentajes
                            Container(
                              child: Column(
                                children: [
                                  fieldPercentages(
                                      porcentajeIva,
                                      Icon(Icons.percent),
                                      "Iva",
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      operetionPCBIVA(),
                                      150),
                                  SizedBox(height: 10),
                                  fieldPercentages(
                                      porcentajeIsr,
                                      Icon(Icons.percent),
                                      "ISR",
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      operetionPCBISR(),
                                      150),
                                  SizedBox(height: 10),
                                  fieldPercentages(
                                      dhlCostPCB,
                                      Icon(FontAwesome.dollar),
                                      "DHL Cost (USD)",
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      operetionPCBDHLCost(),
                                      150),
                                  SizedBox(height: 10),
                                  fieldPercentages(
                                      porcentajeAjPCB,
                                      Icon(Icons.percent),
                                      "AJ PCB",
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      operetionPCBAJ(),
                                      150),
                                  SizedBox(height: 10),
                                  fieldPercentages(
                                      porcentajeLiberacion,
                                      Icon(Icons.percent),
                                      "Release",
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^(\d+)?\.?\d{0,2}')),
                                      operetionPCBLiberacion(),
                                      150),
                                ],
                              ),
                            ),
                            //Components
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 0),
                                    child: fieldQuotesOperations(
                                        pcbCompra,
                                        "PCB purchase (USD)",
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        operationPCBPurchase(),
                                        false),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: fieldQuotesOperations(
                                        pcbEnvio,
                                        "Shipment (USD)",
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        operationPCBShipment(),
                                        false),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: fieldQuotesOperations(
                                        pcbImpuesto,
                                        "Tax (USD)",
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        operationComponentsEmpty(),
                                        true),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: fieldQuotesOperations(
                                        pcbLiberacion,
                                        "Release (USD)",
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        operationComponentsEmpty(),
                                        true),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: fieldQuotesOperations(
                                        pcbTotal,
                                        "Total (USD)",
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        operationComponentsEmpty(),
                                        true),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fieldQuotesOperations(
                          pcbAJ,
                          "PCB AJ (USD)",
                          TextInputType.numberWithOptions(decimal: true),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                          operationComponentsEmpty(),
                          true),
                      fieldQuotesOperationsusdOrMxn(
                          pcbTotalPesos,
                          "Total",
                          TextInputType.numberWithOptions(decimal: true),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                          operationComponentsEmpty(),
                          true,
                          usdOrMxn),
                      fieldQuotesOperationsusdOrMxn(
                          pcbPerPesos,
                          "Per PCB",
                          TextInputType.numberWithOptions(decimal: true),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                          operationComponentsEmpty(),
                          true,
                          usdOrMxn),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Assembly() {
    return Form(
      key: _formKeyAssemblies,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: Colors.teal,
            margin: EdgeInsets.only(top: 50),
            child: Text("Assembly",
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
                    fieldDeliver(
                        proyectName,
                        "Proyect name",
                        TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 360,
                              child: DropdownButtonFormField<String>(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Layers is required';
                                    }
                                    return null;
                                  },
                                  style: fieldStyle,
                                  decoration: InputDecoration(
                                      labelText: "* Layers",
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
                                          '1 Layer',
                                          style: fieldStyle,
                                        ),
                                        value: "1 Layer"),
                                    DropdownMenuItem<String>(
                                        child: Text(
                                          '2 Layers',
                                          style: fieldStyle,
                                        ),
                                        value: "2 Layers")
                                  ],
                                  //value: faces,
                                  onChanged: (value) {
                                    setState(() {
                                      faces = value!;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    fieldDeliver(MPN, "MPN", TextInputType.number,
                        FilteringTextInputFormatter.digitsOnly),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fieldDeliver(SMT, "SMT", TextInputType.number,
                        FilteringTextInputFormatter.digitsOnly),
                    fieldDeliver(TH, "TH", TextInputType.number,
                        FilteringTextInputFormatter.digitsOnly),
                    fieldDeliver(
                        ensambleTime,
                        "Time delivery",
                        TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Porcentajes
                              Container(
                                child: Column(
                                  children: [
                                    fieldPercentages(
                                        porcentajeIva,
                                        Icon(Icons.percent),
                                        "Iva",
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        operationEnsambleIVA(),
                                        150),
                                    SizedBox(height: 10),
                                    fieldPercentages(
                                        porcentajeIsr,
                                        Icon(Icons.percent),
                                        "ISR",
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        operationEnsambleISR(),
                                        150),
                                    SizedBox(height: 10),
                                    fieldPercentages(
                                        porcentajeAjEnsamble,
                                        Icon(Icons.percent),
                                        "AJ Assembly",
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                                        operationEnsambleAJ(),
                                        150),
                                  ],
                                ),
                              ),
                              //Components
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      child: fieldQuotesOperations(
                                          ensamble,
                                          "Assembly (USD)",
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                                          operationEnsamble(),
                                          false),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: fieldQuotesOperations(
                                          ensambleImpuesto,
                                          "Tax (USD)",
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                                          operationComponentsEmpty(),
                                          true),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: fieldQuotesOperations(
                                          ensambleAJ,
                                          "Aj (USD)",
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^(\d+)?\.?\d{0,2}')),
                                          operationComponentsEmpty(),
                                          true),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fieldQuotesOperationsusdOrMxn(
                        ensambleTotalPesos,
                        "Total",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        true,
                        usdOrMxn),
                    fieldQuotesOperationsusdOrMxn(
                        ensamblePerPesos,
                        "Per assembly",
                        TextInputType.numberWithOptions(decimal: true),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}')),
                        operationComponentsEmpty(),
                        true,
                        usdOrMxn),
                  ],
                )
              ],
            ),
          )
        ],
      ),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Image is required';
              }
              return null;
            },
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
              labelText: "* Image",
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
}

TextStyle get labelStyle {
  return GoogleFonts.nunito(color: Colors.grey, fontSize: 14);
}

TextStyle get normalBlackStyle {
  return GoogleFonts.nunito(color: Colors.black, fontSize: 12);
}

TextStyle get buttonWhite {
  return GoogleFonts.nunito(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
}
