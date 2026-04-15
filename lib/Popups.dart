// ********************************************** Remove Athlete Popup *******************************************\\
// ignore: non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:guadalajarav2/utils/helperPDFExportQuotes.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/productClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/widgets/Texts.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/PDF/PDFDeliveryUnified.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteTableClass.dart';
import 'package:guadalajarav2/views/Quotes/PDFWidgets/ExportUnificatedPDF.dart';
import 'package:pdf/pdf.dart';
import 'utils/colors.dart';
import 'utils/tools.dart';
import 'views/Delivery_Certificate/Controllers/DAO.dart';

void PDFLanguage(context, id_OC, entrega, ordenCompra, nombreEmpresa,
    List<ProductCertificateDelivery> productos, moneda, totalProducts) async {
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
                    DeliveryCertificatePDF(
                      isEnglish: false,
                      idOC: id_OC,
                      entrega: entrega,
                      ordenCompra: ordenCompra.toString(),
                      nombreEmpresa: nombreEmpresa,
                      products: productos,
                      totalProducts: totalProducts,
                      moneda: moneda,
                    ).createPDF(PdfPageFormat.a3).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  child: Text('English', style: buttonsPopUp),
                  onPressed: () async {
                    DeliveryCertificatePDF(
                      isEnglish: true,
                      idOC: id_OC,
                      entrega: entrega,
                      ordenCompra: ordenCompra.toString(),
                      nombreEmpresa: nombreEmpresa,
                      products: productos,
                      totalProducts: totalProducts,
                      moneda: moneda,
                    ).createPDF(PdfPageFormat.a3).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ));
      });
}

Future<void> showQuoteExportDialog({
  required BuildContext context,
  required QuoteType type,
  required bool isPDF,
  required bool addPCB,
  required bool addComponents,
  required List<QuoteTableClass> dataTable,
  required QuoteClass quote,
  required CustomersClass customer,
  String notes = '',
  final bool notesEdited = false, // <-- NUEVO: true si el usuario modificó algo
  PdfPageFormat pageFormat = PdfPageFormat.a3,
}) async {
  bool isExporting = false;

  await showCupertinoDialog(
    context: context,
    barrierDismissible: !isExporting, // mientras exporta, no permitir cerrar
    builder: (dialogCtx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> _doExport({required bool english}) async {
            if (isExporting) return;
            setState(() => isExporting = true);

            try {
              // Log útil para confirmar que sí entra aquí:
              // ignore: avoid_print
              print('[Export] start | type=$type | en=$english | isPDF=$isPDF');
              final resolvedNotes = resolveNotesForExport(
                currentNotes: notes,
                isEnglish: english,
              );
              await ExportToPDFUnified(
                      type: type,
                      isPDF: isPDF,
                      isEnglish: english,
                      customer: customer,
                      quote: quote,
                      dataTable: dataTable,
                      notes: resolvedNotes,
                      addComponents: addComponents,
                      addPCB: addPCB,
                      notesEdited: notesEdited)
                  .createPDF(pageFormat);

              // ignore: avoid_print
              print('[Export] done OK');
              if (Navigator.of(dialogCtx).canPop()) {
                Navigator.of(dialogCtx).pop(); // cerrar popup
              }
              // Aquí puedes enseñar un snackbar si quieres
            } catch (e, st) {
              // ignore: avoid_print
              print('[Export] ERROR: $e\n$st');
              if (Navigator.of(dialogCtx).canPop()) {
                Navigator.of(dialogCtx).pop();
              }
              // Muestra un error rápido
              // (ajústalo a tu propio PopupError si prefieres)
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al exportar: $e')),
              );
            } finally {
              // Por si el diálogo siguiera abierto por alguna razón:
              if (Navigator.of(dialogCtx).canPop()) {
                Navigator.of(dialogCtx).pop();
              }
            }
          }

          return CupertinoAlertDialog(
            title: Text('Language / Idioma'),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: isExporting
                  ? Column(
                      children: const [
                        SizedBox(height: 8),
                        CupertinoActivityIndicator(),
                        SizedBox(height: 8),
                        Text('Exportando…'),
                      ],
                    )
                  : const Text('Select the language of the document please'),
            ),
            actions: isExporting
                ? const [] // Mientras exporta, sin botones
                : [
                    CupertinoDialogAction(
                      onPressed: () => _doExport(english: false),
                      child: const Text('Español'),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => _doExport(english: true),
                      child: const Text('English'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        if (!isExporting && Navigator.of(dialogCtx).canPop()) {
                          Navigator.of(dialogCtx).pop();
                        }
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
          );
        },
      );
    },
  );
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
                        await ExportToPDFUnified(
                                type:
                                    QuoteType.assembly, // o QuoteType.assembly
                                isPDF: true,
                                isEnglish: false,
                                customer: customer!,
                                quote: quote!,
                                dataTable: dataTable!,
                                notes: notes ?? '',
                                // solo si type == assembly:
                                addComponents: true,
                                addPCB: true,
                                notesEdited: false)
                            .createPDF(PdfPageFormat.a3);
                      } else {
                        await ExportToPDFUnified(
                                type: QuoteType
                                    .manufacture, // o QuoteType.assembly
                                isPDF: true,
                                isEnglish: false,
                                customer: customer!,
                                quote: quote!,
                                dataTable: dataTable!,
                                notes: notes ?? '',
                                // solo si type == assembly:
                                addComponents: true,
                                addPCB: true,
                                notesEdited: false)
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
                        await ExportToPDFUnified(
                                type:
                                    QuoteType.assembly, // o QuoteType.assembly
                                isPDF: true,
                                isEnglish: true,
                                customer: customer!,
                                quote: quote!,
                                dataTable: dataTable!,
                                notes: notes ?? '',
                                // solo si type == assembly:
                                addComponents: true,
                                addPCB: true,
                                notesEdited: false)
                            .createPDF(PdfPageFormat.a3);
                      } else {
                        await ExportToPDFUnified(
                                type: QuoteType
                                    .manufacture, // o QuoteType.assembly
                                isPDF: true,
                                isEnglish: true,
                                customer: customer!,
                                quote: quote!,
                                dataTable: dataTable!,
                                notes: notes ?? '',
                                // solo si type == assembly:
                                addComponents: true,
                                addPCB: true,
                                notesEdited: false)
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
                        List<ProductCertificateDelivery>
                            allProductsPerDelivery = [];
                        List<ProductCertificateDelivery> productsPerDelivery =
                            await DataAccessObject.getProductosOC();

                        for (var i = 0; i < productsPerDelivery.length; i++) {
                          if (productsPerDelivery[i].id_entrega == id) {
                            allProductsPerDelivery.add(productsPerDelivery[i]);
                          }
                        }
                        for (var i = 0;
                            i < allProductsPerDelivery.length;
                            i++) {
                          await DataAccessObject.deleteProductOC(
                              allProductsPerDelivery[i].id_producto);
                        }

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

GeneralLinearProgressIndicator(context) async {
  //DeviceAV device;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(primaryColor: Colors.white24),
            child: CupertinoAlertDialog(
              title: Text(
                'Copying',
                style: titlePopUp,
              ),
              content: LinearProgressIndicator(
                backgroundColor: Colors.white54,
                color: teal,
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
              ),
            ));
      });
}
