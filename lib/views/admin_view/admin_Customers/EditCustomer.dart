// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_places_autocomplete_widgets/address_autocomplete_widgets.dart';
import 'package:guadalajarav2/views/admin_view/AdminWidgets/Title.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/Controllers/DAO.dart';
import '../../../utils/colors.dart';
import '../../Delivery_Certificate/adminClases/Places.dart';
import '../../Delivery_Certificate/adminClases/Suggestion.dart';
import '../../Delivery_Certificate/widgets/customCircleAvatar.dart';
import '../../Delivery_Certificate/adminClases/CustomerClass.dart';
import '../admin_DeliverCertificate/LoadingData.dart';
import '../../Delivery_Certificate/widgets/Popups.dart';
import '../../Delivery_Certificate/widgets/Texts.dart';
import 'CustomersView.dart';
import 'package:http/http.dart' as http;

class EditCustomer extends StatefulWidget {
  int id_customer;
  EditCustomer({super.key, required this.id_customer});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  bool isAllData = false;
  TextEditingController name = TextEditingController();
  TextEditingController rfc = TextEditingController();
  TextEditingController contactPerson = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController lada = TextEditingController();
  TextEditingController pais = TextEditingController();
  TextEditingController estado = TextEditingController();
  TextEditingController ciudad = TextEditingController();
  TextEditingController vicinity = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController cp = TextEditingController();
  String selcFile = "";
  Uint8List? selectedImageInBytes;
  final _formKeyCustomer = GlobalKey<FormState>();
  List<CustomersClass> customers = [];
  bool isPushedEditButon = false;
  Color colorButon = Colors.teal;
  final _controller = TextEditingController();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];
  List<MySuggestion> suggestions = [];
  String PLACES_API_KEY = "AIzaSyCH7w3W_3lumfjO4FtZAU_FOTSWBXVZnMw";
  MyPlace? myPlace;

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  getCustomers() async {
    List<CustomersClass> customers1 =
        await DataAccessObject.selectCustomer(widget.id_customer);
    setState(() {
      name.text = customers1[0].name!;
      email.text = customers1[0].email!;
      rfc.text = customers1[0].rfc!;
      contactPerson.text = customers1[0].contact!;
      phone.text = customers1[0].phone!;
      lada.text = customers1[0].lada.toString();
      pais.text = customers1[0].country!;
      estado.text = customers1[0].state!;
      ciudad.text = customers1[0].city!;
      List separateStreet = customers1[0].street!.split(',');
      street.text = separateStreet[0];
      vicinity.text = separateStreet[1];
      cp.text = customers1[0].cp!.toString();
      selcFile = "si hay prro";
      selectedImageInBytes = _convertListToInt(customers1[0].logo!);
      customers = customers1;
    });
  }

  Uint8List _convertListToInt(String input) {
    final reg = RegExp(r"([0-9]+|\d+)");
    final pieces = reg.allMatches(input);
    final result = pieces.map((e) => int.parse(e.group(0).toString())).toList();

    List<int> example = result;

    return Uint8List.fromList(example);
  }

  @override
  Widget build(BuildContext context) {
    return customers.isEmpty
        ? LoadingData()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: teal.add(black, 0.3),
              title: TitleH1(context, "Edit Customer"),
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
                    key: _formKeyCustomer,
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              fieldCustomer(
                                  name,
                                  "Name",
                                  TextInputType.text,
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  400),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "* Logo:",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  imageWidget()
                                ],
                              )
                            ],
                          ),
                        ),
                        fieldCustomer(
                          rfc,
                          "RFC",
                          TextInputType.text,
                          FilteringTextInputFormatter.singleLineFormatter,
                          MediaQuery.of(context).size.width,
                        ),
                        fieldCustomer(
                          contactPerson,
                          "Contact person",
                          TextInputType.text,
                          FilteringTextInputFormatter.singleLineFormatter,
                          MediaQuery.of(context).size.width,
                        ),
                        fieldCustomer(
                          email,
                          "Email",
                          TextInputType.emailAddress,
                          FilteringTextInputFormatter.singleLineFormatter,
                          MediaQuery.of(context).size.width,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            fieldCustomer(
                              lada,
                              "Key code",
                              TextInputType.phone,
                              FilteringTextInputFormatter.digitsOnly,
                              100,
                            ),
                            const SizedBox(width: 10),
                            fieldCustomer(
                              phone,
                              "Phone",
                              TextInputType.phone,
                              FilteringTextInputFormatter.digitsOnly,
                              (MediaQuery.of(context).size.width - 310),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "* Address:",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
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
                        buttonAddCustomer(),
                        SizedBox(height: 25)
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

  Widget buttonAddCustomer() {
    return Container(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              maximumSize: Size(150, 75),
              backgroundColor: colorButon,
              foregroundColor: Colors.white),
          onPressed: () {
            if (isPushedEditButon) {
              //Nothing to do
            } else {
              updateCustomer();
              setState(() {
                colorButon = Colors.grey;
                isPushedEditButon = true;
              });
            }
          },
          child: Text(
            'Edit',
            style: buttonAdd,
          )),
    );
  }

  Widget imageWidget() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(60, 60),
          backgroundColor: Colors.grey[700],
          shape: const CircleBorder(),
        ),
        child: selcFile.isEmpty
            ? const Icon(
                Icons.camera_alt,
                color: Colors.white,
              )
            : CustomCicleAvatar(selectedImageInBytes),
        onPressed: () => getIamge());
  }

  Future getIamge() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    if (fileResult != null) {
      setState(() {
        selcFile = fileResult.files.first.name;
        selectedImageInBytes = fileResult.files.first.bytes;
      });
    }
  }

  updateCustomer() async {
    if (_formKeyCustomer.currentState!.validate()) {
      int result = await DataAccessObject.updateCustomer(
          widget.id_customer,
          name.text,
          email.text,
          rfc.text,
          contactPerson.text,
          phone.text,
          lada.text,
          pais.text,
          estado.text,
          ciudad.text,
          int.parse(cp.text),
          "${street.text},${vicinity.text}",
          selectedImageInBytes.toString());
      if (result == 200) {
        succesfullyPopUp(context, "Succesfully edited");
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const CustomersView()));
        });
      } else {
        wrongPopup(context, "Something went wrong");
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      }
    } else {
      print('error');
    }
  }

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
  return Column(
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
            ),
            onChanged: (value) {},
          ),
        ),
      ),
    ],
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
            ),
            onChanged: (value) {},
          ),
        ),
      ),
    ],
  );
}
