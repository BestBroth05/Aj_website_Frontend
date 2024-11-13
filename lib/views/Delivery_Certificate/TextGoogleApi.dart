import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/Places.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import 'adminClases/Suggestion.dart';
import 'widgets/Texts.dart';

class GoogleMapSearchPlacesApi extends StatefulWidget {
  const GoogleMapSearchPlacesApi({Key? key}) : super(key: key);

  @override
  _GoogleMapSearchPlacesApiState createState() =>
      _GoogleMapSearchPlacesApiState();
}

class _GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {
  final _controller = TextEditingController();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];
  List<MySuggestion> suggestions = [];
  String PLACES_API_KEY = "AIzaSyCH7w3W_3lumfjO4FtZAU_FOTSWBXVZnMw";
  MyPlace? myPlace;

  @override
  void initState() {
    super.initState();
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
    myPlaceGlobal = myPlace;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              getSuggestion(value);
            },
            decoration: InputDecoration(
                hintStyle: fieldStyle,
                hintText: "Search your location here",
                focusColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    _controller.clear();
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
        Expanded(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => getPlace(index, _placeList[index]["description"]),
                child: ListTile(
                  title: Text(_placeList[index]["description"]),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
