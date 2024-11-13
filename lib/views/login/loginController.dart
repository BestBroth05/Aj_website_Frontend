import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/route.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> login(
  BuildContext context,
  String username,
  String password,
) async {
  bool allGood = false;
  openDialog(context, container: BasicTextDialog('Loading...'));
  try {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    String? tokenTemp = await getUserInDatabase(context, username, password);
    if (tokenTemp != null) {
      token = tokenTemp;
      _preferences.setString('token', token!);
      // print('[WEBSITE] Token set: $token');

      user = await getUserFromToken();
      allGood = true;
    } else {
      print('[DATABASE] No user found...');
    }
  } on Exception catch (e) {
    allGood = false;
    print('[ERROR] : ${e.toString()}');
  }
  Navigator.pop(context);
  if (!allGood) {
    openDialog(
      context,
      container: TimedDialog(
        text: 'Incorrect username or password',
      ),
    );
  }
  return allGood;
}

Future<void> logout(BuildContext context) async {
  removeTokenFromDatabase(context, token!);
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  if (_preferences.containsKey('token')) {
    _preferences.remove('token');
  }
  token = null;
  user = null;
  print('[WEBSITE] Logged out');
  changeScreen(context, AJRoute.home.url);
}
