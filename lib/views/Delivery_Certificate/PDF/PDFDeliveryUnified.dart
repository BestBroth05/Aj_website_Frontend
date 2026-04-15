// lib/views/Delivery_Certificate/PDF/PDFDeliveryUnified.dart
// ignore_for_file: camel_case_types, file_names, avoid_web_libraries_in_flutter, depend_on_referenced_packages

import 'dart:convert';
import 'dart:html' as html;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CertificadoEntregaClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/productClass.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../main.dart';
import '../Controllers/DAO.dart';

class DeliveryCertificatePDF {
  final bool isEnglish;
  final int idOC;
  final ClassCertificadoEntrega entrega;
  final String? ordenCompra;
  final String? nombreEmpresa;
  final String? moneda;
  final int totalProducts;
  final List<ProductCertificateDelivery> products;

  DeliveryCertificatePDF({
    required this.isEnglish,
    required this.idOC,
    required this.entrega,
    required this.ordenCompra,
    required this.nombreEmpresa,
    required this.products,
    required this.totalProducts,
    required this.moneda,
  });

  final List<ClassCertificadoEntrega> _entregas = [];

  Future<void> _loadEntregas() async {
    final list = await DataAccessObject.selectEntrega(idOC);
    _entregas
      ..clear()
      ..addAll(list);
  }

  Future<void> createPDF(final PdfPageFormat format) async {
    await _loadEntregas();

    // ===== Localización =====
    final _L l = isEnglish ? _L.en : _L.es;
    final locale = isEnglish ? 'en_US' : 'es';
    await initializeDateFormatting(locale, null);

    // ===== Column widths =====
    final columnWidthsTable1 = <int, pw.TableColumnWidth>{
      0: const pw.FractionColumnWidth(.125),
      1: const pw.FractionColumnWidth(.525),
      2: const pw.FractionColumnWidth(.175),
      3: const pw.FractionColumnWidth(.175),
    };
    final columnWidthsTable2 = <int, pw.TableColumnWidth>{
      0: const pw.FractionColumnWidth(.825),
      1: const pw.FractionColumnWidth(.175),
    };

    // ===== Fecha / hora =====
    final nowTime = DateFormat('yyyy.M.d h:m:s').format(DateTime.now());

    // Normaliza entrega.Fecha
    final splitDate = (entrega.Fecha ?? '').split('-');
    String mm = splitDate.length > 1 ? splitDate[1] : '01';
    String dd = splitDate.length > 2 ? splitDate[2] : '01';
    if (int.tryParse(mm) != null && int.parse(mm) < 10) mm = '0$mm';
    if (int.tryParse(dd) != null && int.parse(dd) < 10) dd = '0$dd';
    final normalized =
        '${splitDate.isNotEmpty ? splitDate[0] : '2000'}-$mm-$dd';
    final newDateTime = DateTime.tryParse(normalized) ?? DateTime.now();
    entrega.Fecha = DateFormat.yMMMMd(locale).format(newDateTime);

    // Notes "entregadas/total"
    if ((entrega.Notes ?? '').contains('/')) {
      entrega.Notes = '$totalProducts/${entrega.Notes!.split('/')[1]}';
    }

    // ===== Números =====
    double subTotal = 0.0;
    for (final p in products) {
      subTotal += (p.importe ?? 0);
    }
    final iva = (subTotal * 1.16) - subTotal;
    final total = subTotal + iva;

    final numberLocale = isEnglish ? 'en_US' : 'es_MX';
    final formatter = NumberFormat.decimalPatternDigits(
      locale: numberLocale,
      decimalDigits: 2,
    );

    // ===== Headers/data =====
    final headers = [
      l.quantity,
      l.description,
      '${l.unitPrice}\n(${moneda ?? ''})',
      '${l.amount}\n(${moneda ?? ''})',
    ];

    final data = products
        .map((p) => [
              p.cantidad ?? '',
              p.descripcion ?? '',
              '\$ ${formatter.format(p.precioUnitario ?? 0)}',
              '\$ ${formatter.format(p.importe ?? 0)}',
            ])
        .toList();

    final headersTotal = [l.subTotal, '\$ ${formatter.format(subTotal)}'];
    final dataTotal = [
      [l.vat, '\$ ${formatter.format(iva)}'],
      [l.total, '\$ ${formatter.format(total)}'],
    ];

    // ===== Assets =====
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/HeaderAJ.png'))
          .buffer
          .asUint8List(),
    );
    final footerImg = pw.MemoryImage(
      (await rootBundle.load('assets/images/FooterAJ.png'))
          .buffer
          .asUint8List(),
    );

    // ===== Tipografías =====
    final fonth1 = await PdfGoogleFonts.tinosBold();
    final body = await PdfGoogleFonts.openSansMedium();
    final bodyBold = await PdfGoogleFonts.openSansBold();
    pw.TextStyle arial(double size, String weight) =>
        pw.TextStyle(font: weight == 'bold' ? bodyBold : body, fontSize: size);

    // ===== Documento =====
    final pdf = pw.Document();
    final pageTheme = await _mypageTheme(format);

    // Dirección
    final direccionParts = (entrega.Direccion ?? '').split(',');
    final dirLine1 = direccionParts.isNotEmpty ? direccionParts[0] : '';
    final dirLine2 = direccionParts.length > 1 ? direccionParts[1] : '';

    pw.Widget pad(pw.Widget child) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 25),
          child: child,
        );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,

        header: (_) => pw.Stack(children: [
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 10, left: 35),
            child: pw.Image(
              logo,
              alignment: pw.Alignment.topLeft,
              fit: pw.BoxFit.contain,
              width: 565,
              height: 125,
            ),
          ),
        ]),

        footer: (context) => pw.Stack(children: [
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 236, left: 25),
            alignment: pw.Alignment.bottomLeft,
            child: pw.Text(
              '${context.pageNumber}/${context.pagesCount}',
              style: arial(10, 'normal'),
            ),
          ),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 80, top: 100),
            child: pw.Image(
              footerImg,
              alignment: pw.Alignment.bottomLeft,
              fit: pw.BoxFit.contain,
              width: 525,
              height: 300,
            ),
          ),
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 0, top: 100),
            width: 530,
            height: 50,
            decoration: const pw.BoxDecoration(
              color: PdfColors.white,
              shape: pw.BoxShape.rectangle,
            ),
          ),
        ]),

        // ✅ CAMBIO CLAVE: regresamos una LISTA de widgets, no un Column gigante
        build: (_) => [
          pw.SizedBox(height: 10),

          pad(
            pw.Container(
              alignment: pw.Alignment.topCenter,
              child: pw.Text(
                l.title.toUpperCase(),
                style: pw.TextStyle(
                  font: fonth1,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),

          pad(
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 40),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                    text: pw.TextSpan(children: [
                      pw.TextSpan(
                        text: '${l.folio} ',
                        style: pw.TextStyle(
                          font: body,
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.TextSpan(
                        text: entrega.certificadoEntrega ?? '',
                        style: pw.TextStyle(
                          font: body,
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(children: [
                      pw.TextSpan(
                        text: '${l.purchaseOrder} ',
                        style: pw.TextStyle(
                          font: body,
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.TextSpan(
                        text: ordenCompra ?? '',
                        style: pw.TextStyle(
                          font: body,
                          fontSize: 11,
                          color: PdfColors.red,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),

          pad(
            pw.Container(
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '${l.date}: ${entrega.Fecha}',
                    style: pw.TextStyle(font: body, fontSize: 11),
                  ),
                  pw.Text(
                    '${l.deliveryTo}: $dirLine1\n$dirLine2',
                    style: pw.TextStyle(font: body, fontSize: 11),
                    textAlign: pw.TextAlign.right,
                  ),
                ],
              ),
            ),
          ),

          pad(
            pw.Text(
              '${l.companyName}: ${nombreEmpresa ?? ''}',
              style: pw.TextStyle(font: body, fontSize: 11),
            ),
          ),

          pad(
            pw.Text(
              '${l.applicant}: ${entrega.Solicitante ?? ''}',
              style: pw.TextStyle(font: body, fontSize: 11),
            ),
          ),

          pad(
            pw.Container(
              alignment: pw.Alignment.topCenter,
              child: pw.Text(
                l.productDelivered,
                style: pw.TextStyle(font: body, fontSize: 11),
              ),
            ),
          ),

          // ===== Tabla productos =====
          pad(
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 10),
              child: pw.TableHelper.fromTextArray(
                oddCellStyle: pw.TextStyle(font: body, fontSize: 11),
                headerStyle: pw.TextStyle(font: body, fontSize: 11),
                cellStyle: pw.TextStyle(font: body, fontSize: 11),
                cellAlignment: pw.Alignment.center,
                tableWidth: pw.TableWidth.max,
                columnWidths: columnWidthsTable1,
                headers: headers,
                data: data,
              ),
            ),
          ),

          // ===== Totales =====
          pad(
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 0),
              child: pw.TableHelper.fromTextArray(
                oddCellStyle: pw.TextStyle(font: body, fontSize: 11),
                headerStyle: pw.TextStyle(font: body, fontSize: 11),
                cellStyle: pw.TextStyle(font: body, fontSize: 11),
                cellAlignment: pw.Alignment.centerRight,
                headerAlignment: pw.Alignment.centerRight,
                tableWidth: pw.TableWidth.max,
                columnWidths: columnWidthsTable2,
                headers: headersTotal,
                data: dataTotal,
              ),
            ),
          ),

          // ===== Nota =====
          pad(
            pw.Text(
              l.note,
              style: pw.TextStyle(
                font: bodyBold,
                decoration: pw.TextDecoration.underline,
                fontSize: 11,
              ),
            ),
          ),
          pad(
            pw.Text(
              '${entrega.Notes ?? ''}',
              style: pw.TextStyle(
                font: bodyBold,
                decoration: pw.TextDecoration.underline,
                fontSize: 11,
              ),
            ),
          ),

          // ===== Firma digital =====
          pad(
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 10),
              alignment: pw.Alignment.bottomCenter,
              child: pw.Text(
                '${l.digitallySignedBy}: ${user!.name} ${user!.lastName}\nEmail: ${user!.email}\n${l.date}: $nowTime',
                style: arial(10, 'bold'),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ),

          // ===== Entregas relacionadas =====
          pad(
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 10),
              child: pw.Text(
                l.relatedDeliveries,
                style: pw.TextStyle(font: bodyBold, fontSize: 11),
              ),
            ),
          ),

          pad(
            pw.Container(
              margin: const pw.EdgeInsets.only(right: 75),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        for (final e in _entregas)
                          pw.Container(
                            margin: const pw.EdgeInsets.only(top: 10),
                            child: pw.Text(
                              isEnglish
                                  ? '${e.certificadoEntrega}'
                                  : '-${e.certificadoEntrega}',
                              style: pw.TextStyle(font: body, fontSize: 8),
                              softWrap: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        margin: const pw.EdgeInsets.only(top: 10),
                        child: pw.Text(
                          l.signatureLineText,
                          style: pw.TextStyle(font: body, fontSize: 11),
                        ),
                      ),
                      pw.Container(
                        color: PdfColor.fromHex('#000000'),
                        margin: const pw.EdgeInsets.only(top: 40, bottom: 15),
                        height: 1,
                        width: 150,
                      ),
                      pw.Text(
                        l.nameAndSignature,
                        style: pw.TextStyle(font: body, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ===== Footer contacto =====
          pad(
            pw.Container(
              alignment: pw.Alignment.bottomLeft,
              margin: const pw.EdgeInsets.only(top: 30),
              child: pw.RichText(
                text: pw.TextSpan(children: [
                  pw.TextSpan(
                    text: l.footerContactPrefix,
                    style: pw.TextStyle(font: body, fontSize: 11),
                  ),
                  pw.TextSpan(
                    text: '+52 33 27 33 09 62',
                    style: pw.TextStyle(font: bodyBold, fontSize: 11),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );

    // ===== Guardado (web) =====
    final savedFile = await pdf.save();
    final fileInts = List<int>.from(savedFile);

    if (kIsWeb) {
      final filename = isEnglish
          ? 'DeliveryCertificate_${entrega.certificadoEntrega}_$nombreEmpresa.pdf'
          : 'CertificadoEntrega_${entrega.certificadoEntrega}_$nombreEmpresa.pdf';

      // Si quieres dejarlo en base64, ok:
      html.AnchorElement(
        href: 'data:application/octet-stream;base64,${base64.encode(fileInts)}',
      )
        ..setAttribute('download', filename)
        ..click();

      // (Más estable: Blob)
      // final blob = html.Blob([savedFile], 'application/pdf');
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // html.AnchorElement(href: url)
      //   ..setAttribute('download', filename)
      //   ..click();
      // html.Url.revokeObjectUrl(url);
    }
  }
}

class _L {
  final String title;
  final String folio;
  final String purchaseOrder;
  final String date;
  final String deliveryTo;
  final String companyName;
  final String applicant;
  final String productDelivered;
  final String quantity;
  final String description;
  final String unitPrice;
  final String amount;
  final String subTotal;
  final String vat;
  final String total;
  final String note;
  final String digitallySignedBy;
  final String relatedDeliveries;
  final String signatureLineText;
  final String nameAndSignature;
  final String footerContactPrefix;

  const _L({
    required this.title,
    required this.folio,
    required this.purchaseOrder,
    required this.date,
    required this.deliveryTo,
    required this.companyName,
    required this.applicant,
    required this.productDelivered,
    required this.quantity,
    required this.description,
    required this.unitPrice,
    required this.amount,
    required this.subTotal,
    required this.vat,
    required this.total,
    required this.note,
    required this.digitallySignedBy,
    required this.relatedDeliveries,
    required this.signatureLineText,
    required this.nameAndSignature,
    required this.footerContactPrefix,
  });

  static const en = _L(
    title: 'Delivery Certificate',
    folio: 'Folio:',
    purchaseOrder: 'Purchase Order:',
    date: 'Date',
    deliveryTo: 'Delivery to',
    companyName: 'Company name',
    applicant: 'Request by',
    productDelivered: 'Product delivered',
    quantity: 'Quantity',
    description: 'Description',
    unitPrice: 'Unit price',
    amount: 'Amount',
    subTotal: 'Sub-Total',
    vat: 'IVA',
    total: 'Total',
    note: 'Note:',
    digitallySignedBy: 'Digital signature',
    relatedDeliveries: 'Related deliveries',
    signatureLineText: 'I received the product correctly',
    nameAndSignature: 'Name and signature of conformity',
    footerContactPrefix:
        'For any questions or clarifications, please contact to the office number: ',
  );

  static const es = _L(
    title: 'Certificado de Entrega',
    folio: 'Folio:',
    purchaseOrder: 'Orden de compra:',
    date: 'Fecha',
    deliveryTo: 'Entrega a',
    companyName: 'Nombre de la Empresa',
    applicant: 'Ordenado por',
    productDelivered: 'Producto Entregado',
    quantity: 'Cantidad',
    description: 'Descripción',
    unitPrice: 'Precio Unitario',
    amount: 'Importe',
    subTotal: 'Sub-Total',
    vat: 'IVA',
    total: 'Total',
    note: 'Nota:',
    digitallySignedBy: 'Firmado digitalmente por',
    relatedDeliveries: 'Entregas Relacionadas',
    signatureLineText: 'Recibí el producto correctamente',
    nameAndSignature: 'Nombre y firma de conformidad',
    footerContactPrefix:
        'Cualquier duda o aclaración favor de comunicarse al número de oficina: ',
  );
}

Future<pw.PageTheme> _mypageTheme(PdfPageFormat format) async {
  return pw.PageTheme(
    margin: const pw.EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
    buildBackground: (context) => pw.FullPage(ignoreMargins: true),
  );
}
