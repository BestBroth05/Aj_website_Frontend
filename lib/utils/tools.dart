// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'dart:convert';
import 'dart:html' as html;

double height = 0;
double width = 0;

void getScreenSize(BuildContext context) {
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
}

void showToast(
  BuildContext context, {
  required String text,
  Color color = Colors.teal,
  IconData icon = Icons.check,
}) {
  color = color.add(black, 0.2);
  FToast toast = FToast();
  toast.init(context);

  Widget child = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: white),
        SizedBox(
          width: 12.0,
        ),
        Text(text, style: TextStyle(color: white)),
      ],
    ),
  );

  toast.showToast(
    child: child,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}

void PopupError(context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData(colorScheme: ColorScheme.light()),
            child: CupertinoAlertDialog(
              title: Text(
                "Error",
                style: TextStyle(),
              ),
              content: Text("Please try again", style: TextStyle()),
              actions: [],
            ));
      });
  //await FlutterBluePlus.turnOn();
}

openDialog(
  BuildContext context, {
  bool block = false,
  bool shadowless = false,
  required Widget container,
  double barrierIntensity = 0.5,
}) =>
    showGeneralDialog(
        barrierColor: black.withOpacity(barrierIntensity),
        transitionBuilder: (context, a1, a2, _widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                elevation: 0,
                backgroundColor: Colors.white.withOpacity(0),
                contentPadding: EdgeInsets.zero,
                insetPadding: EdgeInsets.zero,
                content: Container(
                  child: container,
                  decoration: BoxDecoration(
                    boxShadow: shadowless
                        ? null
                        : [
                            BoxShadow(
                              color: black.withOpacity(0.5),
                              blurRadius: 20,
                            )
                          ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: !block,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });

void containerDialog(
  BuildContext context,
  bool block,
  Widget container,
  double barrierIntensity,
) {
  showDialog(
    barrierDismissible: !block,
    context: context,
    builder: (BuildContext context) => _createPopUp(context, container),
    barrierColor: Colors.black.withOpacity(barrierIntensity),
  );
}

void showNotification({
  required BuildContext context,
  required IconData icon,
  required Color color,
  required String text,
}) {
  containerDialog(
    context,
    true,
    AlertNotification(icon: icon, color: color, str: text),
    0.5,
  );
}

StatefulBuilder _createPopUp(BuildContext context, Widget container) {
  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        elevation: 0,
        backgroundColor: Colors.white.withAlpha(0),
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          reverse: true,
          child: container,
        ),
      );
    },
  );
}

String toTitle(String? string) {
  return string!
      .split(' ')
      .map((word) => word.length > 1
          ? word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase()
          : word.toUpperCase())
      .join(' ');
}

bool canConvertToDouble(String? str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

bool canConvertToInt(String? str) {
  if (str == null) {
    return false;
  }
  return int.tryParse(str) != null;
}

bool verifyAllValues(List<bool> values) {
  int i = 0;
  for (bool v in values) {
    if (!v) {
      return v;
    }
    i += 1;
  }
  return true;
}

String? decimalToFraction(double? value) {
  // print(value);
  if (value == null || value.toString() == 'null') {
    return null.toString();
  }
  int a = 0;
  int b = 0;
  for (int i = 1; i < 999999; i++) {
    double d = i / value;

    if (int.tryParse(d.toString()) != null) {
      a = i;
      b = int.tryParse(d.toString())!;
      break;
    }
  }

  return '$a/$b';
}

double? fractionToDecimal(String value) {
  List<String> values = value.split('/');
  if (values.length != 2) {
    return null;
  } else {
    double? a = double.tryParse(values[0]);
    double? b = double.tryParse(values[1]);

    if (a == null || b == null) {
      return null;
    } else {
      if (a == 0) {
        return a;
      }
      return a / b;
    }
  }
}

String separateWords(String str) {
  List<String> words = [];
  String word = '';
  for (String c in str.characters) {
    if (c.toUpperCase() == c) {
      if (word.isNotEmpty) {
        words.add(word);
      }

      word = c;
    } else {
      word += c;
    }
  }

  words.add(word);

  return words.join(' ').toLowerCase();
}

String toPascal(String str) {
  String words = '';
  str = str.toLowerCase();
  for (String word in str.split(' ')) {
    if (str.split(' ')[0] == word) {
      words += word;
    } else {
      words += toTitle(word);
    }
  }
  return words;
}

bool changeIntControllerValue(
  int min,
  int max,
  int toChange,
  TextEditingController controller,
) {
  String text = controller.text;
  if (text.isEmpty) {
    text = '$min';
  }
  int? value = int.tryParse(text);

  if (value == null) {
    containerDialog(
      inventoryState.context,
      true,
      AlertNotification(
          icon: Icons.warning_amber_rounded,
          color: red,
          str: 'Incorrect Value'),
      0.5,
    );
    return false;
  }

  value += toChange;

  if (min > value) {
    controller.text = '';
    return false;
  } else if (max < value) {
    controller.text = '$max';
    return false;
  } else
    controller.text = '$value';
  return true;
}

Future<void> changeScreen(BuildContext context, String route) async {
  // Navigator.pop(context);
  Navigator.pushNamed(context, route);
}

bool validateDate(String date) {
  List<String> parts = date.split('/');
  if (parts.length != 3) {
    return false;
  } else {
    int? day = int.tryParse(parts[0]);
    int? month = int.tryParse(parts[1]);
    int? year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return false;
    } else {
      if (month > 12 ||
          year > DateTime.now().year ||
          month <= 0 ||
          year <= 0 ||
          day <= 0) {
        return false;
      } else {
        bool isB = year % 4 == 0;

        month = month > 7 ? (month % 7) % 2 : month % 2;
        if (month == 0) {
          if (int.parse(parts[1]) == 2) {
            if (isB) {
              if (day > 29) {
                return false;
              }
            } else {
              if (day > 28) {
                return false;
              }
            }
          } else {
            if (day > 30) {
              return false;
            }
          }
        } else {
          if (day > 31) {
            return false;
          }
        }
      }
    }
  }

  return true;
}

Widget iconName(String word, Color? color, bool inverted) {
  return Container(
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: inverted
          ? color == null
              ? randomColor
              : color
          : white,
      shape: BoxShape.circle,
    ),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Center(
        child: AutoSizeText(
          '${getInitials(word)}'.toUpperCase(),
          style: TextStyle(
            color: inverted
                ? white
                : color == null
                    ? randomColor
                    : color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            fontFamily: 'Nunito',
          ),
          maxLines: 1,
          maxFontSize: 20,
          minFontSize: 1,
          textScaleFactor: 2,
        ),
      ),
    ),
  );
}

String getInitials(String fullname) {
  List<String> words = fullname.split(' ');
  if (words.length > 2) {
    words = words.sublist(0, 2);
  }
  String initials = '';
  for (String word in words) {
    initials += word[0];
  }

  return initials;
}

String invertWords(String word) {
  String inverted = word.split(' ').reversed.join(' ');
  return inverted;
}

String getTime() {
  return DateTime.now()
      .toString()
      .split(' ')[1]
      .split(':')
      .sublist(0, 2)
      .join(':');
}

String getDate() {
  return DateTime.now().toString().split(' ')[0];
}

Future<FilePickerResult?> pickFile({
  List<String> extensions = const ['xlsx'],
}) async {
  try {
    return FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
      allowMultiple: false,
    );
  } on Exception catch (e) {
    print(e);
  }
}

void downloadFile(List<int> bytes, String name) {
  new html.AnchorElement(
      href:
          "data:application/octet-strem;charset=utf-16le;base64,${base64.encode(bytes)}")
    ..setAttribute("download", "$name")
    ..click();
}
