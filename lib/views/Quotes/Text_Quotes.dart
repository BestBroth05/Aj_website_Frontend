import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get dateText {
  return GoogleFonts.nunito(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal);
}

TextStyle get title3 {
  return GoogleFonts.nunito(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
}

TextStyle get title2 {
  return GoogleFonts.nunito(
      color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold);
}

TextStyle get title1 {
  return GoogleFonts.nunito(
      color: Colors.black,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline);
}

TextStyle get infoText {
  return GoogleFonts.nunito(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal);
}

TextStyle get dataText {
  return GoogleFonts.nunito(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal);
}

TextStyle get descriptionText {
  return GoogleFonts.nunito(
      color: Colors.grey, fontSize: 18, fontWeight: FontWeight.normal);
}

TextStyle get descriptionTextBold {
  return GoogleFonts.nunito(
      color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold);
}
