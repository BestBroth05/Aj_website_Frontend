// ignore_for_file: must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/utils/SuperGlobalVariables/ObjVar.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Quotes/Assemblies/TextDialogWidget.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';
import 'package:guadalajarav2/views/Quotes/PDFWidgets/ExportUnificatedPDF.dart';
import 'package:guadalajarav2/views/Quotes/Text_Quotes.dart';
import 'package:pdf/pdf.dart';
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

class Preview_Assemblies extends StatefulWidget {
  bool? isEdit;
  bool? isSavedQuote;
  QuoteClass? quote;
  CustomersClass? customer;
  Preview_Assemblies(
      {super.key,
      this.quote,
      this.customer,
      this.isSavedQuote,
      required this.isEdit});

  @override
  State<Preview_Assemblies> createState() => _Preview_AssembliesState();
}

class _Preview_AssembliesState extends State<Preview_Assemblies> {
  String? date;
  String currency = "MXN";
  String? conIva;
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  List<QuoteTableClass> rows = [];
  List<QuoteTableClass> editedList = [];
  List<QuoteTableClass> preview = [];
  double total = 0.0;
  List<String> columns = [];
  bool onErrore = false;
  bool addComponents = true;
  bool addPCB = true;
  String? colorNameSpanish;
  bool isUpdate = false;
  TextEditingController notes = TextEditingController();
  int startValues = 0;
  List<QuoteTableClass> deleteList = [];
  int timesToSavePreview = 0;
  bool isLoading = true;
  int countRows = 0;
  AJRoute route = AJRoute.adminQuotes;
  //Header variables

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (widget.quote!.PCBTotalMXN == 0) {
      addPCB = false;
    }
    if (widget.quote!.totalComponentsMXN == 0) {
      addComponents = false;
    }
    if (widget.isEdit!) {
      date = DateFormat('MMMM d, yyyy').format(DateTime.now());
      //Notes seran las de el preview
      await getPreviewAndUpdate(widget.quote!.id_Quote);
    } else {
      date = DateFormat('MMMM d, yyyy')
          .format(DateTime.parse(widget.quote!.date!));
      if (widget.quote!.id_Quote == null) {
        await getIdQuote();
      }
      await getPreview(0, widget.quote!.id_Quote);
    }

    setState(() {
      isLoading = false;
    });
  }

  getPreviewAndUpdate(idQuote) async {
    int countRowsBeforeEnvio = 0;
    List<QuoteTableClass> previewLocal = [];
    List<QuoteTableClass> preview1 =
        await DataAccessObject.selectPreviewByQuote(idQuote);
    List<QuoteTableClass> preview2 =
        await DataAccessObject.selectPreviewByQuote(idQuote);
    await fillColumnsSpanish();
    setState(() {
      preview = preview2;
      //Contar filas antes del envio en preview
      for (var i = 0; i < preview1.length; i++) {
        if (preview1[i].description!.contains("Envío")) {
          break;
        } else {
          countRowsBeforeEnvio += 1;
        }
      }
      preview1.removeRange(0, countRowsBeforeEnvio);
      for (var i = 0; i < editedList.length; i++) {
        previewLocal.add(editedList[i]);
      }
      for (var i = 0; i < preview1.length; i++) {
        previewLocal.add(preview1[i]);
      }
      rows = previewLocal;
      notes.text = preview1[0].notas!;
    });
  }

  getPreview(times, idQuote) async {
    List<QuoteTableClass> preview1 =
        await DataAccessObject.selectPreviewByQuote(idQuote);
    setState(() {
      preview = preview1;
    });
    if (times > 1) {
      //Nothing to do
    } else {
      startValues = preview1.length;
      if (preview1.isNotEmpty) {
        notes.text = preview1[0].notas!;
        rows = preview1;
        isUpdate = true;
      } else {
        await fillColumnsSpanish();
      }
    }
  }

  getIdQuote() async {
    List<QuoteClass> quotesId = await DataAccessObject.getQuotes();
    setState(() {
      widget.quote!.id_Quote = quotesId[quotesId.length - 1].id_Quote;
    });
  }

  fillColumnsSpanish() async {
    List<QuoteTableClass> fillingRows = [];
    switch (widget.quote!.PCBColor) {
      case "Green":
        colorNameSpanish = "Verde";
        break;
      case "Purple":
        colorNameSpanish = "Morado";
        break;
      case "Red":
        colorNameSpanish = "Rojo";
        break;
      case "Yellow":
        colorNameSpanish = "Amarillo";
        break;
      case "Blue":
        colorNameSpanish = "Azul";
        break;
      case "White":
        colorNameSpanish = "Blanco";
        break;
      default:
        colorNameSpanish = "Negro";
        break;
    }
    if (!widget.isEdit!) {
      notes.text =
          "-Los costos son calculados de acuerdo con el volumen solicitado, en caso de necesitar diferente volumen favor de solicitar cotización\n-Componentes sujetos a disponibilidad y precio de mercado\n-Para poder manufacturar su pedido es necesario que genere una orden de compra firmada por el responsable de su empresa\n-Vigencia de cotización: 8 dìas hábiles\n-El cliente se hace responsable de los archivos entregados para la fabricación de su producto, en dado caso de tener algún error se debe hacer cargo de los gastos generados al 100%\n-Una vez iniciada el proceso de compra/fabricación, no se aceptan cambios en el diseño a menos de que se paguen los cambios a realizar.";
    }

    if (!addComponents && !addPCB) {
      fillingRows = [
        QuoteTableClass(
            description:
                "Ensamble \"${widget.quote!.proyectName}\"\n               ${widget.quote!.assemblyLayers}\n               ${widget.quote!.assemblyMPN} MPN\n               ${widget.quote!.assemblySMT} SMT\nIncluye inspección visual, limpieza y empaque antiestático.\nTiempo de entrega ${widget.quote!.assemblyDeliveryTime!.replaceAll("to", "a").replaceAll("days", "dias")} hábiles",
            unitario: formatter.format(widget.quote!.perAssemblyMXN),
            cantidad: widget.quote!.quantity.toString(),
            total: formatter.format(widget.quote!.assemblyTotalMXN)),
        QuoteTableClass(
            description: "Envío GDL – \nPAQUETE ASEGURADO",
            unitario: "0.0",
            cantidad: "1",
            total: "0.0")
      ];
      setState(() {
        countRows = 1;
      });
    } else if (!addComponents) {
      fillingRows = [
        QuoteTableClass(
            description:
                "Fabricación de PCB \"${widget.quote!.proyectName}\"\n                ${widget.quote!.PCBLayers}. Top y Bottom 1oz FR4 .062¨ Color: ${colorNameSpanish}\n                Size: ${widget.quote!.PCBSize}\nTiempo de entrega ${widget.quote!.PCBDeliveryTime!.replaceAll("to", "a").replaceAll("days", "dias")} hábiles",
            unitario: formatter.format(widget.quote!.PCBPerMXN),
            cantidad: widget.quote!.quantity.toString(),
            total: formatter.format(widget.quote!.PCBTotalMXN)),
        QuoteTableClass(
            description:
                "Ensamble \"${widget.quote!.proyectName}\"\n               ${widget.quote!.assemblyLayers}\n               ${widget.quote!.assemblyMPN} MPN\n               ${widget.quote!.assemblySMT} SMT\nIncluye inspección visual, limpieza y empaque antiestático.\nTiempo de entrega ${widget.quote!.assemblyDeliveryTime!.replaceAll("to", "a").replaceAll("days", "dias")} hábiles",
            unitario: formatter.format(widget.quote!.perAssemblyMXN),
            cantidad: widget.quote!.quantity.toString(),
            total: formatter.format(widget.quote!.assemblyTotalMXN)),
        QuoteTableClass(
            description: "Envío GDL – \nPAQUETE ASEGURADO",
            unitario: "0.0",
            cantidad: "1",
            total: "0.0")
      ];
      setState(() {
        countRows = 2;
      });
    } else if (!addPCB) {
      fillingRows = [
        QuoteTableClass(
            description:
                "Componentes \"${widget.quote!.excelName!}\"\n               ${widget.quote!.componentsMPN} MPN PUESTOS EN MEXICO\n               ${widget.quote!.componentsAvailables} no disponibles-envía ${widget.customer!.name}\nTiempo de entrega ${widget.quote!.componentsDeliverTime!.replaceAll("to", "a").replaceAll("days", "dias")} hábiles",
            unitario: formatter.format(widget.quote!.perComponentMXN),
            cantidad: widget.quote!.quantity.toString(),
            total: formatter.format(widget.quote!.totalComponentsMXN)),
        QuoteTableClass(
            description:
                "Ensamble \"${widget.quote!.proyectName}\"\n               ${widget.quote!.assemblyLayers}\n               ${widget.quote!.assemblyMPN} MPN\n               ${widget.quote!.assemblySMT} SMT\n               ${widget.quote!.assemblyTH} TH\nIncluye inspección visual, limpieza y empaque antiestático.\nTiempo de entrega ${widget.quote!.assemblyDeliveryTime!.replaceAll("to", "a").replaceAll("days", "dias")} hábiles",
            unitario: formatter.format(widget.quote!.perAssemblyMXN),
            cantidad: widget.quote!.quantity.toString(),
            total: formatter.format(widget.quote!.assemblyTotalMXN)),
        QuoteTableClass(
            description: "Envío GDL – \nPAQUETE ASEGURADO",
            unitario: "0.0",
            cantidad: "1",
            total: "0.0")
      ];
      setState(() {
        countRows = 2;
      });
    } else {
      fillingRows = [
        QuoteTableClass(
            description:
                "Components \"${widget.quote!.excelName!}\"\n               ${widget.quote!.componentsMPN} MPN PUESTOS EN MEXICO\n               ${widget.quote!.componentsAvailables} no disponibles-envía ${widget.customer!.name}\nTiempo de entrega ${widget.quote!.componentsDeliverTime!.replaceAll("to", "a").replaceAll("days", "dias")} hábiles",
            unitario: formatter.format(widget.quote!.perComponentMXN),
            cantidad: widget.quote!.quantity.toString(),
            total: formatter.format(widget.quote!.totalComponentsMXN)),
        QuoteTableClass(
            description:
                "Fabricación de PCB \"${widget.quote!.proyectName}\"\n                ${widget.quote!.PCBLayers}. Top y Bottom 1oz FR4 .062¨ Color: ${colorNameSpanish}\n                Size: ${widget.quote!.PCBSize}\nTiempo de entrega ${widget.quote!.PCBDeliveryTime!.replaceAll("to", "a").replaceAll("days", "dias")} hábiles",
            unitario: formatter.format(widget.quote!.PCBPerMXN),
            cantidad: widget.quote!.quantity.toString(),
            total: formatter.format(widget.quote!.PCBTotalMXN)),
        QuoteTableClass(
            description:
                "Ensamble \"${widget.quote!.proyectName}\"\n               ${widget.quote!.assemblyLayers}\n               ${widget.quote!.assemblyMPN} MPN\n               ${widget.quote!.assemblySMT} SMT\n               ${widget.quote!.assemblyTH} TH\nIncluye inspección visual, limpieza y empaque antiestático.\nTiempo de entrega ${widget.quote!.assemblyDeliveryTime!.replaceAll("to", "a").replaceAll("days", "dias")} hábiles",
            unitario: formatter.format(widget.quote!.perAssemblyMXN),
            cantidad: widget.quote!.quantity.toString(),
            total: formatter.format(widget.quote!.assemblyTotalMXN)),
        QuoteTableClass(
            description: "Envío GDL – \nPAQUETE ASEGURADO",
            unitario: "0.0",
            cantidad: "1",
            total: "0.0")
      ];
      setState(() {
        countRows = 3;
      });
    }
    setState(() {
      if (!widget.isEdit!) {
        rows = fillingRows;
      } else {
        fillingRows.removeAt(fillingRows.length - 1);
        editedList = fillingRows;
      }
      startValues = rows.length;
    });
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
            " ");
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
            " ");
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

  deleteAndPost() async {
    await deleteRow(preview);
    await postPreview(rows);
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

  deleteRow(List<QuoteTableClass> deleteList) async {
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
      await getPreview(timesToSavePreview, widget.quote!.id_Quote);
    } else {
      //Nothing to do
    }
    if (!widget.isEdit!) {
      //No es un caso real
      List<QuoteTableClass> sendList = [];
      List<QuoteTableClass> sendList2 = [];
      if (isUpdate) {
        //Update all
        if (rows.length == startValues) {
          sendList = rows;
          print("Entre a update");
          await updatePreview(sendList);
        }
        //Add Row and update
        else if (rows.length > startValues) {
          print("Entre a update y add");
          for (var i = 0; i < startValues; i++) {
            sendList.add(rows[i]);
          }
          for (var i = startValues; i < rows.length; i++) {
            sendList2.add(rows[i]);
          }
          await addAndUpdate(sendList, sendList2);
        }
        //Delete row
        else if (rows.length < startValues) {
          print("Entre a delete");
          await deleteRow(deleteList);
        }
      } else {
        print("Entre a post");
        sendList = rows;
        await postPreview(sendList);
      }
    } else {
      await deleteAndPost();
    }
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
                  rows.removeAt(rows.length - 1);
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
                  rows.add(QuoteTableClass(
                      description: "",
                      unitario: "0.0",
                      cantidad: "0.0",
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
              showQuoteExportDialog(
                context: context,
                type: QuoteType.assembly, // o QuoteType.manufacture
                isPDF: true, // true = exportar PDF, false = exportar Word
                addPCB: addPCB, // solo importa en assemblies
                addComponents: addComponents, // solo importa en assemblies
                dataTable: rows, // tu lista de QuoteTableClass
                quote: widget.quote!, // tu objeto QuoteClass
                customer: widget.customer!, // tu objeto CustomersClass
                notes: notes.text, // opcional
                pageFormat: PdfPageFormat.a3, // o .a4, según quieras
              );
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
              showQuoteExportDialog(
                context: context,
                type: QuoteType.assembly, // o QuoteType.manufacture
                isPDF: false, // true = exportar PDF, false = exportar Word
                addPCB: addPCB, // solo importa en assemblies
                addComponents: addComponents, // solo importa en assemblies
                dataTable: rows, // tu lista de QuoteTableClass
                quote: widget.quote!, // tu objeto QuoteClass
                customer: widget.customer!, // tu objeto CustomersClass
                notes: notes.text, // opcional
                pageFormat: PdfPageFormat.a3, // o .a4, según quieras
              );
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
      columns = ['Descripción', 'Costo\nunitario', 'Cantidad', 'Total\nMXN'];
    } else {
      currency = "USD";
      columns = ['Descripción', 'Costo\nunitario', 'Cantidad', 'Total\nUSD'];
    }
    if (widget.quote!.conIva!) {
      conIva = "* Con IVA";
    } else {
      conIva = "* Sin IVA";
    }
    setState(() {
      List<QuoteTableClass> newQuote = rows;
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
                rows: getRows(rows)),
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
          quote.unitario,
          quote.cantidad,
          quote.total
        ];

        return DataRow(
            cells: Utils.modelBuilder(cells, (index, cell) {
          return DataCell(
            index == 2 || index == 0 ? Text("$cell") : Text("\$$cell"),
            //showEditIcon: true,
            onTap: () {
              switch (index) {
                case 0:
                  editDescription(quote);
                  break;
                case 1:
                  editUnitario(quote);
                  break;
                case 2:
                  editCantidad(quote);
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
    setState(() => rows = rows.map((quote) {
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
    setState(() => rows = rows.map((quote) {
          final isEditedUnitario = quote == editQuote;
          return isEditedUnitario ? quote.copy(unitario: unitario) : quote;
        }).toList());
  }

  Future editCantidad(QuoteTableClass editQuote) async {
    final cantidad = await showTextDialog(context,
        title: "Cantidad", value: editQuote.cantidad!);
    setState(() => rows = rows.map((quote) {
          final isEditedCantidad = quote == editQuote;
          return isEditedCantidad ? quote.copy(cantidad: cantidad) : quote;
        }).toList());
  }

  Future editTotal(QuoteTableClass editQuote) async {
    final Total =
        await showTextDialog(context, title: "Total", value: editQuote.total!);
    setState(() => rows = rows.map((quote) {
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
