// import 'dart:convert';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import '../../../main.dart';
// import '../../../utils/SuperGlobalVariables/ObjVar.dart';
// import '../../Delivery_Certificate/adminClases/CustomerClass.dart';
// import '../../admin_view/Tools.dart';
// import '../Clases/QuoteClass.dart';
// import '../Clases/QuoteTableClass.dart';
// import 'dart:html' as html;

// class ExportToPDFAssemblies {
//   CustomersClass? customer;
//   QuoteClass? quote;
//   List<QuoteTableClass>? dataTable;
//   ExportToPDFAssemblies(
//       {required this.quote, required this.dataTable, required this.customer});

//   Future<void> createPDF(final PdfPageFormat format) async {
//     String? date;
//     NumberFormat formatter = NumberFormat.decimalPatternDigits(
//       locale: 'en_us',
//       decimalDigits: 2,
//     );
//     String? currency;
//     String? conIva;
//     List columns = [];
//     double total = 0.0;
//     date = DateFormat('MMMM d, yyyy').format(quote!.date!);
//     // ************ Get Images ************ //
//     final logo = pw.MemoryImage(
//         (await rootBundle.load('assets/images/HeaderAJ.png'))
//             .buffer
//             .asUint8List());
//     final footer = pw.MemoryImage(
//         (await rootBundle.load('assets/images/FooterAJ.png'))
//             .buffer
//             .asUint8List());
//     final logoEmpresa = pw.MemoryImage(convertListToInt(customer!.logo!));
//     final pcbImage = pw.MemoryImage(convertListToInt(quote!.PCBImage!));
//     // ************ Get TextStyles ************ //
//     var body = await PdfGoogleFonts.openSansMedium();
//     var bodyBold = await PdfGoogleFonts.openSansBold();
//     arial(size, fontWeight) {
//       if (fontWeight == "bold") {
//         return pw.TextStyle(font: bodyBold, fontSize: size);
//       } else {
//         return pw.TextStyle(font: body, fontSize: size);
//       }
//     }

//     arialTitle() {
//       return pw.TextStyle(
//           font: bodyBold,
//           fontSize: 14,
//           decoration: pw.TextDecoration.underline);
//     }

//     description(underline) {
//       if (underline) {
//         return pw.TextStyle(
//             font: body,
//             fontSize: 9,
//             color: PdfColors.grey,
//             decoration: pw.TextDecoration.underline);
//       } else {
//         return pw.TextStyle(
//             font: body,
//             fontSize: 9,
//             color: PdfColors.grey,
//             decoration: pw.TextDecoration.none);
//       }
//     }

//     if (quote!.currency == "MXN") {
//       currency = "MXN";
//       columns = ['Descripción', 'Costo\nunitario', 'Cantidad', 'Total\nMXN'];
//     } else {
//       currency = "USD";
//       columns = ['Descripción', 'Costo\nunitario', 'Cantidad', 'Total\nUSD'];
//     }
//     if (quote!.conIva!) {
//       conIva = "";
//     } else {
//       conIva = "* Sin IVA";
//     }

//     // final data = dataTotal
//     //     .map((quote) => [
//     //           quote.description,
//     //           "\$${quote.unitario}",
//     //           quote.cantidad,
//     //           "\$${quote.total}"
//     //         ])
//     //     .toList();
// //Operations Total
//     for (var i = 0; i < dataTable!.length; i++) {
//       if (dataTable![i].total!.isNotEmpty) {
//         total += double.parse(dataTable![i].total!.replaceAll(",", ""));
//       }
//     }
//     // ************ Creating Document ************ //
//     final pdf = pw.Document();
//     final pageTheme = await _mypageTheme(format);
//     pdf.addPage(pw.MultiPage(
//         pageTheme: pageTheme,
//         // ****************************************** Header ****************************************** \\
//         header: (final context) => pw.Stack(children: [
//               pw.Container(
//                 margin: pw.EdgeInsets.only(top: 10, left: 35),
//                 child: pw.Image(logo,
//                     alignment: pw.Alignment.topLeft,
//                     fit: pw.BoxFit.contain,
//                     width: 565,
//                     height: 125),
//               ),
//               pw.Container(
//                 margin: const pw.EdgeInsets.only(top: 60, right: 30),
//                 alignment: pw.Alignment.topRight,
//                 child: pw.Text(
//                   "$date, Zapopan Jalisco.",
//                   style: arial(10, "normal"),
//                 ),
//               ),
//             ]),
// // ****************************************** Footer ****************************************** \\
//         footer: (final context) => pw.Stack(children: [
//               pw.Container(
//                   margin: pw.EdgeInsets.only(top: 200, left: 25),
//                   alignment: pw.Alignment.bottomLeft,
//                   child:
//                       pw.Text("${context.pageNumber}/${context.pagesCount}")),
//               pw.Container(
//                 margin: pw.EdgeInsets.only(left: 80),
//                 child: pw.Image(footer,
//                     alignment: pw.Alignment.bottomLeft,
//                     fit: pw.BoxFit.contain,
//                     width: 525,
//                     height: 300),
//               ),
//             ]),
//         // ****************************************** Delivery info ****************************************** \\
//         build: (pw.Context context) => [
//               pw.Container(
//                   margin: const pw.EdgeInsets.symmetric(
//                       horizontal: 1 * PdfPageFormat.cm, vertical: 0.0),
//                   child: pw.Container(
//                     alignment: pw.Alignment.topLeft,
//                     child: pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.RichText(
//                             text: pw.TextSpan(children: [
//                           pw.TextSpan(
//                               text: "Nombre Proyecto: ",
//                               style: arial(11, "bold")),
//                           pw.TextSpan(
//                               text: "${quote!.proyectName!}.",
//                               style: arial(10, "normal"))
//                         ])),
//                         pw.Container(
//                           alignment: pw.Alignment.topRight,
//                           margin: pw.EdgeInsets.only(),
//                           child: pw.Column(
//                             mainAxisAlignment: pw.MainAxisAlignment.end,
//                             crossAxisAlignment: pw.CrossAxisAlignment.end,
//                             children: [
//                               pw.Container(
//                                 alignment: pw.Alignment.topRight,
//                                 child: pw.Image(logoEmpresa,
//                                     alignment: pw.Alignment.topLeft,
//                                     fit: pw.BoxFit.fill,
//                                     width: 50,
//                                     height: 50),
//                               ),
//                               pw.SizedBox(
//                                 height: 10,
//                               ),
//                               pw.RichText(
//                                   textAlign: pw.TextAlign.right,
//                                   text: pw.TextSpan(children: [
//                                     pw.TextSpan(
//                                         text: "Cotización: ",
//                                         style: arial(9, "bold")),
//                                     pw.TextSpan(
//                                         text: "${quote!.quoteNumber!}\n",
//                                         style: arial(8, "normal")),
//                                     pw.TextSpan(
//                                         text: "Empresa: ",
//                                         style: arial(9, "bold")),
//                                     pw.TextSpan(
//                                         text: "${customer!.name!}\n",
//                                         style: arial(8, "normal")),
//                                     pw.TextSpan(
//                                         text: "Atención a: ",
//                                         style: arial(9, "bold")),
//                                     pw.TextSpan(
//                                         text: "${quote!.attentionTo!}\n",
//                                         style: arial(8, "normal")),
//                                     pw.TextSpan(
//                                         text: "Solicitud por: ",
//                                         style: arial(9, "bold")),
//                                     pw.TextSpan(
//                                         text:
//                                             "${quote!.requestedByName!}\n${quote!.requestedByEmail!}",
//                                         style: arial(8, "normal")),
//                                   ])),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   )),
//               pw.Container(
//                 margin: const pw.EdgeInsets.symmetric(
//                     horizontal: 1 * PdfPageFormat.cm, vertical: 0.0),
//                 alignment: pw.Alignment.center,
//                 child: pw.Column(
//                   children: [
//                     pw.Container(
//                       margin: pw.EdgeInsets.only(top: 0, bottom: 10),
//                       child: pw.Text(
//                         "Cotización",
//                         style: arialTitle(),
//                       ),
//                     ),
//                     pw.SizedBox(
//                         width: (currentUser.width! - 500),
//                         child: pw.Table(
//                             border: pw.TableBorder.all(),
//                             defaultVerticalAlignment:
//                                 pw.TableCellVerticalAlignment.middle,
//                             children: [
//                               pw.TableRow(children: [
//                                 ...List.generate(
//                                     columns.length,
//                                     (index) => pw.Text(columns[index],
//                                         style: arial(9, "normal"),
//                                         textAlign: pw.TextAlign.center))
//                               ]),
//                               ...List.generate(dataTable!.length, (index) {
//                                 List split =
//                                     dataTable![index].description!.split("\n");
//                                 return pw.TableRow(
//                                     verticalAlignment:
//                                         pw.TableCellVerticalAlignment.middle,
//                                     children: [
//                                       index == 1
//                                           ? pw.Container(
//                                               margin:
//                                                   pw.EdgeInsets.only(left: 5),
//                                               child: pw.Column(
//                                                   mainAxisAlignment: pw
//                                                       .MainAxisAlignment.start,
//                                                   children: [
//                                                     pw.Align(
//                                                         alignment: pw.Alignment
//                                                             .centerLeft,
//                                                         child: pw.RichText(
//                                                             text: pw.TextSpan(
//                                                                 children: [
//                                                               pw.TextSpan(
//                                                                 text:
//                                                                     "${split[0]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         false),
//                                                               ),
//                                                               pw.WidgetSpan(
//                                                                   child: pw
//                                                                       .SizedBox(
//                                                                           width:
//                                                                               30)),
//                                                               pw.TextSpan(
//                                                                 text:
//                                                                     "${split[1]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         false),
//                                                               ),
//                                                               pw.WidgetSpan(
//                                                                   child: pw
//                                                                       .SizedBox(
//                                                                           width:
//                                                                               30)),
//                                                               pw.TextSpan(
//                                                                 text:
//                                                                     "${split[2]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         false),
//                                                               ),
//                                                             ]))),
//                                                     pw.Align(
//                                                         alignment: pw.Alignment
//                                                             .centerLeft,
//                                                         child: pw.Image(
//                                                             pcbImage,
//                                                             width: 350,
//                                                             height: 200)),
//                                                     pw.Align(
//                                                         alignment: pw.Alignment
//                                                             .centerLeft,
//                                                         child: pw.Text(split[3],
//                                                             style: description(
//                                                                 true)))
//                                                   ]))
//                                           : index == 0
//                                               ? pw.Container(
//                                                   margin: pw.EdgeInsets.only(
//                                                       left: 5),
//                                                   child: pw.RichText(
//                                                       text: pw
//                                                           .TextSpan(children: [
//                                                     pw.TextSpan(
//                                                         text: "${split[0]}\n",
//                                                         style:
//                                                             description(false)),
//                                                     pw.WidgetSpan(
//                                                         child: pw.SizedBox(
//                                                             width: 30)),
//                                                     pw.TextSpan(
//                                                         text: "${split[1]}\n",
//                                                         style:
//                                                             description(false)),
//                                                     pw.WidgetSpan(
//                                                         child: pw.SizedBox(
//                                                             width: 30)),
//                                                     pw.TextSpan(
//                                                         text: "${split[2]}\n",
//                                                         style:
//                                                             description(false)),
//                                                     pw.TextSpan(
//                                                         text: "${split[3]}\n",
//                                                         style:
//                                                             description(true))
//                                                   ])))
//                                               : index == 2
//                                                   ? pw.Container(
//                                                       margin: pw.EdgeInsets.only(
//                                                           left: 5),
//                                                       child: pw.RichText(
//                                                           text: pw.TextSpan(
//                                                               children: [
//                                                             pw.TextSpan(
//                                                                 text:
//                                                                     "${split[0]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         false)),
//                                                             pw.WidgetSpan(
//                                                                 child:
//                                                                     pw.SizedBox(
//                                                                         width:
//                                                                             30)),
//                                                             pw.TextSpan(
//                                                                 text:
//                                                                     "${split[1]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         false)),
//                                                             pw.WidgetSpan(
//                                                                 child:
//                                                                     pw.SizedBox(
//                                                                         width:
//                                                                             30)),
//                                                             pw.TextSpan(
//                                                                 text:
//                                                                     "${split[2]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         false)),
//                                                             pw.WidgetSpan(
//                                                                 child:
//                                                                     pw.SizedBox(
//                                                                         width:
//                                                                             30)),
//                                                             pw.TextSpan(
//                                                                 text:
//                                                                     "${split[3]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         false)),
//                                                             pw.TextSpan(
//                                                                 text:
//                                                                     "${split[4]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         false)),
//                                                             pw.TextSpan(
//                                                                 text:
//                                                                     "${split[5]}\n",
//                                                                 style:
//                                                                     description(
//                                                                         true))
//                                                           ])))
//                                                   : pw.Container(
//                                                       margin:
//                                                           pw.EdgeInsets.only(
//                                                               left: 5),
//                                                       child: pw.Text(dataTable![index].description!, style: description(false))),
//                                       pw.Text(
//                                           "\$${dataTable![index].unitario!}",
//                                           style: arial(9, "normal"),
//                                           textAlign: pw.TextAlign.center),
//                                       pw.Text(dataTable![index].cantidad!,
//                                           style: arial(9, "normal"),
//                                           textAlign: pw.TextAlign.center),
//                                       pw.Text("\$${dataTable![index].total!}",
//                                           style: arial(9, "normal"),
//                                           textAlign: pw.TextAlign.center),
//                                     ]);
//                               })
//                             ])),
//                     pw.Container(
//                       width: 800,
//                       child: pw.Row(
//                         children: [
//                           pw.Container(
//                             width: 487,
//                             height: 25,
//                             decoration: pw.BoxDecoration(
//                                 shape: pw.BoxShape.rectangle,
//                                 border: pw.Border.all(width: 1)),
//                             child: pw.Text(
//                               "Total\n$currency $conIva",
//                               style: arial(9, "normal"),
//                               textAlign: pw.TextAlign.end,
//                             ),
//                           ),
//                           pw.Container(
//                             width: 51.5,
//                             height: 25,
//                             decoration: pw.BoxDecoration(
//                                 shape: pw.BoxShape.rectangle,
//                                 border: pw.Border.all(width: 1)),
//                             child: pw.Text(
//                               "\n\$${formatter.format(total)}",
//                               style: arial(9, "normal"),
//                               textAlign: pw.TextAlign.center,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.Container(
//                   margin: const pw.EdgeInsets.only(top: 10),
//                   alignment: pw.Alignment.bottomCenter,
//                   child: pw.Text(
//                       "Firmado digitalmente por: ${user!.name} ${user!.lastName}\nEmail: ${user!.email}",
//                       style: arial(10, "bold"))),
//             ]));
//     //************************** Saving and Open **************************\\
//     var savedFile = await pdf.save();
//     List<int> fileInts = List.from(savedFile);
//     if (kIsWeb) {
//       html.AnchorElement(
//           href:
//               "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
//         ..setAttribute("download", "Cotizacion.pdf")
//         ..click();
//     }
//   }
// }

// Future<pw.PageTheme> _mypageTheme(PdfPageFormat format) async {
//   return pw.PageTheme(
//       margin: const pw.EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
//       textDirection: pw.TextDirection.ltr,
//       orientation: pw.PageOrientation.portrait,
//       buildBackground: (final context) => pw.FullPage(
//             ignoreMargins: true,
//           ));
// }
