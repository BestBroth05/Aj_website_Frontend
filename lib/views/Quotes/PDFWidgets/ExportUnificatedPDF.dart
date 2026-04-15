import 'dart:convert';
import 'dart:math' as math;
import 'package:aspose_words_cloud/aspose_words_cloud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/utils/helperPDFExportQuotes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:html' as html;

import '../../../main.dart';
import '../../../utils/SuperGlobalVariables/ObjVar.dart';
import '../../Delivery_Certificate/adminClases/CustomerClass.dart';
import '../../admin_view/Tools.dart';
import '../Clases/QuoteClass.dart';
import '../Clases/QuoteTableClass.dart';

/// Unificador de exportables para Ensambles y Manufactura
/// Mantiene TU diseño original (header/footer/márgenes),
/// centraliza i18n, paginación adaptativa y guardado.
enum QuoteType { assembly, manufacture }

class QuoteL10n {
  QuoteL10n(this.isEnglish);
  final bool isEnglish;
  String t(String k) => (isEnglish ? _en : _es)[k] ?? k;

  static const _en = {
    'quotation': 'Quotation',
    'project': 'Project name',
    'company': 'Company',
    'requested': 'To whom it may concern',
    'terms': 'Net terms',
    'attention': 'Attention to',
    'signed': 'Digital signature',
    'date': 'Date',
    'notesTitle': 'Notes:',
    'notesDefault': '- Costs are calculated based on the requested volume. For different volumes, please request a new quotation.\n'
        '- Components subject to availability and market price.\n'
        '- To manufacture your order, a purchase order signed by your company’s responsible person is required.\n'
        '- Quotation validity: 8 business days.\n'
        '- The client is responsible for the files delivered for product manufacturing. In case of any error, they must cover 100% of the costs generated.\n'
        '- Once the purchase/manufacturing process has started, no design changes are accepted unless the corresponding costs are covered.',
    'desc': 'Description',
    'unit': 'Unit price',
    'qty': 'Quantity',
    'img': 'Image',
    'totalMXN': 'Total MXN',
    'totalUSD': 'Total USD',
    'withIva': '* With IVA',
    'withoutIva': '* Without IVA',
  };

  static const _es = {
    'quotation': 'Cotización',
    'project': 'Nombre proyecto',
    'company': 'Empresa',
    'requested': 'Solicitud por',
    'terms': 'Término de pago',
    'attention': 'Atención a',
    'signed': 'Firmado digitalmente por',
    'date': 'Fecha',
    'notesTitle': 'Notas:',
    'notesDefault': '- Los costos son calculados de acuerdo con el volumen solicitado, en caso de necesitar diferente volumen favor de solicitar cotización\n'
        '- Componentes sujetos a disponibilidad y precio de mercado\n'
        '- Para poder manufacturar su pedido es necesario que genere una orden de compra firmada por el responsable de su empresa\n'
        '- Vigencia de cotización: 8 días hábiles\n'
        '- El cliente se hace responsable de los archivos entregados para la fabricación de su producto, en dado caso de tener algún error se debe hacer cargo de los gastos generados al 100%\n'
        '- Una vez iniciado el proceso de compra/fabricación, no se aceptan cambios en el diseño a menos de que se paguen los cambios a realizar.',
    'desc': 'Descripción',
    'unit': 'Costo unitario',
    'qty': 'Cantidad',
    'img': 'Imagen',
    'totalMXN': 'Total MXN',
    'totalUSD': 'Total USD',
    'withIva': '* Con IVA',
    'withoutIva': '* Sin IVA',
  };
}

class ExportToPDFUnified {
  // Comunes
  final QuoteType type;
  final bool isPDF;
  final bool isEnglish;
  final CustomersClass customer;
  final QuoteClass quote;
  final List<QuoteTableClass> dataTable;
  final String notes;
  final bool notesEdited; // <-- NUEVO: true si el usuario modificó algo

  // Solo para Ensambles
  final bool addComponents;
  final bool addPCB;

  ExportToPDFUnified(
      {required this.type,
      required this.quote,
      required this.dataTable,
      required this.customer,
      required this.isEnglish,
      required this.isPDF,
      required this.notes,
      this.addComponents = false,
      this.addPCB = false,
      required this.notesEdited});

  Future<void> createPDF(final PdfPageFormat format) async {
    List<QuoteTableClass> rowsForExport = dataTable;

// Solo para Ensambles: si el PDF es EN y las filas no están editadas -> usar plantillas EN
    if (type == QuoteType.assembly) {
      final allUnedited = rowsForExport.every((r) => r.isDescEdited == false);

      if (isEnglish && allUnedited) {
        // Factory EN usando los mismos datos
        rowsForExport = assemblyDefaultRowsEN(
          quote: quote,
          customer: customer,
          addComponents: addComponents,
          addPCB: addPCB,
          currencyFormatted: (v) {
            // Usa tu NumberFormat real:
            // return formatter.format(v);
            // Nota: si tu unitario/total ya se guardaron como strings formateadas,
            // y quieres mantenerlo igual, podrías copiar r.unitario/r.total en vez de recalcular.
            return NumberFormat.decimalPatternDigits(
              locale: 'en_US',
              decimalDigits: 2,
            ).format(v);
          },
        );
      } else if (!isEnglish && allUnedited) {
        // Asegura que, si vas a ES y tenías default, uses ES consistente
        rowsForExport = assemblyDefaultRowsES(
          quote: quote,
          customer: customer,
          addComponents: addComponents,
          addPCB: addPCB,
          currencyFormatted: (v) => NumberFormat.decimalPatternDigits(
            locale: 'es_MX',
            decimalDigits: 2,
          ).format(v),
        );
      }
    }

    String resolveNotes(QuoteL10n l10n, String currentNotes, bool notesEdited) {
      if (notesEdited) {
        // El usuario escribió algo → respetamos su string
        return currentNotes;
      } else {
        // No editó → usamos el default del idioma
        return l10n.t('notesDefault');
      }
    }

    // Locales necesarios para meses en ES/EN
    await initializeDateFormatting('es_MX');
    await initializeDateFormatting('en_US');

    final l10n = QuoteL10n(isEnglish);
    final String resolvedNotes = resolveNotes(l10n, notes, notesEdited);
    // ===== locales =====
    final nowTime =
        DateFormat('yyyy.MM.dd HH:mm:ss', isEnglish ? 'en_US' : 'es_MX')
            .format(DateTime.now());
    final formatter = NumberFormat.decimalPatternDigits(
      locale: isEnglish ? 'en_US' : 'es_MX',
      decimalDigits: 2,
    );
    final dt = DateTime.parse(quote.date!);

    // Fecha con capitalización del mes en ES
    String dateStr;
    if (isEnglish) {
      dateStr = DateFormat('MMMM d, yyyy', 'en_US').format(dt);
    } else {
      final base =
          DateFormat('MMMM d, yyyy', 'es_MX').format(dt); // "enero 21, 2025"
      final mes = DateFormat('MMMM', 'es_MX').format(dt); // "enero"
      final mesCap = mes[0].toUpperCase() + mes.substring(1); // "Enero"
      dateStr = base.replaceFirst(mes, mesCap);
    }

    // ===== imágenes =====
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/HeaderAJ.png'))
          .buffer
          .asUint8List(),
    );
    final footer = pw.MemoryImage(
      (await rootBundle.load('assets/images/FooterAJ.png'))
          .buffer
          .asUint8List(),
    );
    final logoEmpresa = pw.MemoryImage(convertListToInt(customer.logo!));
    pw.MemoryImage? pcbImage;
    if (type == QuoteType.assembly &&
        addPCB &&
        (quote.PCBImage?.isNotEmpty ?? false)) {
      pcbImage = pw.MemoryImage(base64.decode(quote.PCBImage!));
    }

    // ===== fuentes =====
    final body = await PdfGoogleFonts.openSansMedium();
    final bodyBold = await PdfGoogleFonts.openSansBold();

    pw.TextStyle arial(double size, String weight) =>
        pw.TextStyle(font: weight == 'bold' ? bodyBold : body, fontSize: size);

    pw.TextStyle arialTitle() => pw.TextStyle(
          font: bodyBold,
          fontSize: 14,
          decoration: pw.TextDecoration.underline,
        );

    pw.TextStyle description(bool underline) => pw.TextStyle(
          font: body,
          fontSize: 9,
          color: PdfColors.grey,
          decoration:
              underline ? pw.TextDecoration.underline : pw.TextDecoration.none,
        );

    // ===== columnas por tipo =====
    final currency = (quote.currency ?? 'MXN').toUpperCase();
    late final List<String> columns;

    if (type == QuoteType.manufacture) {
      columns = [
        l10n.t('desc'),
        l10n.t('unit'),
        l10n.t('qty'),
        l10n.t('img'),
        currency == 'MXN' ? l10n.t('totalMXN') : l10n.t('totalUSD'),
      ];
    } else {
      // Ensamble (sin columna de imagen)
      columns = [
        l10n.t('desc'),
        l10n.t('unit'),
        l10n.t('qty'),
        currency == 'MXN' ? l10n.t('totalMXN') : l10n.t('totalUSD'),
      ];
    }

    // ===== total seguro =====
    double total = 0.0;
    for (final r in rowsForExport) {
      final txt = (r.total ?? '').replaceAll(',', '').trim();
      total += double.tryParse(txt) ?? 0.0;
    }

// ===== paginación adaptativa =====
    int pcbBlockIndex = addComponents ? 1 : 0;

    double rowWeight(QuoteTableClass r, int idx) {
      const perExtraLine = 0.35;
      const imagePenalty = 0.8;

      final desc = (r.description ?? '');
      final lines = desc.split('\n');
      int wraps = 0;
      for (final ln in lines) {
        final over = ln.length - 78;
        if (over > 0) wraps += (over / 78).floor();
      }

      final hasImg = type == QuoteType.manufacture
          ? (r.image?.isNotEmpty ?? false)
          : (addPCB &&
              idx == pcbBlockIndex); // sólo el bloque PCB pesa como imagen

      return 1.0 +
          perExtraLine * (lines.length - 1 + wraps) +
          (hasImg ? imagePenalty : 0.0);
    }

// Caps
    const double firstPageCap = 6.0;
    const double nextPageCap = 7.0;

// Construcción robusta de páginas
    final List<List<QuoteTableClass>> pages = [];
    double cap = firstPageCap;
    double acc = 0.0;
    List<QuoteTableClass> bucket = [];

// Pequeño margen de seguridad para evitar cortes “al límite”
    const double EPS = 0.001;

    for (int i = 0; i < rowsForExport.length; i++) {
      final r = rowsForExport[i];
      double w = rowWeight(r, i);

      // Si una fila es más "alta" que la capacidad de la página,
      // la “recortamos” virtualmente al ~90% del cap para que
      // siempre entre sola sin provocar un bucket vacío previo.
      final double maxThisPage = cap * 0.90;
      if (w > maxThisPage) w = maxThisPage;

      // Si no cabe y ya hay algo en el bucket, cerramos página
      if (bucket.isNotEmpty && acc + w > cap - EPS) {
        pages.add(bucket);
        bucket = [];
        acc = 0.0;
        cap = nextPageCap; // del resto en adelante
      }

      bucket.add(r);
      acc += w;
    }
// Último bucket (sólo si tiene algo)
    if (bucket.isNotEmpty) pages.add(bucket);

// SANITY: si por algún motivo llegara a quedar una página vacía, la quitamos
    pages.removeWhere((b) => b.isEmpty);

    // ===== documento =====
    final pdf = pw.Document();
    final pageTheme = await _mypageTheme(format);

    for (int p = 0; p < pages.length; p++) {
      final rows = pages[p];
      if (rows.isEmpty) continue; // 🔒 nunca agregues una página sin filas
      print('page $p rows=${pages[p].length}');
      pdf.addPage(
        pw.MultiPage(
          pageTheme: pageTheme,
          // ===== Header =====
          header: (context) => pw.Stack(
            children: [
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
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 60, right: 30),
                alignment: pw.Alignment.topRight,
                child: pw.Text(
                  "$dateStr, Zapopan Jalisco.",
                  style: arial(10, 'normal'),
                ),
              ),
            ],
          ),

          // ===== Footer =====
          footer: (context) => pw.Stack(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 236, left: 25),
                alignment: pw.Alignment.bottomLeft,
                child: pw.Text(
                  "${context.pageNumber}/${context.pagesCount}",
                  style: arial(10, 'normal'),
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 80, top: 100),
                child: pw.Image(
                  footer,
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
            ],
          ),

          // ===== Body =====
          build: (context) => [
            // ===== Info (solo en la primera página) =====
            pw.Opacity(
              opacity: p == 0 ? 1 : 0,
              child: pw.Container(
                height: p == 0 ? 135 : 0,
                margin: const pw.EdgeInsets.symmetric(
                  horizontal: 1 * PdfPageFormat.cm,
                  vertical: 0.0,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: "${l10n.t('project')}: ",
                            style: arial(11, 'bold'),
                          ),
                          pw.TextSpan(
                            text: "${quote.proyectName}.",
                            style: arial(10, 'normal'),
                          ),
                        ],
                      ),
                    ),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Image(logoEmpresa, height: 50),
                        pw.SizedBox(height: 10),
                        pw.RichText(
                          textAlign: pw.TextAlign.right,
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: "${l10n.t('quotation')}: ",
                                style: arial(9, 'bold'),
                              ),
                              pw.TextSpan(
                                text: "${quote.quoteNumber}\n",
                                style: arial(8, 'normal'),
                              ),
                              pw.TextSpan(
                                text: "${l10n.t('company')}: ",
                                style: arial(9, 'bold'),
                              ),
                              pw.TextSpan(
                                text: "${customer.name}\n",
                                style: arial(8, 'normal'),
                              ),
                              pw.TextSpan(
                                text: "${l10n.t('attention')}: ",
                                style: arial(9, 'bold'),
                              ),
                              pw.TextSpan(
                                text: "${quote.attentionTo}\n",
                                style: arial(8, 'normal'),
                              ),
                              pw.TextSpan(
                                text: "${l10n.t('requested')}: ",
                                style: arial(9, 'bold'),
                              ),
                              pw.TextSpan(
                                text:
                                    "${quote.requestedByName}\n${quote.requestedByEmail}\n",
                                style: arial(8, 'normal'),
                              ),
                              pw.TextSpan(
                                text: "${l10n.t('terms')}: ",
                                style: arial(9, 'bold'),
                              ),
                              pw.TextSpan(
                                text: isEnglish
                                    ? "${quote.deliverTimeInfo}\n"
                                    : "${(quote.deliverTimeInfo ?? '').replaceAll('days', 'días')}\n",
                                style: arial(8, 'normal'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ===== Título (solo primera hoja) =====
            pw.Opacity(
              opacity: p == 0 ? 1 : 0,
              child: pw.Container(
                height: p == 0 ? 20 : 0,
                margin: const pw.EdgeInsets.only(top: 0, bottom: 10),
                alignment: pw.Alignment.center,
                child: pw.Text(l10n.t('quotation'), style: arialTitle()),
              ),
            ),

            // ===== Tabla (con márgenes laterales 1 cm) =====
            pw.Container(
              margin: const pw.EdgeInsets.symmetric(
                horizontal: 1 * PdfPageFormat.cm,
                vertical: 0,
              ),
              child: pw.SizedBox(
                width: math.max(200, (currentUser.width ?? 800) - 500),
                child: pw.Table(
                  border: pw.TableBorder.all(),
                  defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.TableRow(
                      children: [
                        for (final c in columns)
                          pw.Text(
                            c,
                            style: arial(9, 'normal'),
                            textAlign: pw.TextAlign.center,
                          ),
                      ],
                    ),
                    ...List.generate(rows.length, (index) {
                      final r = rows[index];
                      final split = (r.description ?? '').split('\n');

                      if (type == QuoteType.assembly) {
                        // Ensamble: PCB especial una sola vez en index = (addComponents ? 1 : 0)
                        final specialIdx = addComponents ? 1 : 0;
                        if (addPCB && pcbImage != null && index == specialIdx) {
                          // Bloque con 3 primeras líneas + imagen + resto subrayado
                          final first = split.isNotEmpty ? split[0] : '';
                          final second = split.length > 1 ? split[1] : '';
                          final third = split.length > 2 ? split[2] : '';
                          final rest = split.length > 3
                              ? split.sublist(3)
                              : const <String>[];

                          return pw.TableRow(
                            children: [
                              pw.Container(
                                width: 250,
                                margin: const pw.EdgeInsets.only(
                                    left: 5, bottom: 5),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(first, style: description(false)),
                                    pw.Text(second, style: description(false)),
                                    pw.Text(third, style: description(false)),
                                    pw.SizedBox(height: 4),
                                    pw.Image(pcbImage,
                                        fit: pw.BoxFit.contain,
                                        width: 350,
                                        height: 50),
                                    for (final t in rest)
                                      pw.Container(
                                        margin:
                                            const pw.EdgeInsets.only(top: 4),
                                        child: pw.Text(t,
                                            style: description(true)),
                                      ),
                                  ],
                                ),
                              ),
                              pw.Text("\$${r.unitario ?? ''}",
                                  style: arial(9, 'normal'),
                                  textAlign: pw.TextAlign.center),
                              pw.Text(r.cantidad ?? '',
                                  style: arial(9, 'normal'),
                                  textAlign: pw.TextAlign.center),
                              pw.Text("\$${r.total ?? ''}",
                                  style: arial(9, 'normal'),
                                  textAlign: pw.TextAlign.center),
                            ],
                          );
                        }

                        // Fila normal de ensamble
                        return pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.only(bottom: 5),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < split.length; i++)
                                    pw.Container(
                                      alignment: pw.Alignment.centerLeft,
                                      width: 250,
                                      margin: i == split.length - 1
                                          ? const pw.EdgeInsets.only(bottom: 5)
                                          : pw.EdgeInsets.zero,
                                      child: pw.Text(
                                        split[i],
                                        style:
                                            description(i == split.length - 1),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            pw.Text("\$${r.unitario ?? ''}",
                                style: arial(9, 'normal'),
                                textAlign: pw.TextAlign.center),
                            pw.Text(r.cantidad ?? '',
                                style: arial(9, 'normal'),
                                textAlign: pw.TextAlign.center),
                            pw.Text("\$${r.total ?? ''}",
                                style: arial(9, 'normal'),
                                textAlign: pw.TextAlign.center),
                          ],
                        );
                      } else {
                        // Manufactura
                        return pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.only(bottom: 5),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < split.length; i++)
                                    pw.Container(
                                      alignment: pw.Alignment.centerLeft,
                                      width: 250,
                                      margin: i == split.length - 1
                                          ? const pw.EdgeInsets.only(bottom: 5)
                                          : pw.EdgeInsets.zero,
                                      child: pw.Text(split[i],
                                          style: description(false)),
                                    ),
                                ],
                              ),
                            ),
                            pw.Text("\$${r.unitario ?? ''}",
                                style: arial(9, 'normal'),
                                textAlign: pw.TextAlign.center),
                            pw.Text(r.cantidad ?? '',
                                style: arial(9, 'normal'),
                                textAlign: pw.TextAlign.center),
                            (r.image?.isNotEmpty ?? false)
                                ? pw.Container(
                                    margin: const pw.EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: pw.Center(
                                      child: pw.Image(
                                        pw.MemoryImage(base64.decode(r.image!)),
                                        height: 30,
                                        width: 50,
                                      ),
                                    ),
                                  )
                                : pw.Text(''),
                            pw.Text("\$${r.total ?? ''}",
                                style: arial(9, 'normal'),
                                textAlign: pw.TextAlign.center),
                          ],
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),

            // ===== Total (solo última) alineado con la tabla (1 cm) =====
            pw.Opacity(
              opacity: p == pages.length - 1 ? 1 : 0,
              child: pw.Container(
                margin: const pw.EdgeInsets.symmetric(
                    horizontal: 1 * PdfPageFormat.cm),
                height: p == pages.length - 1 ? 25 : 0,
                width: 538.5,
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 538.5 - "\$${formatter.format(total)}".length * 5,
                      height: 25,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.rectangle,
                        border: pw.Border.all(width: 1),
                      ),
                      child: pw.Text(
                        "Total $currency ${(quote.conIva ?? false) ? l10n.t('withIva') : l10n.t('withoutIva')}",
                        style: arial(9, 'normal'),
                        textAlign: pw.TextAlign.end,
                      ),
                    ),
                    pw.Container(
                      width: "\$${formatter.format(total)}".length * 5,
                      height: 25,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.rectangle,
                        border: pw.Border.all(width: 1),
                      ),
                      child: pw.Text(
                        "\$${formatter.format(total)}",
                        style: arial(9, 'normal'),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== Firma + fecha (solo última) centradas y con padding lateral 1 cm =====
            pw.Opacity(
              opacity: p == pages.length - 1 ? 1 : 0,
              child: pw.Container(
                margin: const pw.EdgeInsets.only(top: 10),
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 1 * PdfPageFormat.cm),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "${l10n.t('signed')}: ${user!.name} ${user!.lastName}\nEmail: ${user!.email}\n${l10n.t('date')}: $nowTime",
                  style: arial(10, 'bold'),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ),

            // ===== Notas (solo última) con tu formato original (fondo blanco) =====
            if (p == pages.length - 1 && notes.isNotEmpty)
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 80, right: 30, top: 20),
                padding: pw.EdgeInsets.zero,
                decoration: const pw.BoxDecoration(color: PdfColors.white),
                child: pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: "${l10n.t('notesTitle')}\n",
                        style: arial(10, 'bold'),
                      ),
                      pw.TextSpan(
                        text: resolvedNotes,
                        style: pw.TextStyle(font: bodyBold, fontSize: 7),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // ===== Guardado =====
    final savedFile = await pdf.save();
    final fileInts = List<int>.from(savedFile);

    if (isPDF) {
      if (kIsWeb) {
        html.AnchorElement(
          href: "data:application/pdf;base64,${base64.encode(fileInts)}",
        )
          ..setAttribute(
            'download',
            "${QuoteL10n(isEnglish).t('quotation')}-${quote.quoteNumber!.replaceAll('_', '')}.pdf",
          )
          ..click();
      }
    } else {
      // DOCX via Aspose
      final config = Configuration(
        "443ce684-cae3-461e-b516-d892a3899dad",
        "2e185ee73c4fc2ef2d75ed9667e9f4d7",
      );
      final wordsApi = WordsApi(config);
      final doc = (savedFile).buffer.asByteData();
      final request = ConvertDocumentRequest(doc, 'docx');
      final convert = await wordsApi.convertDocument(request);

      final blob = html.Blob([convert]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download =
            "${QuoteL10n(isEnglish).t('quotation')}-${quote.quoteNumber!.replaceAll('_', '')}.docx";
      html.document.body!.children.add(anchor);
      anchor.click();
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
    buildBackground: (context) => pw.FullPage(ignoreMargins: true),
  );
}
