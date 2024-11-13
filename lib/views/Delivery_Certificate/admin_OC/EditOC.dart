// ignore_for_file: must_be_immutable
import 'dart:convert';

import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_places_autocomplete_widgets/address_autocomplete_widgets.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/OrdenCompraClass.dart';
import 'package:guadalajarav2/views/admin_view/AdminWidgets/Title.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import '../../../utils/colors.dart';
import '../adminClases/Places.dart';
import '../adminClases/Suggestion.dart';
import '../widgets/Popups.dart';
import '../widgets/Texts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'ChooseCompany.dart';

class EditOC extends StatefulWidget {
  OrdenCompraClass OrdenCompra;
  int id_customer;
  EditOC({super.key, required this.id_customer, required this.OrdenCompra});

  @override
  State<EditOC> createState() => _EditOCState();
}

class _EditOCState extends State<EditOC> {
  TextEditingController solicitante = TextEditingController();
  TextEditingController ordenCompra = TextEditingController();
  TextEditingController prefijo = TextEditingController();
  String? day_inicio;
  String? month_inicio;
  String? year_inicio;
  String? day_fin;
  String? month_fin;
  String? year_fin;
  TextEditingController pais = TextEditingController();
  TextEditingController estado = TextEditingController();
  TextEditingController ciudad = TextEditingController();
  TextEditingController vicinity = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController cp = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController cantidad = TextEditingController();
  String? prioridad;
  String? moneda;
  bool isPressed = false;
  List PriorityList = ['High', 'Medium', 'Low'];
  final _formKeyOC = GlobalKey<FormState>();
  List<OrdenCompraClass> OCList = [];
  DateTime? fecha_inicio;
  DateTime? fecha_fin;
  final _controller = TextEditingController();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];
  List<MySuggestion> suggestions = [];
  String PLACES_API_KEY = "AIzaSyCH7w3W_3lumfjO4FtZAU_FOTSWBXVZnMw";
  MyPlace? myPlace;
  //PostalCode? _postalCode;

  @override
  void initState() {
    super.initState();
    ordenCompra.text = widget.OrdenCompra.OC!;
    prefijo.text = widget.OrdenCompra.prefijo!;
    description.text = widget.OrdenCompra.descripcion!;
    cantidad.text = widget.OrdenCompra.cantidad.toString();
    fecha_inicio = DateTime.parse(widget.OrdenCompra.fecha_inicio!);
    day_inicio = DateFormat.d().format(fecha_inicio!);
    month_inicio = DateFormat.M().format(fecha_inicio!);
    year_inicio = DateFormat.y().format(fecha_inicio!);
    fecha_fin = DateTime.parse(widget.OrdenCompra.fecha_fin!);
    day_fin = DateFormat.d().format(fecha_fin!);
    month_fin = DateFormat.M().format(fecha_fin!);
    year_fin = DateFormat.y().format(fecha_fin!);
    solicitante.text = widget.OrdenCompra.solicitante!;
    moneda = widget.OrdenCompra.moneda;
    prioridad = widget.OrdenCompra.prioridad;
    pais.text = widget.OrdenCompra.pais!;
    estado.text = widget.OrdenCompra.estado!;
    ciudad.text = widget.OrdenCompra.ciudad!;
    List separateStreet = widget.OrdenCompra.street!.split(',');
    street.text = separateStreet[0];
    vicinity.text = separateStreet[1];
    cp.text = widget.OrdenCompra.cp.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: teal.add(black, 0.3),
          title: TitleH1(context, "Add Purchase Order"),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 100, right: 100, top: 20),
            child: Form(
                key: _formKeyOC,
                child: Column(
                  children: [
                    fieldCustomer(
                      ordenCompra,
                      "Purchase order",
                      TextInputType.text,
                      FilteringTextInputFormatter.singleLineFormatter,
                      300,
                    ),
                    fieldCustomer(
                      prefijo,
                      "Prefijo",
                      TextInputType.text,
                      FilteringTextInputFormatter.singleLineFormatter,
                      MediaQuery.of(context).size.width,
                    ),
                    fieldCustomer(
                      description,
                      "Description",
                      TextInputType.text,
                      FilteringTextInputFormatter.singleLineFormatter,
                      MediaQuery.of(context).size.width,
                    ),
                    fieldCustomer(
                      cantidad,
                      "Quantity",
                      TextInputType.number,
                      FilteringTextInputFormatter.digitsOnly,
                      MediaQuery.of(context).size.width,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text('* Start date', style: fieldText),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 5),
                                  width: 360,
                                  child: DropdownDatePicker(
                                    boxDecoration: const BoxDecoration(
                                        color: Colors.white),
                                    textStyle: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    dayFlex: 2,
                                    inputDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10))), // optional
                                    isDropdownHideUnderline: true, // optional
                                    isFormValidator: false, // optional
                                    startYear: 2000, // optional
                                    endYear:
                                        int.parse(year_inicio!), // optional
                                    width: 10, // optional

                                    selectedDay:
                                        int.parse(day_inicio!), // optional
                                    selectedMonth:
                                        int.parse(month_inicio!), // optional
                                    selectedYear:
                                        int.parse(year_inicio!), // optional
                                    onChangedDay: (valueDay) {
                                      day_inicio = valueDay!;
                                      print('onChangedDay: $valueDay');
                                    },

                                    onChangedMonth: (valueMonth) {
                                      month_inicio = valueMonth!;
                                      print('onChangedMonth: $valueMonth');
                                    },

                                    onChangedYear: (valueYear) {
                                      year_inicio = valueYear!;
                                      print('onChangedYear: $valueYear');
                                    },
                                    hintDay: 'Day', // optional
                                    hintMonth: 'Month', // optional
                                    hintYear: 'Year', // optional
                                    hintTextStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14), // optional
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text('* End date', style: fieldText),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 5),
                                  width: 360,
                                  child: DropdownDatePicker(
                                    boxDecoration: const BoxDecoration(
                                        color: Colors.white),
                                    textStyle: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    dayFlex: 2,
                                    inputDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10))), // optional
                                    isDropdownHideUnderline: true, // optional
                                    isFormValidator: false, // optional
                                    startYear: 2000, // optional
                                    endYear: 2030, // optional
                                    width: 10, // optional

                                    selectedDay:
                                        int.parse(day_fin!), // optional
                                    selectedMonth:
                                        int.parse(month_fin!), // optional
                                    selectedYear:
                                        int.parse(year_fin!), // optional
                                    onChangedDay: (valueDay) {
                                      day_fin = valueDay!;
                                      print('onChangedDay: $valueDay');
                                    },

                                    onChangedMonth: (valueMonth) {
                                      month_fin = valueMonth!;
                                      print('onChangedMonth: $valueMonth');
                                    },

                                    onChangedYear: (valueYear) {
                                      year_fin = valueYear!;
                                      print('onChangedYear: $valueYear');
                                    },
                                    hintDay: 'Day', // optional
                                    hintMonth: 'Month', // optional
                                    hintYear: 'Year', // optional
                                    hintTextStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14), // optional
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    fieldCustomer(
                      solicitante,
                      "Applicant",
                      TextInputType.text,
                      FilteringTextInputFormatter.singleLineFormatter,
                      MediaQuery.of(context).size.width,
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "* Currency:",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 300,
                                      child: DropdownButtonFormField(
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Currency is required';
                                            }
                                            return null;
                                          },
                                          style: fieldStyle,
                                          decoration: InputDecoration(
                                              hintStyle: hintStyle,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.redAccent),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.redAccent),
                                              )),
                                          isExpanded: true,
                                          hint: Text(
                                            "--Select Option--",
                                            style: fieldStyle,
                                          ),
                                          items: [
                                            DropdownMenuItem<String>(
                                                child: Text('USD',
                                                    style: fieldStyle),
                                                value: 'USD'),
                                            DropdownMenuItem<String>(
                                                child: Text(
                                                  'MXN',
                                                  style: fieldStyle,
                                                ),
                                                value: 'MXN')
                                          ],
                                          value: moneda,
                                          onChanged: (value) {
                                            moneda = value;
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "* Priority:",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 300,
                                      child: DropdownButtonFormField(
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Priority is required';
                                            }
                                            return null;
                                          },
                                          style: fieldStyle,
                                          decoration: InputDecoration(
                                              hintStyle: hintStyle,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.green),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.redAccent),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Colors.redAccent),
                                              )),
                                          isExpanded: true,
                                          hint: Text("--Select Option--",
                                              style: fieldStyle),
                                          items: [
                                            DropdownMenuItem<String>(
                                                child: Text(
                                                  'High',
                                                  style: fieldStyle,
                                                ),
                                                value: 'High'),
                                            DropdownMenuItem<String>(
                                                child: Text(
                                                  'Medium',
                                                  style: fieldStyle,
                                                ),
                                                value: 'Medium'),
                                            DropdownMenuItem<String>(
                                                child: Text(
                                                  'Low',
                                                  style: fieldStyle,
                                                ),
                                                value: 'Low')
                                          ],
                                          value: prioridad,
                                          onChanged: (value) {
                                            setState(() {
                                              prioridad = value;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "* Delivery address:",
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ),
                    fieldSearchPlace(),
                    SizedBox(height: 10),
                    fieldAdress(pais, "Country", TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    fieldAdress(estado, "State", TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    fieldAdress(ciudad, "City", TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    fieldAdress(street, "Street", TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    fieldAdress(cp, "Postal Code", TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    fieldAdress(vicinity, "Vicinity", TextInputType.text,
                        FilteringTextInputFormatter.singleLineFormatter),
                    buttonEditOC(),
                    SizedBox(height: 25),
                  ],
                )),
          ),
        ));
  }

  late FocusNode addressFocusNode;
  // This callback returns what we want to be put into the text control
  // when they choose an address
  String? onSuggestionClickGetTextToUseForControl(Place placeDetails) {
    String? forOurAddressBox = placeDetails.streetAddress;
    if (forOurAddressBox == null || forOurAddressBox.isEmpty) {
      forOurAddressBox = placeDetails.streetNumber ?? '';
      forOurAddressBox += (forOurAddressBox.isNotEmpty ? ' ' : '');
      forOurAddressBox += placeDetails.streetShort ?? '';
    }
    return forOurAddressBox;
  }

  /// This method really does not seem to help...
  /// But i left the ability in because it might help more in
  /// countries other than the united states.
  String prepareQuery(String baseAddressQuery) {
    debugPrint('prepareQuery() baseAddressQuery=$baseAddressQuery');
    String built = baseAddressQuery;
    String city = ciudad.text;
    String state = estado.text;
    String zip = cp.text;
    if (city.isNotEmpty) {
      built += ', $city';
    }
    if (state.isNotEmpty) {
      built += ', $state';
    }
    if (zip.isNotEmpty) {
      built += ' $zip';
    }
    built += ', USA';
    debugPrint('prepareQuery made built="$built"');
    return built;
  }

  void onClearClick() {
    debugPrint('onClearClickInAddressAutocomplete() clearing form');
    street.clear();
    pais.clear();
    ciudad.clear();
    estado.clear();
    cp.clear();
    vicinity.clear();

    if (!addressFocusNode.hasFocus) {
      // if address does not have focus unfocus everything to close keyboard
      // and show the cleared form.
      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.unfocus();
    }
  }

  // This gets us an IMMEDIATE form fill but address has no abbreviations
  // and we must wait for the zipcode.
  void onInitialSuggestionClickAddress(Suggestion suggestion) {
    final description = suggestion.description;

    debugPrint('onInitialSuggestionClick()  description=$description');
    debugPrint('  suggestion = $suggestion');
    /* COULD BE USED TO SHOW IMMEDIATE values in form
       BEFORE PlaceDetails arrive from API

    var parts = description.split(',');

    if(parts.length<4) {
      parts = [ '','','','' ];
    }
    addressTextController.text = parts[0];
    cityTextController.text = parts[1];
    stateTextController.text = parts[2].trim();
    zipTextController.clear(); // we wont have zip until details come thru
    */
  }

  // write a function to receive the place details callback
  void onSuggestionClickAddress(Place placeDetails) {
    debugPrint('onSuggestionClick() placeDetails:$placeDetails');
    pais.text = placeDetails.country ?? '';
    ciudad.text = placeDetails.city ?? '';
    estado.text = placeDetails.state ?? '';
    cp.text = placeDetails.zipCode ?? '';
    street.text = placeDetails.name ?? '';
    vicinity.text = placeDetails.vicinity ?? '';
  }

  InputDecoration getInputDecoration(String hintText) {
    return InputDecoration(
        hintStyle: fieldStyle,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ));
  }

  Widget fieldAddresstype() {
    return AddressAutocompleteTextFormField(
      // following args specific to AddressAutocompleteTextFormField()
      mapsApiKey: 'AIzaSyCH7w3W_3lumfjO4FtZAU_FOTSWBXVZnMw',
      debounceTime: 200,
      controller: street,
      //In practice this does not seem to help United States address//prepareQuery: prepareQuery,
      onClearClick: onClearClick,
      onSuggestionClickGetTextToUseForControl:
          onSuggestionClickGetTextToUseForControl,
      onInitialSuggestionClick: onInitialSuggestionClickAddress,
      onSuggestionClick: onSuggestionClickAddress,
      onFinishedEditingWithNoSuggestion: (text) {
        // you should invalidate the last entry of onSuggestionClick if you really need a valid location,
        // otherwise decide what to do based on what the user typed, can be an empty string
        debugPrint('onFinishedEditingWithNoSuggestion()  text typed: $text');
      },
      hoverColor: Colors.green, // for desktop platforms with mouse
      selectionColor: Colors.green, // for desktop platforms with mouse
      buildItem: (Suggestion suggestion, int index) {
        return Container(
            margin: const EdgeInsets.fromLTRB(2, 2, 2,
                2), //<<This area will get hoverColor/selectionColor on desktop
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Text(suggestion.description, style: fieldStyle));
      },
      clearButton: const Icon(Icons.close),
      //componentCountry: 'us',
      language: 'en-Us',

      // 'normal' TextFormField arguments:
      autofocus: false,
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.streetAddress,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        debugPrint('onEditingComplete() for TextFormField');
      },
      onChanged: (newText) {
        debugPrint('onChanged() for TextFormField got "$newText"');
      },
      style: fieldStyle,
      decoration:
          getInputDecoration('* Start typing address for Autocomplete..'),
    );
  }

  Widget buttonEditOC() {
    return Container(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              maximumSize: Size(150, 75),
              backgroundColor: !isPressed ? Colors.teal : Colors.grey,
              foregroundColor: Colors.white),
          onPressed: () {
            //postData();
            if (_formKeyOC.currentState!.validate()) {
              if (!isPressed) {
                postData();
                setState(() => isPressed = true);
              }
            }
          },
          child: Text(
            'Edit',
            style: buttonAdd,
          )),
    );
  }

  postData() async {
    if (_formKeyOC.currentState!.validate()) {
      String fecha_inicio = '$year_inicio-$month_inicio-$day_inicio';
      String fecha_fin = "$year_fin-$month_fin-$day_fin";
      int result = await DataAccessObject.updateOC(
          widget.OrdenCompra.id_OC,
          widget.id_customer,
          ordenCompra.text,
          fecha_inicio,
          fecha_fin,
          solicitante.text,
          pais.text,
          estado.text,
          ciudad.text,
          int.parse(cp.text),
          "${street.text},${vicinity.text}",
          prioridad,
          moneda,
          description.text,
          int.parse(cantidad.text),
          prefijo.text);

      if (result == 200) {
        succesfullyPopUp(context, "Succesfully edited");
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChooseCompany()));
        });
      } else if (result == 400) {
        wrongPopup(context, "The purchase order already exist");
        Future.delayed(const Duration(seconds: 3), () {
          setState(() => isPressed = false);
          Navigator.pop(context);
        });
      } else {
        wrongPopup(context, "Something went wrong");
        Future.delayed(const Duration(seconds: 3), () {
          setState(() => isPressed = false);
          Navigator.pop(context);
        });
      }
    } else {
      setState(() => isPressed = false);
    }
  }

  // *********************** Search Ubication *********************** //
  void getSuggestion(String input) async {
    try {
      String baseURL =
          'https://proxy.cors.sh/https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';
      var response = await http.get(
        Uri.parse(request),
        headers: <String, String>{
          'x-cors-api-key': 'temp_38d3f85e8f9303c1da6c5ce747ad8269'
        },
      );
      var data = json.decode(response.body);
      if (kDebugMode) {
        print('mydata');
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
          // compose suggestions in a list
          suggestions = getSuggestions(data);
          print("My data ${suggestions.length}");
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  List<MySuggestion> getSuggestions(result) {
    // compose suggestions in a list
    return result['predictions'].map<MySuggestion>((p) {
      // Package everything useful from API json
      final mainText = p['structured_formatting']?['main_text'];
      final secondaryText = p['structured_formatting']?['secondary_text'];
      final terms =
          p['terms'].map<String>((term) => term['value'] as String).toList();
      final types = p['types'].map<String>((atype) => atype as String).toList();

      return MySuggestion(p['place_id'], p['description'],
          mainText: mainText,
          secondaryText: secondaryText,
          terms: terms,
          types: types);
    }).toList();
  }

  getPlace(index, description) async {
    _controller.text = description;
    setState(() {
      _placeList.clear();
    });

    myPlace = await getPlaceDetailFromId(suggestions[index].placeId);
    pais.text = myPlace!.country!;
    estado.text = myPlace!.state!;
    ciudad.text = myPlace!.city!;
    vicinity.text = myPlace!.vicinity!;
    street.text = myPlace!.name!;
    cp.text = myPlace!.zipCode!;
    print("im in $myPlace");
  }

  Future<MyPlace> getPlaceDetailFromId(String placeId) async {
    // if you want to get the details of the selected place by place_id
    // final Map<String, dynamic> parameters = <String, dynamic>{
    //   'place_id': placeId,
    //   'fields': 'name,formatted_address,address_component,geometry',
    //   'key': PLACES_API_KEY,
    //   'sessiontoken': _sessionToken
    // };
    String baseURL =
        'https://proxy.cors.sh/https://maps.googleapis.com/maps/api/place/details/json';
    String request =
        '$baseURL?place_id=$placeId&fields=name%2Cformatted_address%2Caddress_component%2Cgeometry&key=$PLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(
      Uri.parse(request),
      headers: <String, String>{
        'x-cors-api-key': 'temp_38d3f85e8f9303c1da6c5ce747ad8269'
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;

        // build result
        final place = MyPlace();

        place.formattedAddress = result['result']['formatted_address'];
        place.name = result['result']['name'];
        place.lat = result['result']['geometry']['location']['lat'] as double;
        place.lng = result['result']['geometry']['location']['lng'] as double;

        for (var component in components) {
          final List type = component['types'];
          if (type.contains('street_address')) {
            place.streetAddress = component['long_name'];
          }
          if (type.contains('street_number')) {
            place.streetNumber = component['long_name'];
          }
          if (type.contains('route')) {
            place.street = component['long_name'];
            place.streetShort = component['short_name'];
          }
          if (type.contains('sublocality') ||
              type.contains('sublocality_level_1')) {
            place.vicinity = component['long_name'];
          }
          if (type.contains('locality')) {
            place.city = component['long_name'];
          }
          if (type.contains('administrative_area_level_2')) {
            place.county = component['long_name'];
          }
          if (type.contains('administrative_area_level_1')) {
            place.state = component['long_name'];
            place.stateShort = component['short_name'];
          }
          if (type.contains('country')) {
            place.country = component['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = component['long_name'];
          }
          if (type.contains('postal_code_suffix')) {
            place.zipCodeSuffix = component['long_name'];
          }
        }

        place.zipCodePlus4 ??=
            '${place.zipCode}${place.zipCodeSuffix != null ? '-${place.zipCodeSuffix}' : ''}';
        if (place.streetNumber != null) {
          place.streetAddress ??= '${place.streetNumber} ${place.streetShort}';
          place.formattedAddress ??=
              '${place.streetNumber} ${place.streetShort}, ${place.city}, ${place.stateShort} ${place.zipCode}';
          place.formattedAddressZipPlus4 ??=
              '${place.streetNumber} ${place.streetShort}, ${place.city}, ${place.stateShort} ${place.zipCodePlus4}';
        }
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Widget fieldSearchPlace() {
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              getSuggestion(value);
            },
            style: fieldStyle,
            decoration: InputDecoration(
                labelStyle: fieldStyle,
                labelText: "Search your location here",
                focusColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      street.clear();
                      pais.clear();
                      ciudad.clear();
                      estado.clear();
                      cp.clear();
                      vicinity.clear();
                      _placeList.clear();
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                )),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 60),
          alignment: Alignment.bottomCenter,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => getPlace(index, _placeList[index]["description"]),
                child: ListTile(
                  title:
                      Text(_placeList[index]["description"], style: fieldStyle),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

Widget fieldCustomer(controller, text, keyboardtype, filter, width) {
  return SizedBox(
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "* $text:",
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: width,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$text is required';
                }
                return null;
              },
              keyboardType: keyboardtype,
              controller: controller,
              inputFormatters: [filter],
              style: fieldStyle,
              decoration: InputDecoration(
                  hintStyle: hintStyle,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.redAccent),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.redAccent),
                  )),
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    ),
  );
}

Widget fieldAdress(controller, text, keyboardtype, filter) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: SizedBox(
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$text is required';
              }
              return null;
            },
            keyboardType: keyboardtype,
            controller: controller,
            inputFormatters: [filter],
            style: fieldStyle,
            decoration: InputDecoration(
                labelStyle: fieldStyle,
                labelText: "* $text",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                )),
            onChanged: (value) {},
          ),
        ),
      ),
    ],
  );
}
