import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_view.dart';

class AJCartHeader extends StatelessWidget {
  final String title;
  final int flex;
  final bool rightBorder;
  final bool leftBorder;
  const AJCartHeader(
    this.title, {
    Key? key,
    this.flex = 1,
    this.leftBorder = false,
    this.rightBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _title = title.toString().split('_').join(' ').toTitle();

    if (title == 'total_cost_digikey') {
      _title += '\n\$ ${AJCartView.totalDigikey.toStringAsFixed(2)}';
    }
    if (title == 'total_cost_mouser') {
      _title += '\n\$ ${AJCartView.totalMouser.toStringAsFixed(2)}';
    }

    return Container(
      height: 80,
      width: 70.0 * (flex + 1),
      decoration: BoxDecoration(
        color: teal.add(black, 0.2),
        border: Border(
          right: rightBorder
              ? BorderSide(color: gray.add(teal, 0.5))
              : BorderSide.none,
          left: leftBorder
              ? BorderSide(color: gray.add(teal, 0.5))
              : BorderSide.none,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: AutoSizeText(
            _title,
            style: TextStyle(color: white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
