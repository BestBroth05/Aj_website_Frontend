import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/classes/bom_part.dart';
import 'package:guadalajarav2/classes/mpn.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';

class BomPartTile extends StatefulWidget {
  final BomPart part;
  final Color color;
  final List<int> sizes;
  final Function(String value) onChagedUsed;
  final TextEditingController controller;

  final Function(int selected) onSelected;
  BomPartTile(
    this.part, {
    Key? key,
    required this.controller,
    required this.onChagedUsed,
    required this.onSelected,
    required this.sizes,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  State<BomPartTile> createState() => _BomPartTileState();
}

class _BomPartTileState extends State<BomPartTile> {
  int get selectedIndex => widget.part.selected + 5;
  bool get isAvailable => widget.part.mpn.quantity > 0;
  bool get tooLow => widget.part.mpn.quantity < widget.part.required;

  Color get tilecolor => isAvailable
      ? tooLow
          ? darkAmber.withOpacity(0.2)
          : widget.color
      : red.withOpacity(0.3);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: width,
      color: tilecolor,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: List.generate(
          widget.part.tableValues.length,
          (index) {
            dynamic t = widget.part.tableValues[index];

            String text = t.toString();
            if (t == null) {
              text = 'N/A';
            }

            bool clickable = false;
            if (index >= 5 && index < 8) {
              Mpn? mpn = widget.part.allMPN[index - 5];
              if (mpn != null) {
                if (mpn.quantityString != 'N/A' &&
                    mpn.quantity > 0 &&
                    mpn.unitPriceString != 'N/A') {
                  clickable = true;
                }
              }
            }

            Color? color = selectedIndex == index && clickable
                ? green.add(black, 0.2).withOpacity(0.4)
                : null;

            return Expanded(
              flex: widget.sizes[index],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(
                    right: index != widget.sizes.length - 1
                        ? BorderSide(color: white.add(black, 0.2))
                        : BorderSide.none,
                  ),
                ),
                child: index == widget.part.tableValues.length - 3
                    ? TextField(
                        controller: widget.controller,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(border: InputBorder.none),
                        onSubmitted: widget.onChagedUsed,
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          disabledMouseCursor: SystemMouseCursors.basic,
                          enabledMouseCursor: SystemMouseCursors.click,
                        ),
                        onPressed: !clickable
                            ? null
                            : () {
                                if (index == selectedIndex) {
                                  widget.onSelected.call(-1);
                                } else {
                                  widget.onSelected.call(index - 5);
                                }
                              },
                        // : () => print('object'),
                        child: Container(
                          color: color,
                          child: Center(
                            child: SelectableText(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: text == 'N/A' ? darkGrey : black,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
