// ********************************************** Remove Athlete Popup *******************************************\\
// ignore: non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/productClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/widgets/Texts.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/PDF/PDFEnglish.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/PDF/PDFSpanish.dart';
import 'package:guadalajarav2/views/Quotes/Manofacture/PDFManofacture.dart';
import 'package:pdf/pdf.dart';
import '../../../utils/tools.dart';
import '../../Quotes/Assemblies/ExportToPDF.dart';
import '../Controllers/DAO.dart';
import '../admin_OC/ChooseCompany.dart';

void PDFLanguage(context, id_OC, entrega, ordenCompra, nombreEmpresa,
    List<ProductCertificateDelivery> productos, moneda) async {
  //DeviceAV device;
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(primaryColor: Colors.white24),
            child: CupertinoAlertDialog(
              title: Text(
                'Language/Idioma',
                style: titlePopUp,
              ),
              content: Text(
                "Select the language of the document please",
                style: contentPopUp,
              ),
              actions: [
                TextButton(
                  child: Text('Spanish', style: buttonsPopUp),
                  onPressed: () async {
                    printPDFSpanish(
                            id_OC: id_OC,
                            entrega: entrega,
                            ordenCompra: ordenCompra.toString(),
                            nombreEmpresa: nombreEmpresa,
                            products: productos,
                            moneda: moneda)
                        .createPDF(PdfPageFormat.a3)
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChooseCompany()));
                    });
                  },
                ),
                TextButton(
                  child: Text('English', style: buttonsPopUp),
                  onPressed: () async {
                    printPDFEnglish(
                            id_OC: id_OC,
                            entrega: entrega,
                            ordenCompra: ordenCompra.toString(),
                            nombreEmpresa: nombreEmpresa,
                            products: productos,
                            moneda: moneda)
                        .createPDF(PdfPageFormat.a3)
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChooseCompany()));
                    });
                  },
                )
              ],
            ));
      });
}

void PDFLanguageQuotes(context, addPCB, addComponents, dataTable, quote,
    customer, isPDF, notes, type) async {
  //DeviceAV device;
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(primaryColor: Colors.white24),
            child: CupertinoAlertDialog(
              title: Text(
                'Language/Idioma',
                style: titlePopUp,
              ),
              content: Text(
                "Select the language of the document please",
                style: contentPopUp,
              ),
              actions: [
                TextButton(
                  child: Text('Spanish', style: buttonsPopUp),
                  onPressed: () async {
                    bool onErrore = false;

                    try {
                      if (type == "assemblies") {
                        await ExportToPDFAssemblies(
                                isPDF: isPDF,
                                isEnglish: false,
                                addPCB: addPCB,
                                addComponents: addComponents,
                                dataTable: dataTable,
                                quote: quote,
                                customer: customer,
                                notes: notes)
                            .createPDF(PdfPageFormat.a3);
                      } else {
                        await ExportToPDFManofacture(
                                isPDF: isPDF,
                                isEnglish: false,
                                dataTable: dataTable,
                                quote: quote,
                                customer: customer,
                                notes: notes)
                            .createPDF(PdfPageFormat.a3);
                      }
                    } catch (e) {
                      print("Error my broo $e");
                      onErrore = true;
                    }
                    if (onErrore) {
                      print("Error my broo pero entree");
                      PopupError(context);
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      Navigator.of(context).pop();
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => CotizacionesHome()),
                      //     (route) => false);
                    }
                  },
                ),
                TextButton(
                  child: Text('English', style: buttonsPopUp),
                  onPressed: () async {
                    bool onErrore = false;
                    try {
                      if (type == "assemblies") {
                        await ExportToPDFAssemblies(
                                isPDF: isPDF,
                                isEnglish: true,
                                addPCB: addPCB,
                                addComponents: addComponents,
                                dataTable: dataTable,
                                quote: quote,
                                customer: customer,
                                notes: notes)
                            .createPDF(PdfPageFormat.a3);
                      } else {
                        await ExportToPDFManofacture(
                                isPDF: isPDF,
                                isEnglish: true,
                                dataTable: dataTable,
                                quote: quote,
                                customer: customer,
                                notes: notes)
                            .createPDF(PdfPageFormat.a3);
                      }
                    } catch (e) {
                      print("Error my broo $e");
                      onErrore = true;
                    }
                    if (onErrore) {
                      print("Error my broo pero entree");
                      PopupError(context);
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      Navigator.of(context).pop();
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => CotizacionesHome()),
                      //     (route) => false);
                    }
                  },
                )
              ],
            ));
      });
}

void succesfullyPopUp(context, text) async {
  //DeviceAV device;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(primaryColor: Colors.white24),
            child: CupertinoAlertDialog(
              title: Text(
                '$text',
                style: titlePopUp,
              ),
            ));
      });
}

void wrongPopup(context, message) async {
  //DeviceAV device;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(primaryColor: Colors.white24),
            child: CupertinoAlertDialog(
              title: Text(
                message,
                style: titlePopUp,
              ),
              content: Text(
                "Please try again",
                style: contentPopUp,
              ),
            ));
      });
}

void GoodPopup(context, message) async {
  //DeviceAV device;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(primaryColor: Colors.white24),
            child: CupertinoAlertDialog(
                title: Text(
                  message,
                  style: titlePopUp,
                ),
                content: Icon(Entypo.check)));
      });
}

void deleteCustomerPopUp(context) async {
  //DeviceAV device;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(primaryColor: Colors.white24),
            child: CupertinoAlertDialog(
              title: Text(
                'Delete Succesfully',
                style: titlePopUp,
              ),
            ));
      });
}

void confirmationDeleteCustomer(context, id, name, where) async {
  //DeviceAV device;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(primaryColor: Colors.white24),
            child: CupertinoAlertDialog(
              title: Text(
                'Do you want to delete it?',
                style: titlePopUp,
              ),
              content: Text(
                "This action can not be undone",
                style: contentPopUp,
              ),
              actions: [
                TextButton(
                  child: Text('Accept', style: buttonsPopUp),
                  onPressed: () async {
                    int? result;
                    switch (name) {
                      case "customer":
                        result = await DataAccessObject.deleteCustomer(id);
                        break;
                      case "oc":
                        result = await DataAccessObject.deleteOC(id);
                        break;
                      case "entrega":
                        result = await DataAccessObject.deleteEntrega(id);
                        break;
                      case "quote":
                        result = await DataAccessObject.deleteQuote(id);
                        break;
                      default:
                    }
                    if (result == 200) {
                      deleteCustomerPopUp(context);
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => where));
                      });
                    } else {
                      deleteCustomerPopUp(context);
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pop(context);
                      });
                    }
                  },
                ),
                TextButton(
                  child: Text('Cancel', style: buttonsCancelPopUp),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      });
}
