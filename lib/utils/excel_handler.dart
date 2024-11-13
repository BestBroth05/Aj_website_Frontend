import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/classes/bom_part.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'dart:html' as html;

import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<excel.Excel?> pickExcelFile() async {
  excel.Excel? excel2;
  FilePickerResult? pickedFile = await pickFile();

  if (pickedFile != null) {
    Uint8List bytes = pickedFile.files.single.bytes!;
    try {
      excel2 = excel.Excel.decodeBytes(bytes);
    } on Exception catch (e) {
      print(e);
    }
  }

  return excel2;
}

void exportBOM(
  List<String> headers,
  List<Map<String, dynamic>> parts, {
  int requiredTimes = 1,
  double totalCost = 0,
}) {
  // print(parts);
  // Excel excel = Excel.createExcel();
  Workbook workbook = Workbook();

  Worksheet sheet = workbook.worksheets[0];

  addToSheet(sheet, 1, [
    'Date:',
    DateTime.now().dateFormatted + ' ' + DateTime.now().timeFormatted,
    '',
    'Required times:',
    requiredTimes.toString(),
  ]);

  addToSheet(sheet, 2, [
    'Name:',
    user!.fullName,
    '',
    'Total cost:',
    '\$ $totalCost',
  ]);
  addToSheet(sheet, 4, headers);
  int r = 0;
  for (Map<String, dynamic> part in parts) {
    List<dynamic> row = [
      part['designator'],
      part['description'],
      part['manufacturer'],
    ];

    List<dynamic> a = _mpnValues(
      part['mpn'],
      part['quantity'],
      part['using'],
      part,
    );
    List<dynamic> b = _mpnValues(
      part['alt1'],
      part['alt1_quantity'],
      part['using1'],
      part['alternative1'],
    );
    List<dynamic> c = _mpnValues(
      part['alt2'],
      part['alt2_quantity'],
      part['using2'],
      part['alternative2'],
    );

    row.addAll(a);
    row.addAll(b);
    row.addAll(c);

    int totalUsed = a[2] + b[2] + c[2];
    int needed =
        totalUsed < part['required'] ? part['required'] - totalUsed : 0;

    row.addAll([
      part['required'],
      needed,
      a[4] + b[4] + c[4],
      a[3] + b[3] + c[3],
    ]);

    addToSheet(sheet, 5 + r, row);
    List<List<dynamic>> values = [a, b, c];
    for (int i = 0; i < values.length; i++) {
      List<dynamic> letter = values[i];
      String color = '#FFFFFF';
      if (letter[1] == 'N/A') {
        color = '#FBDAD7';
      } else if (letter[1] < letter[2]) {
        color = '#FEF2CD';
      }
      int initial = 3 + (letter.length * i);
      int last = initial + letter.length;
      for (int j = initial; j < last; j++) {
        sheet.getRangeByIndex(5 + r, j).cellStyle = CellStyle(workbook)
          ..backColor = color;
        // sheet.rows[][j]!.cellStyle =
        // CellStyle(backgroundColorHex: color);
      }
    }
    r += 1;
  }

  // for (int i = 4; i < sheet.maxRows; i++) {
  //   int quantity = int.tryParse(parts[i - 4]['quantity'].toString()) ?? 0;
  //   int required = parts[i - 4]['required'];

  //   for (int j = 0; j < parts[0].values.length; j++) {
  //     String color = quantity == 0
  //         ? '#FBDAD7'
  //         : quantity < required
  //             ? '#FEF2CD'
  //             : '#FFFFFF';

  //     sheet.rows[i][j]!.cellStyle = CellStyle(backgroundColorHex: color);
  //   }
  // }
  sheet.getRangeByName('E5:J5').showColumns(false);
  sheet.getRangeByName('L5:Q5').showColumns(false);
  sheet.getRangeByName('S5:X5').showColumns(false);
  List<int>? bytes = workbook.saveAsStream();
  downloadFile(bytes, 'BOM.xlsx');
  workbook.dispose();
}

List<dynamic> _mpnValues(
  dynamic mpn,
  dynamic quantity,
  dynamic using,
  dynamic data,
) {
  using = using.toString();
  using = int.tryParse(using) ?? 0;
  int remaining = (quantity ?? 0) - using;
  int needed = remaining < 0 ? remaining * -1 : 0;
  remaining = remaining >= 0 ? remaining : 0;
  quantity = quantity ?? 'N/A';
  mpn = mpn ?? 'N/A';
  double cost = 0;

  if (data != null) {
    cost = data['unitPrice'] ?? 0;
  }
  return [mpn, quantity, using, remaining, needed, cost, cost * using];
}

String exportExcelCart(
  List<String> headers,
  List<Map<String, dynamic>> parts, {
  int requiredTimes = 1,
  double totalCost = 0,
  String fileName = 'BOM',
}) {
  if (parts.isEmpty) {
    return '';
  }

  List<List<String>> rows = [];

  for (Map<String, dynamic> part in parts) {
    rows.add(
      [
        part['mpn'],
        (int.parse(part['required'].toString()) * requiredTimes).toString(),
      ],
    );
  }

  String csv = ListToCsvConverter().convert(rows);

  List<int>? bytes = utf8.encode(csv);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = '$fileName.csv';
  html.document.body?.children.add(anchor);
  anchor.click();
  html.Url.revokeObjectUrl(url);
  return csv;
}

void addToSheet(Worksheet sheet, int row, List<dynamic> values) {
  for (int i = 1; i < values.length + 1; i++) {
    sheet.getRangeByIndex(row, i).setText(values[i - 1].toString());
  }
}
