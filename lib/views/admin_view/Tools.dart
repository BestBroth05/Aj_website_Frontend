import 'dart:typed_data';

Uint8List convertListToInt(String input) {
  final reg = RegExp(r"([0-9]+|\d+)");
  final pieces = reg.allMatches(input);
  final result = pieces.map((e) => int.parse(e.group(0).toString())).toList();

  List<int> example = result;

  return Uint8List.fromList(example);
}
