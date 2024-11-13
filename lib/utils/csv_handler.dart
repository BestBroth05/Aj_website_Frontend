import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:guadalajarav2/utils/tools.dart';

Future<List<List<String>>?> openCSV() async {
  FilePickerResult? result = await pickFile(extensions: ['csv']);

  if (result != null) {
    final bytes = result.files.single.bytes;
    if (bytes == null) {
      return null;
    }
    final decoded = utf8.decode(bytes.toList());
    final splitted = decoded.split('\n');
    List<List<String>> values = [];
    for (String s in splitted.sublist(1)) {
      if (s.isEmpty) {
        continue;
      } else {
        values.add(s.split(','));
      }
    }
    return values;
  }
}
