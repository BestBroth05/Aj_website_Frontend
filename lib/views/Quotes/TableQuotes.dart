// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';

import '../../../utils/colors.dart';
import '../Delivery_Certificate/adminClases/CustomerClass.dart';
import 'TileQuotes.dart';

class TableQuotes extends StatefulWidget {
  CustomersClass customer;
  bool isOC;
  List<QuoteClass> quotes;
  TableQuotes(
      {super.key,
      required this.quotes,
      required this.customer,
      required this.isOC});

  @override
  State<TableQuotes> createState() => _TableQuotesState();
}

class _TableQuotesState extends State<TableQuotes> {
  Map<String, int> headers = {'Quote': 2, 'Type': 2, 'Date': 2, 'actions': 2};
  @override
  Widget build(BuildContext context) {
    return widget.quotes.isEmpty
        ? Center(child: Text("No Data"))
        : Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: teal.add(black, 0.3),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                ),
                child: Row(
                  children: headers.entries
                      .map(
                        (e) => Expanded(
                          flex: e.value,
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                left: e.key != 'id'
                                    ? BorderSide(
                                        color: white,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: AutoSizeText(
                              e.key.split('_').join(' ').toTitle(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: white),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                  child: ListView.separated(
                    itemCount: widget.quotes.length,
                    itemBuilder: (context, i) => TileQuotes(
                      customer: widget.customer,
                      quote: widget.quotes[i],
                      attributesFlex: headers,
                      isOdd: i % 2 != 0,
                      isOC: widget.isOC,
                    ),
                    separatorBuilder: (context, index) => Container(height: 2),
                  ),
                ),
              )
            ],
          );
  }
}
