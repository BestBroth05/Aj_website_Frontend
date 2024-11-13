import 'dart:convert';

import 'package:guadalajarav2/database.dart';
import 'package:http/http.dart' as http;

String _addressAboutProjects = '$address/AboutProjects';

Future<Map<String, int>> getProjectLikes() async {
  var response = await http.get(
    Uri.parse('$_addressAboutProjects'),
    headers: {"Access-Control-Allow-Origin": "*"},
  );

  Map<String, int> allJsons = {};

  for (dynamic json in jsonDecode(response.body)) {
    allJsons.putIfAbsent(json['project_name'], () => json['num_likes']);
  }

  return allJsons;
}

Future<int> putProjectLikes(Map<String, String> body) async {
  var response = await http.post(
    Uri.parse('$_addressAboutProjects'),
    body: jsonEncode(body),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response.statusCode;
}

Future<int> patchProjectLikes(Map<String, int> body) async {
  var response = await http.patch(
    Uri.parse('$_addressAboutProjects'),
    body: jsonEncode(body),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response.statusCode;
}
