import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guadalajarav2/views/ArquiurbusDemo/DAOArquiurbus.dart';
import 'package:guadalajarav2/views/ArquiurbusDemo/TransaccionClass.dart';
import 'package:guadalajarav2/views/admin_view/admin_DeliverCertificate/LoadingData.dart';
import '../../utils/colors.dart';

class DashboardAb100 extends StatefulWidget {
  const DashboardAb100({super.key});

  @override
  State<DashboardAb100> createState() => _DashboardAb100State();
}

class _DashboardAb100State extends State<DashboardAb100> {
  List<DataColumn> headers = [
    DataColumn2(size: ColumnSize.S, label: Center(child: Text('Fecha'))),
    DataColumn2(size: ColumnSize.M, label: Center(child: Text('Hora'))),
    DataColumn2(size: ColumnSize.L, label: Center(child: Text('ID\nUnidad'))),
    DataColumn2(size: ColumnSize.M, label: Center(child: Text('Estado'))),
    DataColumn2(size: ColumnSize.M, label: Center(child: Text('Ruta'))),
    DataColumn2(size: ColumnSize.M, label: Center(child: Text('No.\nUnidad'))),
    DataColumn2(size: ColumnSize.M, label: Center(child: Text('GPS'))),
    DataColumn2(size: ColumnSize.M, label: Center(child: Text('Tarifa'))),
    DataColumn2(size: ColumnSize.S, label: Center(child: Text('Den.\n\$10'))),
    DataColumn2(size: ColumnSize.S, label: Center(child: Text('Den.\n\$5'))),
    DataColumn2(size: ColumnSize.S, label: Center(child: Text('Den.\n\$2'))),
    DataColumn2(size: ColumnSize.S, label: Center(child: Text('Den.\n\$1'))),
    DataColumn2(
        size: ColumnSize.M, label: Center(child: Text('Tipo de\nTarifa'))),
    DataColumn2(
        size: ColumnSize.M, label: Center(child: Text('Tipo de\nDebitacion')))
  ];
  List tipoTarifaList = ["", "Ordinario", "Transbordo", "Descuento"];
  List tipoDebitacionList = ["", "Efectivo", "NFC(prepago)", "QR"];
  Color backgroundColor = Color.fromARGB(255, 234, 239, 243);
  Color titleColor = Color.fromARGB(255, 67, 98, 119);
  Color buttonColor = Color.fromARGB(255, 79, 126, 157);
  List<Transaccionclass> allTransactions = [];
  List<Transaccionclass> allTransactionsFiltered = [];
  List<Transaccionclass> allTransactionsFilteredFecha = [];
  List<Transaccionclass> allTransactionsFilteredHora = [];
  List<Transaccionclass> allTransactionsFilteredEstado = [];
  MemoryImage? logo;
  bool isLoading = true;
  Timer? second;
  ValueChanged<String?>? onChanged;
  List<String> listaFechas = ["Dia", "Semana", "Mes"];
  int? horaSeleccionada;
  List<String> listaHoras = List.generate(24, (index) => "$index:00");
  List<String> listaEstados = [];
  TextEditingController ruta = TextEditingController();
  TextEditingController noUnidad = TextEditingController();
  String? fecha;
  String? hora;
  String? estado;
  String? rutaString;
  String? unidadString;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    await getTransacciones();

    executeEverySecond();
    setState(() {
      isLoading = false;
    });
  }

  executeEverySecond() async {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      List<Transaccionclass> allTransactions2 =
          await DataAccessObjectArquiurbus.getTransacciones();
      if (allTransactions2.length != allTransactions.length) {
        setState(() {
          allTransactions = allTransactions2;
          allTransactions2 = filtroCombinado(
              listaOriginal: allTransactions,
              fecha: fecha,
              hora: hora,
              estado: estado,
              ruta: rutaString,
              unidad: unidadString);
          allTransactionsFiltered = allTransactions2;
          Set<String> estadosUnicos =
              allTransactions2.map((e) => e.estado!).toSet();
          listaEstados = estadosUnicos.toList();
        });
      }
      print("estoy ejecutandome");
    });
  }

  getTransacciones() async {
    List<Transaccionclass> allTransactions2 =
        await DataAccessObjectArquiurbus.getTransacciones();

    setState(() {
      allTransactions = allTransactions2;
      allTransactionsFiltered = allTransactions2;
      allTransactionsFilteredFecha = allTransactions2;
      allTransactionsFilteredHora = allTransactions2;
      allTransactionsFilteredEstado = allTransactions2;
      Set<String> estadosUnicos =
          allTransactions2.map((e) => e.estado!).toSet();
      listaEstados.addAll(estadosUnicos.toList());
      print(allTransactions.length.toString());
    });
    return allTransactions;
  }

//Funciones de parseo
  DateTime parseFecha(String fecha) {
    final DateFormat formato = DateFormat("dd/MM/yy");
    return formato.parse(fecha);
  }

  DateTime parseHora(String hora) {
    final DateFormat formato = DateFormat("HH:mm:ss");
    return formato.parse(hora);
  }

//Funciones de filtrado
  Map<String, DateTime> obtenerRangoSemana(DateTime fecha) {
    int diaSemana = fecha.weekday;
    DateTime inicioSemana = fecha.subtract(Duration(days: diaSemana - 1));
    DateTime finSemana = inicioSemana.add(Duration(days: 6));

    return {'inicio': inicioSemana, 'fin': finSemana};
  }

  Map<String, DateTime> obtenerRangoMes(DateTime fecha) {
    DateTime inicioMes = DateTime(fecha.year, fecha.month, 1);
    DateTime finMes =
        DateTime(fecha.year, fecha.month + 1, 0); //Ultimo dia del mes
    return {'inicio': inicioMes, 'fin': finMes};
  }

  List<Transaccionclass> filtrarPorSemana(
      List<Transaccionclass> transacciones) {
    DateTime fecha = DateTime.now();
    var rango = obtenerRangoSemana(fecha);

    return transacciones.where((transaccion) {
      DateTime fechaTransaccion = parseFecha(transaccion.fecha!);
      return fechaTransaccion
              .isAfter(rango['inicio']!.subtract(Duration(days: 1))) &&
          fechaTransaccion.isBefore(rango['fin']!.add(Duration(days: 1)));
    }).toList();
  }

  List<Transaccionclass> filtrarPorMes(List<Transaccionclass> transacciones) {
    DateTime fecha = DateTime.now();
    var rango = obtenerRangoMes(fecha);
    return transacciones.where((transaccion) {
      DateTime fechaTransaccion = parseFecha(transaccion.fecha!);
      return fechaTransaccion
              .isAfter(rango['inicio']!.subtract(Duration(days: 1))) &&
          fechaTransaccion.isBefore(rango['fin']!.add(Duration(days: 1)));
    }).toList();
  }

  List<Transaccionclass> filterFechaList(
      List<Transaccionclass> lista, String value) {
    switch (value) {
      case "Dia":
        lista = lista
            .where((item) =>
                value == "Todos" ||
                int.parse(item.fecha!.split('/')[0]) == DateTime.now().day)
            .toList();
        break;
      case "Semana":
        lista = filtrarPorSemana(lista);
        break;
      case "Mes":
        lista = filtrarPorMes(lista);
        break;
      //Todo
      default:
        lista = lista;
    }
    return lista;
  }

  List<Transaccionclass> filtrarPorHora(
      List<Transaccionclass> transacciones, int horaObjetivo) {
    return transacciones.where((transaccion) {
      DateTime horaTransaccion = parseHora(transaccion.hora!);
      return horaTransaccion.hour == horaObjetivo;
    }).toList();
  }

  List<Transaccionclass> filtrarPorEstado(
      List<Transaccionclass> transacciones, String estado) {
    return transacciones.where((item) => item.estado == estado).toList();
  }

  List<Transaccionclass> filtrarPorRuta(
      List<Transaccionclass> transacciones, String rutaS) {
    rutaS = rutaS.toLowerCase();
    return transacciones.where((transaction) {
      return transaction.ruta!.toLowerCase().contains(rutaS);
    }).toList();
  }

  List<Transaccionclass> filtrarPorUnidad(
      List<Transaccionclass> transacciones, String unidad) {
    unidad = unidad.toLowerCase();
    return transacciones.where((transaction) {
      return transaction.unidad!.toLowerCase().contains(unidad);
    }).toList();
  }

//Funcion maestra de filtro combinado
  List<Transaccionclass> filtroCombinado(
      {required List<Transaccionclass> listaOriginal,
      String? fecha,
      String? hora,
      String? estado,
      String? ruta,
      String? unidad}) {
    List<Transaccionclass> listaFiltrada = listaOriginal;

    if (fecha != null && fecha.isNotEmpty) {
      listaFiltrada = filterFechaList(listaFiltrada, fecha);
    }
    if (hora != null && hora.isNotEmpty) {
      int horaEntero = int.parse(hora.split(':')[0]);
      listaFiltrada = filtrarPorHora(listaFiltrada, horaEntero);
    }
    if (estado != null && estado.isNotEmpty) {
      listaFiltrada = filtrarPorEstado(listaFiltrada, estado);
    }
    if (ruta != null && ruta.isNotEmpty) {
      listaFiltrada = filtrarPorRuta(listaFiltrada, ruta);
    }
    if (unidad != null && unidad.isNotEmpty) {
      listaFiltrada = filtrarPorUnidad(listaFiltrada, unidad);
    }
    return listaFiltrada;
  }

//Funciones onChanged
  filterFecha() {
    return onChanged = (value) {
      setState(() {
        allTransactionsFiltered = filtroCombinado(
            listaOriginal: allTransactions,
            fecha: value,
            hora: hora,
            estado: estado,
            ruta: rutaString,
            unidad: unidadString);
        fecha = value!;
      });
    };
  }

  filterHour() {
    return onChanged = (value) {
      setState(() {
        allTransactionsFiltered = filtroCombinado(
            listaOriginal: allTransactions,
            fecha: fecha,
            hora: value,
            estado: estado,
            ruta: rutaString,
            unidad: unidadString);
        hora = value!;
      });
    };
  }

  filterState() {
    return onChanged = (value) {
      setState(() {
        allTransactionsFiltered = filtroCombinado(
            listaOriginal: allTransactions,
            fecha: fecha,
            hora: hora,
            estado: value,
            ruta: rutaString,
            unidad: unidadString);
        estado = value!;
      });
    };
  }

  filterRuta() {
    return onChanged = (value) {
      setState(() {
        allTransactionsFiltered = filtroCombinado(
            listaOriginal: allTransactions,
            fecha: fecha,
            hora: hora,
            estado: estado,
            ruta: value,
            unidad: unidadString);
        rutaString = value!;
      });
    };
  }

  filterNoUnidad() {
    return onChanged = (value) {
      setState(() {
        allTransactionsFiltered = filtroCombinado(
            listaOriginal: allTransactions,
            fecha: fecha,
            hora: hora,
            estado: estado,
            ruta: rutaString,
            unidad: value);
        unidadString = value!;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingData()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: backgroundColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/pathbuslogo.png',
                      fit: BoxFit.contain,
                      width: 200,
                      height: 100,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(right: 225),
                        child: Text("Arquiurbus",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                color: titleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 26)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                      gradient: linearGradient(
                          colors: [Colors.black26, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                ),
                filtros(),
                Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: table()),
              ],
            ),
          );
  }

  Widget table() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width + 200,
        height: MediaQuery.of(context).size.height - 200,
        child: DataTable2(
            border: TableBorder.all(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[400]!),
            columns: headers,
            headingTextStyle: GoogleFonts.montserrat(
                color: black, fontSize: 16, fontWeight: FontWeight.w500),
            dataTextStyle: GoogleFonts.montserrat(color: black, fontSize: 14),
            rows: List.generate(
                allTransactionsFiltered.length,
                (index) => DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                          return index.isEven ? backgroundColor : Colors.white;
                        }),
                        cells: <DataCell>[
                          //Fecha
                          DataCell(Center(
                              child:
                                  Text(allTransactionsFiltered[index].fecha!))),
                          //Hora
                          DataCell(Center(
                              child:
                                  Text(allTransactionsFiltered[index].hora!))),
                          //Id
                          DataCell(Center(
                              child: Text(allTransactionsFiltered[index]
                                  .idUnidad
                                  .toString()))),
                          //Estado
                          DataCell(Center(
                              child: Text(allTransactionsFiltered[index]
                                  .estado
                                  .toString()))),
                          //Ruta
                          DataCell(Center(
                              child: Text(allTransactionsFiltered[index]
                                  .ruta
                                  .toString()))),
                          //No. Unidad
                          DataCell(Center(
                              child: Text(allTransactionsFiltered[index]
                                  .unidad
                                  .toString()))),
                          //GPS
                          DataCell(Center(
                            child: Text(
                                "${allTransactionsFiltered[index].latitud.toString()}, ${allTransactionsFiltered[index].longitud.toString()}"),
                          )),
                          //Tarifa $
                          DataCell(Center(
                              child: Text(
                                  "\$${allTransactionsFiltered[index].tarifa}"))),
                          //Denominacion $10
                          DataCell(Center(
                            child: Text(int.parse(allTransactionsFiltered[index]
                                    .denominaciones!
                                    .split(",")[3])
                                .toString()),
                          )),
                          //Denominacion $5
                          DataCell(Center(
                            child: Text(int.parse(allTransactionsFiltered[index]
                                    .denominaciones!
                                    .split(",")[2])
                                .toString()),
                          )),
                          //Denominacion $2
                          DataCell(Center(
                            child: Text(int.parse(allTransactionsFiltered[index]
                                    .denominaciones!
                                    .split(",")[1])
                                .toString()),
                          )),
                          //Denominacion $1
                          DataCell(Center(
                            child: Text(int.parse(allTransactionsFiltered[index]
                                    .denominaciones!
                                    .split(",")[0])
                                .toString()),
                          )),
                          //Tipo de Tarifa
                          DataCell(Center(
                            child: Text(tipoTarifaList[
                                allTransactionsFiltered[index].tipoTarifa!]),
                          )),
                          //Tipo de Tarifa
                          DataCell(Center(
                            child: Text(tipoDebitacionList[
                                allTransactionsFiltered[index]
                                    .tipoDebitacion!]),
                          )),
                        ]))),
      ),
    );
  }

  Widget filtros() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Fecha
          dropdowns(fecha, "Fecha", listaFechas, filterFecha()),
          //Hora
          dropdowns(hora, "Hora", listaHoras, filterHour()),
          //Estado
          dropdowns(estado, "Estado", listaEstados, filterState()),
          //Ruta
          textField(rutaString, "Ruta", ruta, filterRuta()),
          //No. Unidad
          textField(unidadString, "No. Unidad", noUnidad, filterNoUnidad()),
          //Button Delete
          buttonDeleteFilters()
        ],
      ),
    );
  }

  Widget textField(
      String? value, String hint, TextEditingController controller, onchange) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: 150,
        height: 65,
        child: TextFormField(
          controller: controller,
          onChanged: onchange,
          cursorColor: titleColor,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: hint,
              labelStyle: TextStyle(color: Colors.grey[600]),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: titleColor))),
        ),
      ),
    );
  }

  Widget dropdowns(String? value, String hint, List<String> items, onchange) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: 150,
        height: 65,
        child: DropdownButtonFormField(
          value: value,
          items: items
              .map((String filter) =>
                  DropdownMenuItem(child: Text(filter), value: filter))
              .toList(),
          onChanged: onchange,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: hint,
              labelStyle: TextStyle(color: Colors.grey[600]),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: titleColor))),
        ),
      ),
    );
  }

  Widget buttonDeleteFilters() {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 17),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              backgroundColor: buttonColor,
              foregroundColor: Colors.white),
          onPressed: () {
            setState(() {
              fecha = null;
              hora = null;
              estado = null;
              rutaString = null;
              ruta = TextEditingController();
              unidadString = null;
              noUnidad = TextEditingController();
              allTransactionsFiltered = allTransactions;
            });
          },
          child: Text(
            "Eliminar filtros",
            style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w700),
          )),
    );
  }
}
