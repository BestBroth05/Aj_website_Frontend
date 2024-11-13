import 'dart:convert';

import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/main.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getProjectsFromDataBase() async {
// Future<Map<int, Map<String, dynamic>>> getProjectsFromDataBase() async {
  final response = await http.get(
    Uri.parse('$address/Projects'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    return response.statusCode;
  }
}

Future<int> addProjectToDataBase(Map<String, dynamic> project) async {
  final response = await http.put(
    Uri.parse('$address/Projects'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
    body: jsonEncode(project),
  );

  return response.statusCode;
}

Future<int> editProjectToDataBase(Map<String, dynamic> project) async {
  final response = await http.patch(
    Uri.parse('$address/Projects'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
    body: jsonEncode(project),
  );

  return response.statusCode;
}

Future<int> editTasksInProjectInDataBase(Map<String, dynamic> project) async {
  final response = await http.patch(
    Uri.parse('$address/Projects/Tasks/'),
    headers: <String, String>{
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "$token",
    },
    body: jsonEncode(project),
  );

  return response.statusCode;
}
