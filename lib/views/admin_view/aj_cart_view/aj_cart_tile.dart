import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_view.dart';

class AJCartTile extends StatefulWidget {
  final bool isOdd;
  final Map<String, dynamic> part;
  final Function(double totalCost) onUpdate;

  final Map<String, int> headers;
  AJCartTile(
    this.part, {
    Key? key,
    this.isOdd = false,
    required this.onUpdate,
    required this.headers,
  }) : super(key: key);

  @override
  State<AJCartTile> createState() => _AJCartTileState();
}

class _AJCartTileState extends State<AJCartTile> {
  Map<String, dynamic> get component => widget.part;
  Map<String, int> get headers => widget.headers;

  @override
  void initState() {
    super.initState();
    // totalUsed = int.tryParse(component['controller'].text) ?? 0;
    // totalCost = 0;
    // for (int i = 1; i < 3; i++) {
    //   totalUsed += int.tryParse(component['alt$i']['controller'].text) ?? 0;
    // }
    // for (String alt in ['digikey', 'mouser']) {
    //   for (int i = 1; i < 3; i++) {
    //     if (i > 0) {
    //       alt += '_$i';
    //     }
    //     if (component[alt] == null) {
    //       continue;
    //     }
    //     totalUsed += int.tryParse(component[alt]['controller'].text) ?? 0;
    //     component[alt]['total_cost'] =
    //         (double.tryParse(component[alt]['unitPrice'].text) ?? 0) *
    //             totalUsed;
    //   }
    // }
  }

  int totalUsed = 0;
  double totalCostDigikey = 0;
  double totalCostMouser = 0;
  @override
  Widget build(BuildContext context) {
    totalCostDigikey = 0;
    totalCostMouser = 0;
    String designator = '';
    for (MapEntry d in component['designators'].entries) {
      if (designator.isEmpty) {
        designator += '${d.key + 1}: ${d.value}';
      } else {
        designator += '\n${d.key + 1}: ${d.value}';
      }
    }
    return Container(
      height: 100,
      color: widget.isOdd ? white : backgroundColor,
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
          // _TextTile(
          //   component['mpn'],
          //   flex: headers['mpn']!,
          //   isLast: false,
          // ),
          _EditableTile(
            component['mpn'],
            flex: headers['mpn']!,
            quantity: component['quantity'],
            controller: component['controller'],
            onUpdate: updateState,
          ),

          // Expanded(
          //   flex: 6,
          //   child: Row(
          //     children: List.generate(
          //       2,
          //       (index) {
          //         index += 1;
          //         String key = 'alt$index';
          //         return component[key] != null
          //             ? _EditableTile(
          //                 component[key]['mpn'],
          //                 flex: headers[key]!,
          //                 quantity: int.tryParse(
          //                   component[key]['quantity'].toString().split(' ')[0],
          //                 ),
          //                 controller: component[key]['controller'],
          //                 onUpdate: updateState,
          //               )
          //             : _TextTile(
          //                 component[key],
          //                 flex: headers[key]!,
          //                 isLast: false,
          //               );
          //       },
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 3,
            child: Row(
              children: List.generate(
                1,
                (index) {
                  String key = 'digikey';
                  if (index > 0) {
                    key += '_$index';
                  }
                  if (component[key] != null) {
                    totalCostDigikey +=
                        component[key]['UnitPrice'] * component['required'] ??
                            0;
                  } else {
                    totalCostDigikey += 0;
                  }

                  return component[key] != null
                      ? _EditableTile(
                          component[key]['ManufacturerPartNumber'],
                          flex: headers[key]!,
                          quantity: component[key]['QuantityAvailable'],
                          controller: component[key]['controller'],
                          cost: component[key]['UnitPrice'],
                          onUpdate: updateState,
                        )
                      : _TextTile(
                          component[key],
                          flex: headers[key]!,
                          isLast: false,
                        );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: List.generate(
                1,
                (index) {
                  String key = 'mouser';
                  if (index > 0) {
                    key += '_$index';
                  }

                  if (component[key] != null &&
                      component[key]['PriceBreaks'] != null &&
                      component[key]['PriceBreaks'].length > 0) {
                    if (component[key]['PriceBreaks'][0]['Quantity'] == 1) {
                      totalCostMouser += component['required'] *
                              double.tryParse(component[key]['PriceBreaks'][0]
                                      ['Price']
                                  .toString()
                                  .substring(1)) ??
                          0;
                    }
                  } else {}

                  return component[key] != null
                      ? _EditableTile(
                          component[key]['ManufacturerPartNumber'],
                          flex: headers[key]!,
                          quantity: int.tryParse(
                            component[key]['Availability']
                                .toString()
                                .split(' ')[0],
                          ),
                          cost: component[key]['PriceBreaks'] != null &&
                                  component[key]['PriceBreaks'].length > 0
                              ? component[key]['PriceBreaks'][0]['Quantity'] ==
                                      1
                                  ? double.tryParse(component[key]
                                          ['PriceBreaks'][0]['Price']
                                      .toString()
                                      .substring(1))
                                  : null
                              : null,
                          controller: component[key]['controller'],
                          onUpdate: updateState,
                        )
                      : _TextTile(
                          component[key],
                          flex: headers[key]!,
                          isLast: false,
                        );
                },
              ),
            ),
          ),
          _TextTile(
            component['required'].toString(),
            flex: headers['required']!,
            isLast: false,
          ),
          _TextTile(
            totalUsed.toString(),
            flex: headers['using']!,
            isLast: false,
          ),
          _TextTile(
            totalCostDigikey.toString(),
            flex: headers['total_cost_digikey']!,
            isLast: false,
          ),
          _TextTile(
            totalCostMouser.toString(),
            flex: headers['total_cost_mouser']!,
            isLast: false,
          ),
        ],
      ),
    );
  }

  void updateState() => setState(() {
        totalUsed = int.tryParse(component['controller'].text) ?? 0;
        // totalCost = 0;
        for (int i = 1; i < 3; i++) {
          totalUsed += int.tryParse(component['alt$i']['controller'].text) ?? 0;
        }
        for (String alt in ['digikey', 'mouser']) {
          for (int i = 1; i < 3; i++) {
            if (i > 0) {
              alt += '_$i';
            }
            if (component[alt] == null) {
              continue;
            }
            totalUsed += int.tryParse(component[alt]['controller'].text) ?? 0;
            component[alt]['total_cost'] =
                (double.tryParse(component[alt]['unitPrice'].text) ?? 0) *
                    totalUsed;
          }
        }
        // widget.onUpdate.call(totalUsed);
      });
}

class _TextTile extends StatelessWidget {
  final String? widgetText;
  final int flex;
  final bool isLast;
  const _TextTile(
    this.widgetText, {
    Key? key,
    required this.flex,
    required this.isLast,
  }) : super(key: key);

  String get text => widgetText ?? 'N/A';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex + 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: text == 'N/A' ? red.withOpacity(0.25) : null,
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
              color: text == 'N/A' ? gray.add(black, 0.5) : black,
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
  final double? cost;

  _EditableTile(
    this.text, {
    Key? key,
    this.minimum = 0,
    this.cost,
    required this.quantity,
    required this.controller,
    required this.flex,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<_EditableTile> createState() => _EditableTileState();
}

class _EditableTileState extends State<_EditableTile> {
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
      flex: widget.flex + 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      child: AutoSizeText(
                        widget.cost != null
                            ? 'Unit Price: \$${widget.cost} Total: \$${widget.cost! * (int.tryParse(widget.controller.text) ?? 0)}'
                            : remaining >= 0
                                ? 'Remaining: $remaining'
                                : 'Needed: ${remaining * -1}',
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
