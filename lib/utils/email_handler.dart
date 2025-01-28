// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> sendEmail({
  required String email,
  required String name,
  required String text,
  required String phone,
}) async {
  try {
    final response = await http.post(
      Uri.parse(
          'http://ec2-3-129-169-30.us-east-2.compute.amazonaws.com:8000/Contact'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      },
      body: jsonEncode(
        {'name': name, 'text': 'From: $email\n$text\n\n$name\n$phone'},
      ),
    );
    return true;
  } on Exception catch (_) {
    return false;
  }
}
