import 'package:flutter/material.dart';

Widget CustomCicleAvatar(image) {
  return Container(
    height: 75,
    width: 75,
    decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        image: DecorationImage(image: MemoryImage(image))),
  );
}
