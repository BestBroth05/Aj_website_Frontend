import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_header.dart';

class AJCartHeaders extends StatefulWidget {
  final Map<String, int> headers;
  final ScrollController scrollController;
  AJCartHeaders(
    this.headers, {
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<AJCartHeaders> createState() => _AJCartHeadersState();
}

class _AJCartHeadersState extends State<AJCartHeaders> {
  double _width = 0;
  @override
  Widget build(BuildContext context) {
    // double sum = 0;
    // for (int i in headers.values.toList().sublist(1, 14)) {
    //   sum += 50.0 * (i + 1);
    // }
    // print(sum);

    double totalCost = 0;
    // AJCartView.parts.values.toList().forEach((element) {
    //   totalCost += element['total_cost']!;
    // });

    _width = 0;

    widget.headers.forEach((key, value) => _width += 70 * (value + 1));
    _width -= 140;

    return SizedBox(
      height: 80,
      width: width,
      child: Row(
        children: (_width >= width)
            ? [
                Expanded(
                  child: ListView.builder(
                    controller: widget.scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => AJCartHeader(
                      widget.headers.keys.elementAt(index),
                      flex: widget.headers.values.elementAt(index),
                    ),
                    itemCount: widget.headers.length - 1,
                  ),
                ),
                AJCartHeader(
                  widget.headers.keys.last +
                      '\n\$${totalCost.toStringAsFixed(2)}',
                  flex: widget.headers.values.last,
                  leftBorder: true,
                  rightBorder: false,
                ),
              ]
            : widget.headers.entries
                .map(
                  (e) => Expanded(
                    flex: e.value + 1,
                    child: AJCartHeader(
                      e.key,
                      flex: e.value,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
