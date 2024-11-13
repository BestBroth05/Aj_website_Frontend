import 'dart:math';

import 'package:flutter/material.dart';

Color get randomColor {
  var rng = new Random();
  return Color.fromARGB(
    255,
    rng.nextInt(256),
    rng.nextInt(256),
    rng.nextInt(256),
  );
}

Color get black {
  return Colors.black;
}

Color get backgroundColor {
  return Colors.grey[200]!;
}

Color get lightGrey {
  return Colors.grey[100]!;
}

Color get lightDarkGrey {
  return Colors.grey[300]!;
}

Color get darkGrey {
  return Colors.grey[800]!;
}

Color get white {
  return Colors.white;
}

Color get red {
  return Colors.red[400]!;
}

Color get green {
  return Colors.green[400]!;
}

Color get darkGreen {
  return Colors.green[700]!;
}

Color get lightGreen {
  return Colors.green[200]!;
}

Color get gray {
  return Colors.grey[400]!;
}

Color get yellow {
  return Colors.yellow[400]!;
}

Color get blue {
  return Colors.blue[400]!;
}

Color get darkBlue {
  return Colors.blue[600]!;
}

Color get darkNight {
  return Colors.blueGrey[900]!;
}

Color get teal {
  return Colors.teal;
}

Color get lila {
  return Color.fromRGBO(211, 216, 254, 1);
}

Color get darkAmber {
  return Colors.amber[900]!;
}

Gradient get fadedVertical {
  return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [white, teal, white],
      stops: [0.1, 0.5, 0.9]);
}

Gradient get linearAngled {
  return LinearGradient(
    colors: [green, white],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    // stops: [0.3, 0.9],
  );
}

Gradient linearGradient(
    {required List<Color> colors,
    required Alignment begin,
    required Alignment end,
    List<double>? stops}) {
  return LinearGradient(
    colors: colors,
    begin: begin,
    end: end,
    stops: stops,
  );
}

Color addColor(Color a, Color b, double amount) {
  int red = (a.red * (1 - amount) + b.red * amount).toInt();
  int green = (a.green * (1 - amount) + b.green * amount).toInt();
  int blue = (a.blue * (1 - amount) + b.blue * amount).toInt();

  return Color.fromRGBO(red, green, blue, 1);
}

extension ColorExt on Color {
  Color add(Color b, double amount) {
    int red = (this.red * (1 - amount) + b.red * amount).toInt();
    int green = (this.green * (1 - amount) + b.green * amount).toInt();
    int blue = (this.blue * (1 - amount) + b.blue * amount).toInt();

    return Color.fromRGBO(red, green, blue, 1);
  }
}
