import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';

class BomTableHeader extends StatelessWidget {
  final Map<String, int> headers;
  final double? totalCost;
  const BomTableHeader(
    this.headers, {
    Key? key,
    this.totalCost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: teal.add(black, 0.3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(2.5)),
      ),
      child: Row(
        children: headers.entries
            .map(
              (e) => Expanded(
                flex: e.value,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: white),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    e.key == 'mpn'
                        ? e.key.toUpperCase()
                        : e.key == 'total cost' && totalCost != null
                            ? e.key.toTitle() +
                                '\n\$ ${totalCost!.toStringAsFixed(2)}'
                            : e.key.toTitle(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: white),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
