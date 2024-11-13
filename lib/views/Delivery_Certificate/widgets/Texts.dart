import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get themePopUp {
  return ThemeData(primaryColor: Colors.white24);
}

TextStyle get hintStyle {
  return TextStyle(
      color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 15);
}

TextStyle get fieldStyle {
  return TextStyle(
      color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15);
}

TextStyle get titlePopUp {
  return TextStyle(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
}

TextStyle get contentPopUp {
  return TextStyle(color: Colors.black, fontSize: 13);
}

TextStyle get buttonsPopUp {
  return TextStyle(
      fontWeight: FontWeight.normal, fontSize: 18, color: ButtonBlue);
}

TextStyle get buttonsCancelPopUp {
  return TextStyle(
      fontWeight: FontWeight.normal, fontSize: 18, color: Colors.red);
}

TextStyle get titleh1 {
  return TextStyle(
      fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white);
}

TextStyle get buttonAdd {
  return TextStyle(
      fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
}

TextStyle get h1PDF {
  return TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);
}

TextStyle get bodyPDF {
  return TextStyle(fontSize: 11, color: Colors.black);
}

TextStyle get bodyBoldPDF {
  return TextStyle(
      fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black);
}

TextStyle get underlinePDF {
  return TextStyle(
      fontSize: 11, color: Colors.black, decoration: TextDecoration.underline);
}

Color get ButtonBlue {
  return const Color.fromARGB(255, 42, 107, 166);
}

TextStyle get fieldText {
  return TextStyle(color: Colors.teal, fontWeight: FontWeight.bold);
}
