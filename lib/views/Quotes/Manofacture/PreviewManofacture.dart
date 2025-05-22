// ignore_for_file: must_be_immutable
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/SuperGlobalVariables/ObjVar.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/productClass.dart';
import 'package:guadalajarav2/views/Quotes/Assemblies/TextDialogWidget.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';
import 'package:guadalajarav2/views/Quotes/Text_Quotes.dart';
import '../../../enums/route.dart';
import '../../../utils/colors.dart';
import '../../../utils/tools.dart';
import '../../../Popups.dart';
import '../../../utils/url_handlers.dart';
import '../../Delivery_Certificate/widgets/Texts.dart';
import '../../admin_view/Tools.dart';
import '../../admin_view/admin_DeliverCertificate/LoadingData.dart';
import '../Clases/QuoteTableClass.dart';
import '../DesplegableQuotes.dart';

class PreviewManofacture extends StatefulWidget {
  bool? isSavedQuote;
  QuoteClass? quote;
  CustomersClass? customer;
  List<ProductCertificateDelivery>? products;
  PreviewManofacture(
      {super.key,
      required this.quote,
      required this.products,
      required this.customer,
      required this.isSavedQuote});

  @override
  State<PreviewManofacture> createState() => _PreviewManofactureState();
}

class _PreviewManofactureState extends State<PreviewManofacture> {
  String? date;
  String currency = "MXN";
  String? conIva;
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  List<QuoteTableClass> rows = [];
  double total = 0.0;
  List<String> columns = [];
  bool onErrore = false;
  bool addComponents = true;
  bool addPCB = true;
  String? colorNameSpanish;
  List<QuoteTableClass> preview = [];
  bool isUpdate = false;
  TextEditingController notes = TextEditingController();
  List<QuoteTableClass> startRows = [];
  List<QuoteTableClass> deleteList = [];
  int startValues = 0;
  int timesToSavePreview = 0;
  bool isLoading = true;
  AJRoute route = AJRoute.adminQuotes;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    date =
        DateFormat('MMMM d, yyyy').format(DateTime.parse(widget.quote!.date!));
    await getPreview(0);
    setState(() {
      isLoading = false;
    });
  }

  getIdQuote() async {
    List<QuoteClass> quotesId = await DataAccessObject.getQuotes();
    setState(() {
      widget.quote!.id_Quote = quotesId[quotesId.length - 1].id_Quote;
    });
  }

  fillColumns() async {
    notes.text =
        "-Los costos son calculados de acuerdo con el volumen solicitado, en caso de necesitar diferente volumen favor de solicitar cotización\n-Componentes sujetos a disponibilidad y precio de mercado\n-Para poder manufacturar su pedido es necesario que genere una orden de compra firmada por el responsable de su empresa\n-Vigencia de cotización: 8 dìas hábiles\n-El cliente se hace responsable de los archivos entregados para la fabricación de su producto, en dado caso de tener algún error se debe hacer cargo de los gastos generados al 100%\n-Una vez iniciada el proceso de compra/fabricación, no se aceptan cambios en el diseño a menos de que se paguen los cambios a realizar.";
    for (var i = 0; i < widget.products!.length; i++) {
      rows.add(QuoteTableClass(
        description: widget.products![i].descripcion,
        cantidad: widget.products![i].cantidad.toString(),
        unitario: widget.products![i].precioUnitario.toString(),
        image: widget.products![i].image,
        total: widget.products![i].importe.toString(),
      ));
    }
    rows.add(QuoteTableClass(
        description: "Envío GDL – \nPAQUETE ASEGURADO",
        unitario: "0.0",
        cantidad: "1",
        image: "",
        total: "0.0"));
    setState(() {
      startValues = rows.length;
      startRows = rows;
    });
    if (widget.quote!.id_Quote == null) {
      await getIdQuote();
    }
  }

  postPreview(List<QuoteTableClass> postList) async {
    try {
      int code = 0;
      for (var i = 0; i < postList.length; i++) {
        code = await DataAccessObject.postPreview(
          widget.quote!.id_Quote,
          postList[i].description,
          postList[i].unitario,
          postList[i].cantidad,
          postList[i].total,
          notes.text,
          postList[i].image,
        );
      }
      print("Code: $code");
      if (code == 200) {
        GoodPopup(context, "Saved");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      } else {
        wrongPopup(context, "Error to send quote preview");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print("error $e");
      PopupError(context);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return 1005;
    }
  }

  getPreview(times) async {
    List<QuoteTableClass> preview1 =
        await DataAccessObject.selectPreviewByQuote(widget.quote!.id_Quote);
    setState(() {
      preview = preview1;
      if (times > 1) {
        //Nothing to do
      } else {
        startValues = preview1.length;
        if (preview1.isNotEmpty) {
          notes.text = preview1[0].notas!;
          rows = preview1;
          startRows = preview1;
          isUpdate = true;
        } else {
          fillColumns();
        }
      }
    });
  }

  updatePreview(List<QuoteTableClass> updateList) async {
    try {
      int code = 0;
      for (var i = 0; i < updateList.length; i++) {
        code = await DataAccessObject.updatePreview(
            preview[i].id_quotePreview,
            widget.quote!.id_Quote,
            updateList[i].description,
            updateList[i].unitario,
            updateList[i].cantidad,
            updateList[i].total,
            notes.text,
            updateList[i].image);
      }
      print("Code: $code");
      if (code == 200) {
        GoodPopup(context, "Saved");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      } else {
        wrongPopup(context, "Error to send quote preview");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print("error $e");
      PopupError(context);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return 1005;
    }
  }

  addAndUpdate(
      List<QuoteTableClass> updateList, List<QuoteTableClass> addList) async {
    try {
      int code = 0;
      for (var i = 0; i < updateList.length; i++) {
        code = await DataAccessObject.updatePreview(
            preview[i].id_quotePreview,
            widget.quote!.id_Quote,
            updateList[i].description,
            updateList[i].unitario,
            updateList[i].cantidad,
            updateList[i].total,
            notes.text,
            updateList[i].image);
      }
      print("Code: $code");
      if (code == 200) {
        await postPreview(addList);
      } else {
        wrongPopup(context, "Error to send quote preview");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print("error $e");
      PopupError(context);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return 1005;
    }
  }

  deleteRow(
      List<QuoteTableClass> deleteList, List<QuoteTableClass> sendList) async {
    try {
      int code = 0;
      for (var i = 0; i < deleteList.length; i++) {
        code = await DataAccessObject.deletePreview(
          deleteList[i].id_quotePreview,
        );
      }

      print("Code: $code");
      if (code == 200) {
        GoodPopup(context, "Saved");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      } else {
        wrongPopup(context, "Error to delete quote preview");
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print("error $e");
      PopupError(context);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return 1005;
    }
  }

  choseOptionToExecute() async {
    timesToSavePreview += 1;
    if (timesToSavePreview > 1) {
      isUpdate = true;
      await getPreview(timesToSavePreview);
    } else {
      //Nothing to do
    }
    //if (widget.isSavedQuote!) {
    List<QuoteTableClass> sendList = [];
    List<QuoteTableClass> sendList2 = [];
    if (isUpdate) {
      //Update all
      if (startRows.length == startValues) {
        sendList = startRows;
        print("Entre a update");
        await updatePreview(sendList);
      }
      //Add Row and update
      else if (startRows.length > startValues) {
        print("Entre a update y add");
        for (var i = 0; i < startValues; i++) {
          sendList.add(startRows[i]);
        }
        for (var i = startValues; i < startRows.length; i++) {
          sendList2.add(startRows[i]);
        }
        await addAndUpdate(sendList, sendList2);
      }
      //Delete row
      else if (startRows.length < startValues) {
        print("Entre a delete");
        await deleteRow(deleteList, startRows);
      }
    } else {
      print("Entre a post");
      sendList = rows;
      await postPreview(sendList);
    }
    // } else {
    //   wrongPopup(context, "Save the quote first");
    //   Future.delayed(Duration(seconds: 3), () {
    //     Navigator.of(context).pop();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => openLink(context, route.url, isRoute: true),
              icon: Icon(Icons.home),
              iconSize: 30,
              tooltip: "Home",
            ),
            SizedBox(width: 25),
          ],
          backgroundColor: teal.add(black, 0.3),
          foregroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DesplegableQuotes(customer: widget.customer!)));
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            "Preview",
            style: titleh1,
          ),
          centerTitle: true,
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  //for (var i = 0; i < rows.length; i++) {
                  deleteList.add(rows[rows.length - 1]);
                  //}
                  startRows.removeAt(startRows.length - 1);
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: teal,
              ),
              child: Text("Delete Row")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  startRows.add(QuoteTableClass(
                      description: "",
                      unitario: "0.0",
                      cantidad: "0.0",
                      image: "",
                      total: "0.0"));
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: teal,
              ),
              child: Text("Add Row"))
        ],
        body: isLoading
            ? LoadingData()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    header(),
                    table(),
                    editNotes(),
                    ButtonExport(),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ));
  }

  Widget header() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          //Image
          Container(
            child: Image.asset("assets/images/HeaderAJ.png"),
          ),
          //date
          Container(
            margin: EdgeInsets.only(right: 300),
            alignment: Alignment.topRight,
            child: Text(
              "$date, Zapopan Jalisco.",
              style: dateText,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0, top: 25),
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "Nombre Proyecto: ", style: title2),
                  TextSpan(
                      text: "${widget.quote!.proyectName!}.", style: dateText)
                ])),
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Image.memory(
                          convertListToInt(widget.customer!.logo!),
                          height: 100,
                          width: 150,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(children: [
                            TextSpan(text: "Cotización: ", style: title3),
                            TextSpan(
                                text: "${widget.quote!.quoteNumber!}\n",
                                style: infoText),
                            TextSpan(text: "Empresa: ", style: title3),
                            TextSpan(
                                text: "${widget.customer!.name!}\n",
                                style: infoText),
                            TextSpan(text: "Atención a: ", style: title3),
                            TextSpan(
                                text: "${widget.quote!.attentionTo!}\n",
                                style: infoText),
                            TextSpan(text: "Solicitud por: ", style: title3),
                            TextSpan(
                                text:
                                    "${widget.quote!.requestedByName!}\n${widget.quote!.requestedByEmail!}\n",
                                style: infoText),
                            TextSpan(text: "Termino de pago: ", style: title3),
                            TextSpan(
                                text:
                                    "${widget.quote!.deliverTimeInfo!.replaceAll("days", "dias")}\n",
                                style: infoText),
                          ])),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget ButtonExport() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                maximumSize: Size(175, 100),
                foregroundColor: Colors.white,
                backgroundColor: Colors.red),
            onPressed: () {
              PDFLanguageQuotes(
                  context,
                  addPCB,
                  addComponents,
                  startRows,
                  widget.quote,
                  widget.customer,
                  true,
                  notes.text,
                  "manofacture");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Export to PDF "),
                Icon(Icons.file_download, color: Colors.white, size: 20)
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                maximumSize: Size(175, 100),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue),
            onPressed: () {
              PDFLanguageQuotes(
                  context,
                  addPCB,
                  addComponents,
                  startRows,
                  widget.quote,
                  widget.customer,
                  false,
                  notes.text,
                  "manofacture");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Export to Word "),
                Icon(Icons.file_download, color: Colors.white, size: 20)
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                maximumSize: Size(175, 100),
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal),
            onPressed: () => choseOptionToExecute(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Save Preview"),
                Icon(Icons.save, color: Colors.white, size: 20)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget table() {
    if (widget.quote!.currency == "MXN") {
      currency = "MXN";
      columns = [
        'Descripción',
        'Cantidad',
        'Costo\nunitario',
        'Imagen',
        'Total\nMXN'
      ];
    } else {
      currency = "USD";
      columns = [
        'Descripción',
        'Cantidad',
        'Costo\nunitario',
        'Imagen',
        'Total\nUSD'
      ];
    }
    if (widget.quote!.conIva!) {
      conIva = "* Con IVA";
    } else {
      conIva = "* Sin IVA";
    }
    setState(() {
      // for (var i = 0; i < rows.length; i++) {
      //   rows
      // }
      List<QuoteTableClass> newQuote = startRows;
      total = 0.0;
      double unitario = 0.0;
      int cantidad = 0;
      double perTotal = 0.0;

      //Operations Per Total
      for (var i = 0; i < newQuote.length; i++) {
        if (newQuote[i].unitario!.isNotEmpty &&
            newQuote[i].unitario!.isNotEmpty) {
          unitario = double.parse(newQuote[i].unitario!.replaceAll(",", ""));
          cantidad =
              double.parse(newQuote[i].cantidad!.replaceAll(",", "")).toInt();
          perTotal = unitario * cantidad;
          newQuote[i].total = formatter.format(perTotal);
          newQuote[i].unitario = formatter.format(unitario);
        }
      }

      //Operations Total
      for (var i = 0; i < newQuote.length; i++) {
        if (newQuote[i].total!.isNotEmpty) {
          total += double.parse(newQuote[i].total!.replaceAll(",", ""));
        }
      }
    });
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "Cotización",
              style: title1,
            ),
          ),
          SizedBox(
            width: (currentUser.width! - 500),
            child: DataTable(
                border: TableBorder.all(
                  width: 1.0,
                ),
                dataRowMaxHeight: double.infinity, //Ajuste automatico
                columns: getColumns(columns),
                rows: getRows(startRows)),
          ),
          Container(
            width: (currentUser.width! - 500),
            child: Row(
              children: [
                Container(
                  width: (currentUser.width! - 724),
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle, border: Border.all(width: 1)),
                  child: Text(
                    "Total\n$currency $conIva",
                    textAlign: TextAlign.end,
                  ),
                ),
                Container(
                  width: 224,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle, border: Border.all(width: 1)),
                  child: Text(
                    "\n\$${formatter.format(total)}",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(label: Text(column));
    }).toList();
  }

  List<DataRow> getRows(List<QuoteTableClass> quotes) => quotes.map((quote) {
        final cells = [
          quote.description,
          quote.cantidad,
          quote.unitario,
          quote.image,
          quote.total
        ];

        return DataRow(
            cells: Utils.modelBuilder(cells, (index, cell) {
          return DataCell(
            index == 3
                ? cell!.isNotEmpty
                    ? Center(
                        child: Image.memory(
                          base64.decode(cell),
                          height: 100,
                          width: 150,
                        ),
                      )
                    : Text("")
                : index == 0
                    ? Container(child: Text("$cell"), width: 350)
                    : index == 1
                        ? Text("$cell")
                        : Text("\$$cell"),
            //showEditIcon: true,
            onTap: () {
              switch (index) {
                case 0:
                  editDescription(quote);
                  break;
                case 1:
                  editCantidad(quote);
                  break;
                case 2:
                  editUnitario(quote);
                  break;
                case 3:
                  //editTotal(quote);
                  break;
                default:
              }
            },
          );
        }));
      }).toList();

  Future editDescription(QuoteTableClass editQuote) async {
    final description = await showTextDialog(context,
        title: "Descripcion", value: editQuote.description!);
    setState(() => startRows = startRows.map((quote) {
          final isEditedDescription = quote == editQuote;
          return isEditedDescription
              ? quote.copy(description: description)
              : quote;
        }).toList());
  }

  Future editUnitario(QuoteTableClass editQuote) async {
    String unitarioString = editQuote.unitario!.replaceAll(",", "");
    final unitario = await showTextDialog(context,
        title: "Costo unitario", value: unitarioString);
    setState(() => startRows = startRows.map((quote) {
          final isEditedUnitario = quote == editQuote;
          return isEditedUnitario ? quote.copy(unitario: unitario) : quote;
        }).toList());
  }

  Future editCantidad(QuoteTableClass editQuote) async {
    final cantidad = await showTextDialog(context,
        title: "Cantidad", value: editQuote.cantidad!);
    setState(() => startRows = startRows.map((quote) {
          final isEditedCantidad = quote == editQuote;
          return isEditedCantidad ? quote.copy(cantidad: cantidad) : quote;
        }).toList());
  }

  Future editTotal(QuoteTableClass editQuote) async {
    final Total =
        await showTextDialog(context, title: "Total", value: editQuote.total!);
    setState(() => startRows = startRows.map((quote) {
          final isEditedTotal = quote == editQuote;
          return isEditedTotal ? quote.copy(total: Total) : quote;
        }).toList());
  }

  Widget editNotes() {
    return Container(
        width: (currentUser.width! - 500),
        margin: EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Notas:",
                style: title2,
              ),
            ),
            Container(
              width: (currentUser.width! - 500),
              //height: 50,
              alignment: Alignment.center,
              child: TextField(
                controller: notes,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ],
        ));
  }
}

class Utils {
  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}
