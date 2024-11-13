import 'dart:convert';

import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/main.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getProjectsFromUser(List<dynamic>? projectsId) async {
  if (projectsId == null) {
    return;
  }
// Future<Map<int, Map<String, dynamic>>> getProjectsFromDataBase() async {
  final response = await http.post(
    Uri.parse('$addressUsers/Projects'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
    body: jsonEncode({'ids': projectsId}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return response.statusCode;
  }
}
