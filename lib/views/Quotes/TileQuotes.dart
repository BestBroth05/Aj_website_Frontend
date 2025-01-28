// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/productClass.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';
import 'package:guadalajarav2/views/Quotes/DesplegableQuotes.dart';
import '../../../utils/colors.dart';
import '../Delivery_Certificate/widgets/Popups.dart';
import '../Delivery_Certificate/widgets/Texts.dart';
import 'Assemblies/EditAssembly.dart';
import 'Assemblies/Preview_Assemblies.dart';
import 'Clases/QuoteTableClass.dart';
import 'Manofacture/Manofacture.dart';
import 'Manofacture/PreviewManofacture.dart';

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
  List<ProductCertificateDelivery> productsQuotes = [];
  bool isServiceSavedQuote = false;
  @override
  void initState() {
    getPreview();
    List splitDate = widget.quote.date!.split(" ");
    fecha = splitDate[0];
    super.initState();
  }

  getPreview() async {
    List<QuoteTableClass> preview1 =
        await DataAccessObject.selectPreviewByQuote(widget.quote.id_Quote);
    setState(() {
      if (preview1.isNotEmpty) {
        isServiceSavedQuote = true;
      }
    });
  }

  getProductsPerQuote() async {
    List<ProductCertificateDelivery> productsQuotes1 =
        await DataAccessObject.getProductosOC();

    for (var i = 0; i < productsQuotes1.length; i++) {
      if (productsQuotes1[i].id_quote == widget.quote.id_Quote) {
        productsQuotes.add(productsQuotes1[i]);
      }
    }
  }

  postQuote() async {
    try {
      int code = await DataAccessObject.postQuote(
          widget.quote.id_Customer,
          widget.quote.id_Percentages,
          widget.quote.iva,
          widget.quote.isr,
          widget.quote.quoteType,
          widget.quote.date,
          widget.quote.customerName,
          "${widget.quote.quoteNumber}*",
          widget.quote.proyectName,
          widget.quote.requestedByName,
          widget.quote.requestedByEmail,
          widget.quote.attentionTo,
          widget.quote.quantity,
          widget.quote.dollarSell,
          widget.quote.dollarBuy,
          widget.quote.deliverTimeInfo,
          widget.quote.currency,
          widget.quote.conIva,
          widget.quote.excelName,
          widget.quote.componentsMPN,
          widget.quote.componentsAvailables,
          widget.quote.componentsDeliverTime,
          widget.quote.componentsAJPercentage,
          widget.quote.digikeysAJPercentage,
          widget.quote.dhlCostComponent,
          widget.quote.componentsMouserCost,
          widget.quote.componentsIVA,
          widget.quote.componentsAJ,
          widget.quote.totalComponentsUSD,
          widget.quote.totalComponentsMXN,
          widget.quote.perComponentMXN,
          widget.quote.PCBName,
          widget.quote.PCBLayers,
          widget.quote.PCBSize,
          widget.quote.PCBImage,
          widget.quote.PCBColor,
          widget.quote.PCBDeliveryTime,
          widget.quote.PCBdhlCost,
          widget.quote.PCBAJPercentage,
          widget.quote.PCBReleasePercentage,
          widget.quote.PCBPurchase,
          widget.quote.PCBShipment,
          widget.quote.PCBTax,
          widget.quote.PCBRelease,
          widget.quote.PCBAJ,
          widget.quote.PCBTotalUSD,
          widget.quote.PCBTotalMXN,
          widget.quote.PCBPerMXN,
          widget.quote.assemblyLayers,
          widget.quote.assemblyMPN,
          widget.quote.assemblySMT,
          widget.quote.assemblyTH,
          widget.quote.assemblyDeliveryTime,
          widget.quote.assemblyAJPercentage,
          widget.quote.assembly,
          widget.quote.assemblyTax,
          widget.quote.assemblyAJ,
          widget.quote.assemblyDhlCost,
          widget.quote.assemblyTotalMXN,
          widget.quote.perAssemblyMXN);
      print("Error numero: $code");
      if (code == 200) {
        GoodPopup(context, "Quote duplicate succesfully!");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => DesplegableQuotes(
                        customer: widget.customer,
                      )),
              (route) => false);
        });
      } else {
        wrongPopup(context, "Error to copy quote");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      wrongPopup(context, e);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
    }
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
                              widget.quote.quoteType == 1
                                  ? "Assembly"
                                  : widget.quote.quoteType == 2
                                      ? "Proyect"
                                      : "Services/Material",
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
                                        tooltip: "Copy",
                                        onPressed: () async =>
                                            await confirmationToCopy(),
                                        icon: Icon(
                                          Icons.copy,
                                        )),
                                    IconButton(
                                        tooltip: "Edit",
                                        onPressed: () {
                                          if (widget.quote.quoteType == 1) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditAssembly(
                                                          quote: widget.quote,
                                                          customer:
                                                              widget.customer,
                                                        )));
                                          } else if (widget.quote.quoteType ==
                                              2) {
                                            //No data yet
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Manofacture(
                                                          isEdit: true,
                                                          quote: widget.quote,
                                                          customer:
                                                              widget.customer,
                                                        )));
                                          }
                                        },
                                        icon: Icon(Icons.edit)),
                                    IconButton(
                                        tooltip: "Download",
                                        onPressed: () async {
                                          if (widget.quote.quoteType == 1) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Preview_Assemblies(
                                                            isSavedQuote: true,
                                                            quote: widget.quote,
                                                            customer: widget
                                                                .customer)));
                                          } else if (widget.quote.quoteType ==
                                              2) {
                                            //No data yet
                                          } else {
                                            await getProductsPerQuote();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PreviewManofacture(
                                                          isSavedQuote:
                                                              isServiceSavedQuote,
                                                          customer:
                                                              widget.customer,
                                                          quote: widget.quote,
                                                          products:
                                                              productsQuotes,
                                                        )));
                                          }
                                        },
                                        icon: Icon(Icons.download)),
                                    IconButton(
                                        tooltip: "Delete",
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

  confirmationToCopy() async {
    //DeviceAV device;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Theme(
              data: ThemeData(primaryColor: Colors.white24),
              child: CupertinoAlertDialog(
                title: Text(
                  'Do you want to copy the quote?',
                  style: titlePopUp,
                ),
                content: Text(
                  "This quote will be duplicated",
                  style: contentPopUp,
                ),
                actions: [
                  TextButton(
                    child: Text('Accept', style: buttonsPopUp),
                    onPressed: () async => await postQuote(),
                  ),
                  TextButton(
                    child: Text('Cancel', style: buttonsCancelPopUp),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
        });
  }
}
