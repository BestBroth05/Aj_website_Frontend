import 'package:excel/excel.dart';

extension ExcelExtension on Excel {
  Sheet? get partListReport {
    for (MapEntry<String, Sheet> sheet in this.tables.entries) {
      if (sheet.key == 'Part List Report') {
        return sheet.value;
      }
    }

    return null;
  }

  List<List<Data?>>? get table {
    List<List<Data?>> _table = [];

    Sheet? partListReport = this.partListReport;
    if (partListReport != null) {
      bool inTable = false;
      for (int i = 0; i < partListReport.maxRows; i++) {
        List<Data?> row = partListReport.rows[i];
        Data? cell = row[1];
        if (cell != null) {
          if (cell.value == '#') {
            inTable = true;
          } else if (cell.value == 'Approved') {
            inTable = false;
            break;
          } else if (inTable) {
            _table.add(row.sublist(1));
          }
        }
      }
    }

    if (_table.length < 2) {
      return null;
    } else {
      return _table;
    }
  }
}
