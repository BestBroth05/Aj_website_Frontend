// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import '../../../utils/colors.dart';
import '../../../views/admin_view/Tools.dart';
import '../../../views/Delivery_Certificate/widgets/customCircleAvatar.dart';
import 'DesplegableQuotes.dart';
import 'PorcentajeForm.dart';

class TileCustomerQuote extends StatefulWidget {
  CustomersClass customers;
  final Map<String, int> attributesFlex;
  final bool isOdd;
  final bool isOC;
  TileCustomerQuote(this.customers,
      {Key? key,
      this.isOdd = true,
      required this.attributesFlex,
      required this.isOC})
      : super(key: key);

  @override
  State<TileCustomerQuote> createState() => _TileCustomerQuoteState();
}

class _TileCustomerQuoteState extends State<TileCustomerQuote> {
  Color get color => widget.isOdd ? backgroundColor : white;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: color,
      child: Row(
        children: widget.attributesFlex.entries.map(
          (e) {
            String key = e.key;
            int flex = e.value;

            return Expanded(
              flex: flex,
              child: Container(
                  height: 75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                      color: gray,
                    )),
                  ),
                  child: key == 'logo'
                      ? CustomCicleAvatar(
                          convertListToInt(widget.customers.logo!))
                      : key == 'name'
                          ? AutoSizeText(
                              widget.customers.name.toString(),
                              textAlign: TextAlign.center,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PorcentajesForm(
                                                      customer:
                                                          widget.customers)));
                                    },
                                    icon: Icon(Icons.percent)),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DesplegableQuotes(
                                                      customer:
                                                          widget.customers)));
                                    },
                                    icon: Icon(Icons.view_headline))
                              ],
                            )),
            );
          },
        ).toList(),
      ),
    );
  }
}
