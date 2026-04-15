import 'dart:convert';
import 'package:aspose_words_cloud/aspose_words_cloud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../main.dart';
import '../../../utils/SuperGlobalVariables/ObjVar.dart';
import '../../Delivery_Certificate/adminClases/CustomerClass.dart';
import '../../admin_view/Tools.dart';
import '../Clases/QuoteClass.dart';
import '../Clases/QuoteTableClass.dart';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:intl/date_symbol_data_local.dart';
//import 'package:docx_template/docx_template.dart';

class ExportToPDFManofacture {
  bool? isPDF;
  bool? isEnglish;
  CustomersClass? customer;
  QuoteClass? quote;
  List<QuoteTableClass>? dataTable;
  String? notes;
  ExportToPDFManofacture(
      {required this.quote,
      required this.dataTable,
      required this.customer,
      required this.isEnglish,
      required this.isPDF,
      required this.notes});

  Future<void> createPDF(final PdfPageFormat format) async {
    await initializeDateFormatting('es_MX');
    await initializeDateFormatting('en_US');

    String? date;
    String nowTime = DateFormat('yyyy.M.d h:m:s').format(DateTime.now());
    NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: isEnglish! ? 'en_US' : 'es_MX',
      decimalDigits: 2,
    );
    final dt = DateTime.parse(quote!.date!);

    if (isEnglish!) {
      date = DateFormat('MMMM d, yyyy', 'en_US').format(dt);
    } else {
      // Formateo base en ES
      date = DateFormat('MMMM d, yyyy', 'es_MX')
          .format(dt); // ej: "enero 21, 2025"
      // Extrae el mes y lo capitaliza
      final mes = DateFormat('MMMM', 'es_MX').format(dt); // "enero"
      final mesCap = mes[0].toUpperCase() + mes.substring(1); // "Enero"
      // Reemplaza solo el mes
      date = date.replaceFirst(mes, mesCap);
    }

    String? currency;
    String? conIva;
    List columns = [];
    double total = 0.0;
    String cotizacion;
    String nombreProyecto;
    String empresa;
    String solicitud;
    String terminoPago;
    String atencion;
    String firmado;
    String fecha;
    //int numberOfSplits = 6;
    int splitsPerRow = 0;
    int splitsNotes = 0;
    // ************ Get Images ************ //
    final logo = pw.MemoryImage(
        (await rootBundle.load('assets/images/HeaderAJ.png'))
            .buffer
            .asUint8List());
    final footer = pw.MemoryImage(
        (await rootBundle.load('assets/images/FooterAJ.png'))
            .buffer
            .asUint8List());
    final logoEmpresa = pw.MemoryImage(convertListToInt(customer!.logo!));

    // ************ Get TextStyles ************ //
    var body = await PdfGoogleFonts.openSansMedium();
    var bodyBold = await PdfGoogleFonts.openSansBold();
    arial(size, fontWeight) {
      if (fontWeight == "bold") {
        return pw.TextStyle(font: bodyBold, fontSize: size);
      } else {
        return pw.TextStyle(font: body, fontSize: size);
      }
    }

    arialTitle() {
      return pw.TextStyle(
          font: bodyBold,
          fontSize: 14,
          decoration: pw.TextDecoration.underline);
    }

    description(underline) {
      if (underline) {
        return pw.TextStyle(
            font: body,
            fontSize: 8,
            color: PdfColors.grey,
            decoration: pw.TextDecoration.underline);
      } else {
        return pw.TextStyle(
            font: body,
            fontSize: 9,
            color: PdfColors.grey,
            decoration: pw.TextDecoration.none);
      }
    }

    final _en = {
      'cotizacion': 'Quotation',
      'nombreProyecto': 'Project name',
      'empresa': 'Company',
      'solicitud': 'Requested by',
      'terminoPago': 'Net terms',
      'atencion': 'Attention to',
      'firmado': 'Digital signature',
      'fecha': 'Date',
      'desc': 'Description',
      'unit': 'Unit price',
      'qty': 'Quantity',
      'img': 'Image',
      'totalMXN': 'Total MXN',
      'totalUSD': 'Total USD',
      'withIva': '* With IVA',
      'withoutIva': '* Without IVA',
    };

    final _es = {
      'cotizacion': 'Cotización',
      'nombreProyecto': 'Nombre proyecto',
      'empresa': 'Empresa',
      'solicitud': 'Solicitud por',
      'terminoPago': 'Término de pago',
      'atencion': 'Atención a',
      'firmado': 'Firmado digitalmente por',
      'fecha': 'Fecha',
      'desc': 'Descripción',
      'unit': 'Costo unitario',
      'qty': 'Cantidad',
      'img': 'Imagen',
      'totalMXN': 'Total MXN',
      'totalUSD': 'Total USD',
      'withIva': '* Con IVA',
      'withoutIva': '* Sin IVA',
    };

    final t = isEnglish! ? _en : _es;

// Asigna tus variables existentes (mismos nombres que usabas):
    cotizacion = t['cotizacion']!;
    nombreProyecto = t['nombreProyecto']!;
    empresa = t['empresa']!;
    solicitud = t['solicitud']!;
    terminoPago = t['terminoPago']!;
    atencion = t['atencion']!;
    firmado = t['firmado']!;
    fecha = t['fecha']!;

// Columnas según moneda, sin saltos '\n':
    if (quote!.currency == 'MXN') {
      currency = 'MXN';
      columns = [t['desc']!, t['unit']!, t['qty']!, t['img']!, t['totalMXN']!];
    } else {
      currency = 'USD';
      columns = [t['desc']!, t['unit']!, t['qty']!, t['img']!, t['totalUSD']!];
    }

// Nota IVA:
    conIva = (quote!.conIva ?? false) ? t['withIva']! : t['withoutIva']!;

    // final data = dataTotal
    //     .map((quote) => [
    //           quote.description,
    //           "\$${quote.unitario}",
    //           quote.cantidad,
    //           "\$${quote.total}"
    //         ])
    //     .toList();
//Operations Total
    for (var i = 0; i < dataTable!.length; i++) {
      final txt = (dataTable![i].total ?? '').replaceAll(',', '').trim();
      final val = double.tryParse(txt) ?? 0.0;
      total += val;
    }

    //Height of the description per row table
    for (var i = 0; i < dataTable!.length; i++) {
      int charactersPerRow;
      List countN = dataTable![i].description!.split("\n");
      splitsPerRow += countN.length;
      for (var i = 0; i < countN.length; i++) {
        charactersPerRow = countN[i].toString().length;
        //print("caracteres por linea = ${charactersPerRow}");
        if (charactersPerRow > 78) {
          splitsPerRow += 1;
        }
      }
    }
    print("saltos de linea total ${splitsPerRow}");
    List no = notes!.split("\n");
    splitsNotes = no.length;
    print("notes cantidad de saltos de linea = ${splitsNotes}");
    if (splitsPerRow > 18) {
      //numberOfSplits -= 1;
    }

    // ======= SPLIT ADAPTATIVO POR PESO =======
// Idea: cada fila tiene un "peso" aproximado según si trae imagen y cuántas líneas ocupa la descripción.
// Llenamos páginas sumando pesos hasta un umbral por página: si filas son ligeras caben más, si son pesadas caben menos.

    double _rowWeight(QuoteTableClass r) {
      // líneas por \n + penalización por líneas muy largas (rompe en ~78 chars)
      final desc = (r.description ?? '');
      final lines = desc.split('\n');
      int extraWraps = 0;
      for (final ln in lines) {
        final len = ln.length;
        if (len > 78) {
          extraWraps += (len / 78).floor(); // aprox. wraps adicionales
        }
      }
      final hasImage = (r.image != null && r.image!.isNotEmpty);

      // peso base 1.0 por fila
      // +0.35 por cada wrap estimado
      // +0.8 si trae imagen (sube el alto)
      return 1.0 +
          (0.35 * (lines.length - 1 + extraWraps)) +
          (hasImage ? 0.8 : 0.0);
    }

// Capacidad por página medida en "unidades de peso".
// Ajusta estos números a tu gusto probando con tus PDFs reales.
    final double firstPageCap =
        6.0; // 1ª página (tu header/título ocupan espacio)
    final double nextPageCap =
        7.0; // páginas siguientes (hay un poco más de aire)

    final List<List<QuoteTableClass>> dataTableTridimencional = [];
    double cap = firstPageCap;
    double acc = 0.0;
    List<QuoteTableClass> bucket = [];

    for (int i = 0; i < dataTable!.length; i++) {
      final row = dataTable![i];
      final w = _rowWeight(row);

      // Si no cabe, cerramos página y arrancamos otra
      if (acc + w > cap && bucket.isNotEmpty) {
        dataTableTridimencional.add(bucket);
        bucket = [];
        acc = 0.0;
        cap =
            nextPageCap; // de aquí en adelante usamos el cap de páginas siguientes
      }

      bucket.add(row);
      acc += w;
    }

// Último bucket
    if (bucket.isNotEmpty) {
      dataTableTridimencional.add(bucket);
    }

// Para mantener compatibilidad con tu variable:
    final int numberOfTables = dataTableTridimencional.length;

    // ************ Creating Document ************ //
    final pdf = pw.Document();
    final pageTheme = await _mypageTheme(format);

    for (var iMaster = 0; iMaster < numberOfTables; iMaster++) {
      pdf.addPage(pw.MultiPage(
          pageTheme: pageTheme,
          // ****************************************** Header ****************************************** \\
          header: (final context) => pw.Stack(children: [
                pw.Container(
                  margin: pw.EdgeInsets.only(top: 10, left: 35),
                  child: pw.Image(logo,
                      alignment: pw.Alignment.topLeft,
                      fit: pw.BoxFit.contain,
                      width: 565,
                      height: 125),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 60, right: 30),
                  alignment: pw.Alignment.topRight,
                  child: pw.Text(
                    "$date, Zapopan Jalisco.",
                    style: arial(10, "normal"),
                  ),
                ),
              ]),
// ****************************************** Footer ****************************************** \\
          footer: (final context) => pw.Stack(children: [
                pw.Container(
                    margin: pw.EdgeInsets.only(top: 236, left: 25),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                        "${context.pageNumber}/${context.pagesCount}",
                        style: arial(10, "normal"))),
                pw.Container(
                  margin: pw.EdgeInsets.only(left: 80, top: 100),
                  child: pw.Image(footer,
                      alignment: pw.Alignment.bottomLeft,
                      fit: pw.BoxFit.contain,
                      width: 525,
                      height: 300),
                ),
                pw.Container(
                    margin: pw.EdgeInsets.only(left: 0, top: 100),
                    width: 530,
                    height: 50,
                    decoration: pw.BoxDecoration(
                        color: PdfColors.white, shape: pw.BoxShape.rectangle)),
              ]),
          // ****************************************** Delivery info ****************************************** \\
          build: (pw.Context context) => [
                // *************** Info *************** \\
                pw.Opacity(
                    opacity: iMaster == 0 ? 1 : 0,
                    child: pw.Container(
                        height: iMaster == 0 ? 135 : 0,
                        margin: const pw.EdgeInsets.symmetric(
                            horizontal: 1 * PdfPageFormat.cm, vertical: 0.0),
                        child: pw.Container(
                          alignment: pw.Alignment.topLeft,
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.RichText(
                                  text: pw.TextSpan(children: [
                                pw.TextSpan(
                                    text: "$nombreProyecto: ",
                                    style: arial(11, "bold")),
                                pw.TextSpan(
                                    text: "${quote!.proyectName!}.",
                                    style: arial(10, "normal"))
                              ])),
                              pw.Container(
                                alignment: pw.Alignment.topRight,
                                margin: pw.EdgeInsets.only(),
                                child: pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    // pw.Container(
                                    //   height: 75,
                                    //   width: 75,
                                    //   decoration: pw.BoxDecoration(
                                    //       color: PdfColors.white,
                                    //       shape: pw.BoxShape.circle,
                                    //       image: pw.DecorationImage(
                                    //           image: pw.MemoryImage(convertListToInt(
                                    //               customer!.logo!)))),
                                    // ),
                                    pw.Container(
                                      alignment: pw.Alignment.topRight,
                                      child: pw.Image(
                                        height: 50,
                                        logoEmpresa,
                                        alignment: pw.Alignment.topLeft,
                                        fit: pw.BoxFit.contain,
                                      ),
                                    ),
                                    pw.SizedBox(
                                      height: 10,
                                    ),
                                    pw.RichText(
                                        textAlign: pw.TextAlign.right,
                                        text: pw.TextSpan(children: [
                                          pw.TextSpan(
                                              text: "$cotizacion: ",
                                              style: arial(9, "bold")),
                                          pw.TextSpan(
                                              text: "${quote!.quoteNumber!}\n",
                                              style: arial(8, "normal")),
                                          pw.TextSpan(
                                              text: "$empresa: ",
                                              style: arial(9, "bold")),
                                          pw.TextSpan(
                                              text: "${customer!.name!}\n",
                                              style: arial(8, "normal")),
                                          pw.TextSpan(
                                              text: "$atencion: ",
                                              style: arial(9, "bold")),
                                          pw.TextSpan(
                                              text: "${quote!.attentionTo!}\n",
                                              style: arial(8, "normal")),
                                          pw.TextSpan(
                                              text: "$solicitud: ",
                                              style: arial(9, "bold")),
                                          pw.TextSpan(
                                              text:
                                                  "${quote!.requestedByName!}\n${quote!.requestedByEmail!}\n",
                                              style: arial(8, "normal")),
                                          pw.TextSpan(
                                              text: "$terminoPago: ",
                                              style: arial(9, "bold")),
                                          isEnglish!
                                              ? pw.TextSpan(
                                                  text:
                                                      "${quote!.deliverTimeInfo!}\n",
                                                  style: arial(8, "normal"))
                                              : pw.TextSpan(
                                                  text:
                                                      "${quote!.deliverTimeInfo!.replaceAll("days", "dias")}\n",
                                                  style: arial(8, "normal")),
                                        ])),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))),

                // *************** Tittle *************** \\
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(
                      horizontal: 1 * PdfPageFormat.cm, vertical: 0.0),
                  alignment: pw.Alignment.center,
                  child: pw.Column(
                    children: [
                      pw.Opacity(
                          opacity: iMaster == 0 ? 1 : 0,
                          child: pw.Container(
                            height: iMaster == 0 ? 20 : 0,
                            margin: pw.EdgeInsets.only(top: 0, bottom: 10),
                            child: pw.Text(
                              "$cotizacion",
                              style: arialTitle(),
                            ),
                          )),

                      // *************** Table *************** \\
                      pw.SizedBox(
                          width:
                              math.max(200, (currentUser.width ?? 800) - 500),
                          child: pw.Table(
                              border: pw.TableBorder.all(),
                              defaultVerticalAlignment:
                                  pw.TableCellVerticalAlignment.middle,
                              children: [
                                pw.TableRow(children: [
                                  ...List.generate(
                                      columns.length,
                                      (index) => pw.Text(columns[index],
                                          style: arial(9, "normal"),
                                          textAlign: pw.TextAlign.center))
                                ]),
                                ...List.generate(
                                    dataTableTridimencional[iMaster].length,
                                    (index) {
                                  List<String> split =
                                      dataTableTridimencional[iMaster][index]
                                          .description!
                                          .split("\n");
                                  return pw.TableRow(
                                      verticalAlignment:
                                          pw.TableCellVerticalAlignment.middle,
                                      children: [
                                        pw.Container(
                                          padding: const pw.EdgeInsets.only(
                                              bottom: 5),
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              for (int i = 0;
                                                  i < split.length;
                                                  i++)
                                                pw.Container(
                                                  alignment:
                                                      pw.Alignment.centerLeft,
                                                  width: 250,
                                                  margin: i == split.length - 1
                                                      ? const pw
                                                          .EdgeInsets.only(
                                                          bottom: 5)
                                                      : pw.EdgeInsets.zero,
                                                  child: pw.Text(split[i],
                                                      style:
                                                          description(false)),
                                                ),
                                            ],
                                          ),
                                        ),
                                        pw.Text(
                                            "\$${dataTableTridimencional[iMaster][index].unitario!}",
                                            style: arial(9, "normal"),
                                            textAlign: pw.TextAlign.center),
                                        pw.Text(
                                            dataTableTridimencional[iMaster]
                                                    [index]
                                                .cantidad!,
                                            style: arial(9, "normal"),
                                            textAlign: pw.TextAlign.center),
                                        dataTableTridimencional[iMaster][index]
                                                .image!
                                                .isNotEmpty
                                            ? pw.Container(
                                                margin: pw.EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                child: pw.Center(
                                                    child: pw.Image(
                                                        pw.MemoryImage(base64.decode(
                                                            dataTableTridimencional[
                                                                        iMaster]
                                                                    [index]
                                                                .image!)),
                                                        height: 30,
                                                        width: 50)))
                                            : pw.Text(""),
                                        pw.Text(
                                            "\$${dataTableTridimencional[iMaster][index].total!}",
                                            style: arial(9, "normal"),
                                            textAlign: pw.TextAlign.center),
                                      ]);
                                })
                              ])),
                      pw.Opacity(
                          opacity: iMaster == numberOfTables - 1 ? 1 : 0,
                          child: pw.Container(
                            height: iMaster == numberOfTables - 1 ? 25 : 0,
                            width: 538.5,
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  width: 538.5 -
                                      "\n\$${formatter.format(total)}".length *
                                          5,
                                  height: 25,
                                  decoration: pw.BoxDecoration(
                                      shape: pw.BoxShape.rectangle,
                                      border: pw.Border.all(width: 1)),
                                  child: pw.Text(
                                    "Total\n$currency $conIva",
                                    style: arial(9, "normal"),
                                    textAlign: pw.TextAlign.end,
                                  ),
                                ),
                                pw.Container(
                                  width:
                                      "\n\$${formatter.format(total)}".length *
                                          5,
                                  height: 25,
                                  decoration: pw.BoxDecoration(
                                      shape: pw.BoxShape.rectangle,
                                      border: pw.Border.all(width: 1)),
                                  child: pw.Text(
                                    "\n\$${formatter.format(total)}",
                                    style: arial(9, "normal"),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                // *************** Digital fill *************** \\
                pw.Opacity(
                    opacity: iMaster == numberOfTables - 1 ? 1 : 0,
                    child: pw.Container(
                        height: iMaster == numberOfTables - 1 ? 33 : 0,
                        margin: const pw.EdgeInsets.only(top: 10),
                        alignment: pw.Alignment.bottomCenter,
                        child: pw.Text(
                            "$firmado: ${user!.name} ${user!.lastName}\nEmail: ${user!.email}\n$fecha: $nowTime",
                            style: arial(10, "bold")))),
                // *************** Notes *************** \\
                pw.Opacity(
                    opacity: iMaster == numberOfTables - 1 ? 1 : 0,
                    child: pw.Container(
                        margin:
                            pw.EdgeInsets.only(left: 80, right: 30, top: 20),
                        child: pw.RichText(
                            text: pw.TextSpan(children: [
                          pw.TextSpan(
                              text: "Notas:\n", style: arial(10, "bold")),
                          pw.TextSpan(text: notes!, style: arial(7, "bold"))
                        ]))))
              ]));
    }

    //************************** Saving and Open **************************\\
    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);

// ************************** PDF ************************** \\
    if (isPDF!) {
      if (kIsWeb) {
        html.AnchorElement(
            href:
                "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
          ..setAttribute("download",
              "$cotizacion-${quote!.quoteNumber!.replaceAll("_", "")}.pdf")
          ..click();
      }
    }
// ************************** Word ************************** \\
    else {
      // prepare
      final config = Configuration("443ce684-cae3-461e-b516-d892a3899dad",
          "2e185ee73c4fc2ef2d75ed9667e9f4d7");
      final wordsApi = WordsApi(config);
      final doc = (savedFile).buffer.asByteData();
      final request = ConvertDocumentRequest(doc, 'docx');
      final convert = await wordsApi.convertDocument(request);
      //final bytes = utf8.encode(text);
      final blob = html.Blob([convert]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download =
            '$cotizacion-${quote!.quoteNumber!.replaceAll("_", "")}.docx';
      html.document.body!.children.add(anchor);

      // download
      anchor.click();

      // cleanup
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    }
  }
}

Future<pw.PageTheme> _mypageTheme(PdfPageFormat format) async {
  return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
            ignoreMargins: true,
          ));
}
