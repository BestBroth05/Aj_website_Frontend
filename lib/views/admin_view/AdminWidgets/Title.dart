import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/widgets/Texts.dart';

import '../../../utils/colors.dart';

Widget TitleH1(context, text) {
  return Container(
    alignment: Alignment.center,
    color: teal.add(black, 0.3),
    height: 50,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(top: 10, bottom: 10),
    child: Text(
      text,
      style: titleh1,
    ),
  );
}
