// ignore_for_file: camel_case_types, file_names, avoid_web_libraries_in_flutter, depend_on_referenced_packages
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CertificadoEntregaClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/productClass.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'dart:html' as html;
import 'package:printing/printing.dart';

import '../../../main.dart';

class printPDFSpanish {
  int id_OC;
  ClassCertificadoEntrega entrega;
  String? ordenCompra;
  String? nombreEmpresa;
  String? moneda;
  List<ProductCertificateDelivery> products = [];

  printPDFSpanish(
      {required this.id_OC,
      required this.entrega,
      required this.ordenCompra,
      required this.nombreEmpresa,
      required this.products,
      required this.moneda});
  List<ClassCertificadoEntrega> entregas = [];

  getEntregas() async {
    entregas = await DataAccessObject.selectEntrega(id_OC);
  }

  Future<void> createPDF(final PdfPageFormat format) async {
    await getEntregas();

    List splitDate = entrega.Fecha!.split("-");
    String date1 = splitDate[1];
    String date2 = splitDate[2];
    if (int.parse(splitDate[1]) < 10) {
      date1 = "0${splitDate[1]}";
    } else if (int.parse(splitDate[2]) < 10) {
      date2 = "0${splitDate[2]}";
    }
    String newDate = "${splitDate[0]}-$date1-$date2";
    DateTime newDateTime = DateTime.parse(newDate);
    entrega.Fecha = DateFormat('MMMM/d/yyyy').format(newDateTime);
    double subTotal = 0.0;
    double total = 0.0;
    double iva = 0.0;
    List<TotalProduct> totalList = [];
    NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final headers = [
      "Cantidad",
      "Descripción",
      "Precio Unitario\n($moneda)",
      "Importe\n($moneda)"
    ];
    for (var i = 0; i < products.length; i++) {
      subTotal = subTotal + products[i].importe!;
    }
    iva = (subTotal * 1.16) - subTotal;
    total = subTotal + iva;
    totalList = [
      TotalProduct(string: "IVA", int: "\$ ${formatter.format(iva)}"),
      TotalProduct(string: "Total", int: "\$ ${formatter.format(total)}"),
    ];

    print("Sub total = $subTotal, Iva: $iva, Total: $total");
    final headersTotal = ["Sub-Total", "\$ ${formatter.format(subTotal)}"];
    final dataTotal = totalList
        .map((totalList) => [totalList.string, totalList.int])
        .toList();
    final data = products
        .map((procuct) => [
              procuct.cantidad,
              procuct.descripcion,
              "\$ ${formatter.format(procuct.precioUnitario)}",
              "\$ ${formatter.format(procuct.importe!)}"
            ])
        .toList();
    final logo = pw.MemoryImage(
        (await rootBundle.load('assets/images/headerPDF.png'))
            .buffer
            .asUint8List());
    var fonth1 = await PdfGoogleFonts.tinosBold();
    var body = await PdfGoogleFonts.openSansMedium();
    var bodyBold = await PdfGoogleFonts.openSansBold();
    final pdf = pw.Document();
    final pageTheme = await _mypageTheme(format);
    print("Date: $newDate");
    pdf.addPage(pw.MultiPage(
        pageTheme: pageTheme,
// ****************************************** Header ****************************************** \\
        header: (final context) => pw.Image(logo,
            alignment: pw.Alignment.topLeft,
            fit: pw.BoxFit.contain,
            width: 565,
            height: 125),
// ****************************************** Footer ****************************************** \\
        footer: (final context) => pw.Container(
            margin: pw.EdgeInsets.only(bottom: 10),
            alignment: pw.Alignment.center,
            child: pw.Opacity(
                opacity: 0.5,
                child: pw.RichText(
                    textAlign: pw.TextAlign.center,
                    text: pw.TextSpan(children: [
                      pw.TextSpan(
                          text:
                              "Enrique Díaz de León 157, Miguel de la Madrid, Zapopan Jalisco\n",
                          style: pw.TextStyle(
                              font: body, fontSize: 10, height: 1.5)),
                      pw.TextSpan(
                          text: "Tel: 33 27 33 09 62\n",
                          style: pw.TextStyle(
                              font: body, fontSize: 10, height: 1.5)),
                      pw.TextSpan(
                          text: "contact@aj-electronic-design.com    ",
                          style: pw.TextStyle(
                              font: body, fontSize: 10, height: 1.5)),
                      pw.TextSpan(
                          text: "aj-electronic-design.com",
                          style: pw.TextStyle(
                              font: body,
                              fontSize: 10,
                              height: 1.5,
                              decoration: pw.TextDecoration.underline))
                    ])))),
// ****************************************** Delivery info ****************************************** \\
        build: (pw.Context context) => [
              pw.Column(children: [
                pw.Container(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text('CERTIFICADO DE ENTREGA',
                        style: pw.TextStyle(
                            font: fonth1,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold))),
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 40),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.RichText(
                              text: pw.TextSpan(children: [
                            pw.TextSpan(
                                text: "Folio: ",
                                style: pw.TextStyle(
                                    font: body,
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.TextSpan(
                                text: entrega.certificadoEntrega,
                                style: pw.TextStyle(
                                    font: body,
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold))
                          ])),
                          pw.RichText(
                              text: pw.TextSpan(children: [
                            pw.TextSpan(
                                text: "Orden de compra: ",
                                style: pw.TextStyle(
                                    font: body,
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.TextSpan(
                                text: ordenCompra,
                                style: pw.TextStyle(
                                    font: body,
                                    fontSize: 11,
                                    color: PdfColors.red,
                                    fontWeight: pw.FontWeight.bold))
                          ])),
                        ])),
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 0),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Fecha: ${entrega.Fecha}",
                              style: pw.TextStyle(font: body, fontSize: 11)),
                          pw.Text("Entrega a: ${entrega.Direccion}",
                              style: pw.TextStyle(font: body, fontSize: 11),
                              textAlign: pw.TextAlign.right)
                        ])),
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 0),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text("Nombre de la Empresa: $nombreEmpresa",
                        style: pw.TextStyle(font: body, fontSize: 11))),
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 0),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text("Ordenado por: ${entrega.Solicitante}",
                        style: pw.TextStyle(font: body, fontSize: 11))),
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 0),
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text("Producto Entregado",
                        style: pw.TextStyle(font: body, fontSize: 11))),
// ****************************************** Data Table ****************************************** \\
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 10),
                    child: pw.TableHelper.fromTextArray(
                        oddCellStyle: pw.TextStyle(font: body, fontSize: 11),
                        headerStyle: pw.TextStyle(font: body, fontSize: 11),
                        cellStyle: pw.TextStyle(font: body, fontSize: 11),
                        cellAlignment: pw.Alignment.center,
                        tableWidth: pw.TableWidth.max,
                        headers: headers,
                        data: data)),
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 0),
                    child: pw.TableHelper.fromTextArray(
                        oddCellStyle: pw.TextStyle(font: body, fontSize: 11),
                        headerStyle: pw.TextStyle(font: body, fontSize: 11),
                        cellStyle: pw.TextStyle(font: body, fontSize: 11),
                        cellAlignment: pw.Alignment.centerRight,
                        headerAlignment: pw.Alignment.centerRight,
                        tableWidth: pw.TableWidth.max,
                        headers: headersTotal,
                        data: dataTotal)),
// ****************************************** Down info ****************************************** \\
                pw.Container(
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text("Nota:",
                        style: pw.TextStyle(
                            font: bodyBold,
                            decoration: pw.TextDecoration.underline,
                            fontSize: 11))),
                pw.Container(
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text("${entrega.Notes}",
                        style: pw.TextStyle(
                            font: bodyBold,
                            decoration: pw.TextDecoration.underline,
                            fontSize: 11))),
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 20),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text(
                        "Firmado digitalmente por: ${entrega.Remitente}\nEmail: ${user!.email}",
                        style: pw.TextStyle(font: body, fontSize: 11))),
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 10),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text("Entregas Relacionadas",
                        style: pw.TextStyle(font: bodyBold, fontSize: 11))),
                // pw.Container(
                //     margin: pw.EdgeInsets.only(top: 10),
                //     alignment: pw.Alignment.topLeft,
                //     child: pw.Text("OC cantidad ID’s",
                //         style: pw.TextStyle(font: bodyBold, fontSize: 11))),
                pw.Container(
                    margin: pw.EdgeInsets.only(right: 75),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.ListView.builder(
                            itemCount: entregas.length,
                            itemBuilder: (context, i) => pw.Container(
                                margin: pw.EdgeInsets.only(top: 10),
                                alignment: pw.Alignment.topLeft,
                                child: pw.Text(
                                    "-${entregas[i].certificadoEntrega}", //Aqui va orden de compra solo que puse cantidad por mientras
                                    style:
                                        pw.TextStyle(font: body, fontSize: 8))),
                          ),
                          pw.Container(
                              child: pw.Column(children: [
                            pw.Container(
                                margin: pw.EdgeInsets.only(top: 10),
                                alignment: pw.Alignment.topLeft,
                                child: pw.Text(
                                    "Recibí el producto correctamente",
                                    style: pw.TextStyle(
                                        font: body, fontSize: 11))),
                            pw.Container(
                                color: PdfColor.fromHex("#000000"),
                                margin: pw.EdgeInsets.only(top: 40, bottom: 15),
                                alignment: pw.Alignment.center,
                                height: 1,
                                width: 150),
                            pw.Container(
                                alignment: pw.Alignment.topLeft,
                                child: pw.Text("Nombre y firma de conformidad",
                                    style: pw.TextStyle(
                                        font: body, fontSize: 11))),
                          ]))
                        ])),
                // pw.Expanded(
                //   child: pw.Align(
                //     alignment: pw.Alignment.bottomCenter,

                //   )
                // ),
                pw.Container(
                    alignment: pw.Alignment.bottomLeft,
                    margin: pw.EdgeInsets.only(top: 30),
                    child: pw.RichText(
                        text: pw.TextSpan(children: [
                      pw.TextSpan(
                          text:
                              "Cualquier duda o aclaración favor de comunicarse al número de oficina: ",
                          style: pw.TextStyle(font: body, fontSize: 11)),
                      pw.TextSpan(
                          text: "+52 33 27 33 09 62",
                          style: pw.TextStyle(font: bodyBold, fontSize: 11))
                    ])))
              ])
            ]));
    // Page
    //************************** Saving and Open **************************\\
    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);
    if (kIsWeb) {
      html.AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
        ..setAttribute("download",
            "CertificadoEntrega_${entrega.certificadoEntrega}_$nombreEmpresa.pdf")
        ..click();
    }
  }
}

Future<pw.PageTheme> _mypageTheme(PdfPageFormat format) async {
  return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(
          horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
            ignoreMargins: true,
          ));
}

// Future<pw.PageTheme> _mypageTheme(PdfPageFormat format) async {
//   final logo = pw.MemoryImage(
//       (await rootBundle.load('assets/images/headerPDF.png'))
//           .buffer
//           .asUint8List());
//   return pw.PageTheme(
//       margin: const pw.EdgeInsets.symmetric(
//           horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
//       textDirection: pw.TextDirection.ltr,
//       orientation: pw.PageOrientation.portrait,
//       buildBackground: (final context) => pw.FullPage(
//           ignoreMargins: true,
//           child: pw.Watermark(
//               angle: 20,
//               child: pw.Opacity(
//                   opacity: 0.5,
//                   child: pw.Image(logo,
//                       alignment: pw.Alignment.center, fit: pw.BoxFit.cover)))));
// }
