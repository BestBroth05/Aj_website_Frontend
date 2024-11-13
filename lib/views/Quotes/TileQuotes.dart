// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';
import 'package:guadalajarav2/views/Quotes/DesplegableQuotes.dart';
import '../../../utils/colors.dart';
import '../Delivery_Certificate/widgets/Popups.dart';
import 'Assemblies/EditAssembly.dart';
import 'Assemblies/Preview_Assemblies.dart';

class TileQuotes extends StatefulWidget {
  CustomersClass customer;
  QuoteClass quote;
  final Map<String, int> attributesFlex;
  final bool isOdd;
  final bool isOC;
  TileQuotes(
      {Key? key,
      this.isOdd = true,
      required this.quote,
      required this.customer,
      required this.attributesFlex,
      required this.isOC})
      : super(key: key);

  @override
  State<TileQuotes> createState() => _TileQuotesState();
}

class _TileQuotesState extends State<TileQuotes> {
  Color get color => widget.isOdd ? backgroundColor : white;
  String? fecha;
  @override
  void initState() {
    List splitDate = widget.quote.date!.split(" ");
    fecha = splitDate[0];
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
                  child: key == 'Quote'
                      ? AutoSizeText(
                          widget.quote.quoteNumber.toString(),
                          textAlign: TextAlign.center,
                        )
                      : key == 'Type'
                          ? AutoSizeText(
                              "Assembly", //Cambiar
                              textAlign: TextAlign.center,
                            )
                          : key == 'Date'
                              ? AutoSizeText(
                                  fecha!,
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
                                                      EditAssembly(
                                                        quote: widget.quote,
                                                        customer:
                                                            widget.customer,
                                                      )));
                                        },
                                        icon: Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Preview_Assemblies(
                                                          isSavedQuote: true,
                                                          quote: widget.quote,
                                                          customer: widget
                                                              .customer)));
                                        },
                                        icon: Icon(Icons.download)),
                                    IconButton(
                                        onPressed: () {
                                          confirmationDeleteCustomer(
                                              context,
                                              widget.quote.id_Quote,
                                              "quote",
                                              DesplegableQuotes(
                                                  customer: widget.customer));
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                )),
            );
          },
        ).toList(),
      ),
    );
  }
}
