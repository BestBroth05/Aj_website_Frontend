import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/bom_view/bom_view.dart';

class BomComponentTile extends StatefulWidget {
  final String mpn;
  final Map<String, int> headerValues;
  final TextEditingController mpnController;
  final TextEditingController mpn1Controller;
  final TextEditingController mpn2Controller;
  BomComponentTile(
    this.mpn, {
    Key? key,
    required this.headerValues,
    required this.mpnController,
    required this.mpn1Controller,
    required this.mpn2Controller,
  }) : super(key: key);

  @override
  State<BomComponentTile> createState() => _BomComponentTileState();
}

class _BomComponentTileState extends State<BomComponentTile> {
  bool get isOdd =>
      BomView.components.keys.toList().indexOf(widget.mpn) % 2 != 0;

  Map<String, dynamic> get component => BomView.components[widget.mpn]!;
  Map<String, int> get headers => widget.headerValues;
  int get required => component['required'];

  int totalUsed = 0;

  @override
  void initState() {
    super.initState();
    // widget.mpnController.text =
    //     component['quantity'] != null ? required.toString() : '';
    totalUsed = (int.tryParse(widget.mpnController.text) ?? 0) +
        (int.tryParse(widget.mpn1Controller.text) ?? 0) +
        (int.tryParse(widget.mpn2Controller.text) ?? 0);
    BomView.components[widget.mpn]!['using'] =
        int.tryParse(widget.mpnController.text) ??
            BomView.components[widget.mpn]!['using'];
    BomView.components[widget.mpn]!['using1'] =
        int.tryParse(widget.mpn1Controller.text);
    BomView.components[widget.mpn]!['using2'] =
        int.tryParse(widget.mpn2Controller.text);
  }

  void updateState() => setState(() {
        totalUsed = (int.tryParse(widget.mpnController.text) ?? 0) +
            (int.tryParse(widget.mpn1Controller.text) ?? 0) +
            (int.tryParse(widget.mpn2Controller.text) ?? 0);
        BomView.components[widget.mpn]!['using'] =
            int.tryParse(widget.mpnController.text);
        BomView.components[widget.mpn]!['using1'] =
            int.tryParse(widget.mpn1Controller.text);
        BomView.components[widget.mpn]!['using2'] =
            int.tryParse(widget.mpn2Controller.text);
      });

  @override
  Widget build(BuildContext context) {
    Color tileColor = isOdd ? backgroundColor : white;
    String designator = '';
    for (MapEntry d in component['designators'].entries) {
      if (designator.isEmpty) {
        designator += '${d.key + 1}: ${d.value}';
      } else {
        designator += '\n${d.key + 1}: ${d.value}';
      }
    }
    return Container(
      height: 125,
      width: width,
      color: tileColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _TextTile(
            designator,
            flex: headers['designator']!,
            isLast: false,
          ),
          _TextTile(
            component['description'],
            flex: headers['description']!,
            isLast: false,
          ),
          _TextTile(
            component['manufacturer'],
            flex: headers['manufacturer']!,
            isLast: false,
          ),
          _EditableTile(
            component['mpn'],
            flex: headers['mpn']!,
            quantity: component['quantity'],
            controller: widget.mpnController,
            onUpdate: updateState,
          ),
          _EditableTile(
            component['alt1'],
            flex: headers['alternate 1']!,
            quantity: component['alt1_quantity'],
            controller: widget.mpn1Controller,
            onUpdate: updateState,
          ),
          _EditableTile(
            component['alt2'],
            flex: headers['alternate 2']!,
            quantity: component['alt2_quantity'],
            controller: widget.mpn2Controller,
            onUpdate: updateState,
          ),
          _TextTile(
            component['required'].toString(),
            flex: headers['required']!,
            isLast: false,
          ),
          _TextTile(
            totalUsed.toString(),
            toCompare: component['required'],
            flex: headers['total used']!,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TextTile extends StatelessWidget {
  final String? widgetText;
  final int? toCompare;
  final int flex;
  final bool isLast;
  const _TextTile(
    this.widgetText, {
    Key? key,
    this.toCompare,
    required this.flex,
    required this.isLast,
  }) : super(key: key);

  String get text => widgetText ?? 'N/A';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isLast
              ? (int.tryParse(widgetText!) ?? 0) == toCompare!
                  ? null
                  : Colors.orange[400]!.withOpacity(0.5)
              : null,
          border: Border(
            right: !isLast
                ? BorderSide(color: white.add(black, 0.2))
                : BorderSide.none,
          ),
        ),
        child: Center(
          child: AutoSizeText(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: text == 'N/A' ? darkGrey : black,
            ),
          ),
        ),
      ),
    );
  }
}

class _EditableTile extends StatefulWidget {
  final String? text;
  final int? quantity;
  final TextEditingController controller;
  final int flex;
  final VoidCallback onUpdate;
  final int minimum;

  _EditableTile(this.text,
      {Key? key,
      this.minimum = 0,
      required this.quantity,
      required this.controller,
      required this.flex,
      required this.onUpdate})
      : super(key: key);

  @override
  State<_EditableTile> createState() => __EditableTileState();
}

class __EditableTileState extends State<_EditableTile> {
  String get text => widget.text ?? 'N/A';
  String get quantity => widget.quantity == null ? 'N/A' : '${widget.quantity}';

  int remaining = 0;

  @override
  void initState() {
    super.initState();
    // Timer.run(() => updateState());
    remaining = widget.quantity ?? 0;
    if (widget.controller.text.isNotEmpty) {
      remaining -= int.parse(widget.controller.text);
    }
  }

  void updateState() => setState(() {
        remaining = widget.quantity ?? 0;
        if (widget.controller.text.isNotEmpty) {
          remaining -= int.parse(widget.controller.text);
        }
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: white.add(black, 0.2))),
          color: widget.quantity == null
              ? red.withOpacity(0.25)
              : remaining < 0
                  ? Colors.amber.withOpacity(0.25)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
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
            text != 'N/A'
                ? Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Center(child: AutoSizeText('Q: $quantity')),
                          ),
                          quantity != 'N/A'
                              ? Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AutoSizeText('Using:'),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: widget.controller,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onEditingComplete: () {
                                            widget.onUpdate.call();
                                            updateState();
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            hintText: '0',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                : Container(),
            text != 'N/A' && quantity != 'N/A'
                ? Expanded(
                    flex: 2,
                    child: Center(
                      child: AutoSizeText(remaining >= 0
                          ? 'Remaining: $remaining'
                          : 'Needed: ${remaining * -1}'),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
