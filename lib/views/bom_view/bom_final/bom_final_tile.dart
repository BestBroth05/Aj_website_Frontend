import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class BomFinalTile extends StatefulWidget {
  final Map<String, dynamic> part;
  final bool isOdd;
  BomFinalTile(this.part, {Key? key, this.isOdd = false}) : super(key: key);

  @override
  State<BomFinalTile> createState() => _BomFinalTileState();
}

class _BomFinalTileState extends State<BomFinalTile> {
  // Mpn get part => widget.part.allMPN[widget.part.selected]!;
  int needed = 0;
  List<dynamic> partValues = [];
  @override
  void initState() {
    super.initState();
    // print('${widget.part['quantity']} ${widget.part['using']}');

    int remaining = (widget.part['quantity'] - widget.part['using']);
    needed = remaining < 0 ? remaining * -1 : 0;
    remaining = remaining >= 0 ? remaining : 0;
    double cost = (widget.part['unitPrice'] * widget.part['using']);
    String designator = '';
    for (MapEntry d in widget.part['designators'].entries) {
      if (designator.isEmpty) {
        designator += '${d.key + 1}: ${d.value}';
      } else {
        designator += '\n${d.key + 1}: ${d.value}';
      }
    }

    partValues = [
      designator,
      widget.part['description'],
      widget.part['mpn'],
      widget.part['unitPrice'],
      widget.part['quantity'],
      widget.part['using'],
      remaining,
      needed,
      '\$ ${cost.toStringAsFixed(2)}',
      // part.quantityString,
      // part.unitPriceString,
      // widget.part.required.toString(),
      // widget.part.goingToBeUsed.toString(),
      // widget.part.remaining.toString(),
      // '\$ ${widget.part.cost.toStringAsFixed(2)}',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 10),
      color: widget.isOdd
          ? backgroundColor.add(Colors.amber, needed > 0 ? 0.25 : 0)
          : white.add(Colors.amber, needed > 0 ? 0.25 : 0),
      child: Row(
        children: List.generate(
          partValues.length,
          (index) => Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                border: index < partValues.length - 1
                    ? Border(right: BorderSide(color: gray))
                    : null,
              ),
              child: Center(
                child: AutoSizeText(
                  partValues[index].toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
