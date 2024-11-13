import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guadalajarav2/enums/digikey_filters.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

String get digikeyAuthAddress =>
    'https://api.digikey.com/v1/oauth2/authorize' +
    '?response_type=code&client_id=$_clientId&redirect_uri=' +
    'http%3A%2F%2Fwww.aj-electronic-design.com%2Fstatic.html';

String _digikeyCode = '';
String get _clientId => 'wzP7you1ibs7wWBXmxozHmyyJyFnCWiE';
String get _clientSecret => 'lGJ6WyMXuEt3oMXX';
const String _grantType = 'authorization_code';
const String _redirectUri = 'http://www.aj-electronic-design.com/static.html';
const String _accessTokenUrl = 'https://api.digikey.com/v1/oauth2/token';
const String _searchProductUrl = 'https://api.digikey.com/Search/v3/Products/';
const String _searchKeywordUrl =
    'https://api.digikey.com/Search/v3/Products/Keyword';

html.WindowBase? _popupWin;
Timer? refresher;
bool refreshTokenExpired = true;

Map<String, dynamic>? _accessData;

Future<bool> getOAuthToken() async {
  // Our current app URL
// Open window
  StreamSubscription<html.MessageEvent>? subscription;
  _popupWin = html.window.open(
    digikeyAuthAddress,
    "DigiKey Auth",
    "width=800, height=900, scrollbars=yes",
  );

  subscription = html.window.onMessage.listen((event) async {
    await windowListener(event);
    subscription!.cancel();
  });

  while (_popupWin != null && !(_popupWin!.closed!)) {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  return _digikeyCode.isNotEmpty;
}

Future<void> _getAccessToken() async {
  http.Response response = await http.post(Uri.parse(_accessTokenUrl), body: {
    'client_id': _clientId,
    'client_secret': _clientSecret,
    'code': _digikeyCode,
    'grant_type': _grantType,
    'redirect_uri': _redirectUri,
  });
  if (response.statusCode == 200) {
    refreshTokenExpired = false;
    _accessData = jsonDecode(response.body);
    refresher = Timer.periodic(
      Duration(seconds: _accessData!['expires_in']),
      (timer) async => await _refreshToken(),
    );
    Timer(
      Duration(seconds: _accessData!['refresh_token_expires_in']),
      refresher != null
          ? () async {
              refreshTokenExpired = true;
              refresher!.cancel();
              refresher = null;
            }
          : () async => await getOAuthToken(),
    );
  } else {
    _accessData = null;
    print(response.body);
  }
}

Future<void> _refreshToken() async {
  http.Response response = await http.post(Uri.parse(_accessTokenUrl), body: {
    'client_id': _clientId,
    'client_secret': _clientSecret,
    'refresh_token': _accessData!['refresh_token'],
    'grant_type': 'refresh_token',
    'redirect_uri': _redirectUri,
  });
  if (response.statusCode == 200) {
    print('refreshed token');
    _accessData = jsonDecode(response.body);
  } else {
    _accessData = null;
  }
}

Future<void> windowListener(event) async {
  /// If the event contains the token it means the user is authenticated.
  if (event.data.toString().contains('code=')) {
    _digikeyCode = _getCode(event.data);
    // print(_digikeyCode);
    await _getAccessToken();
    // print(_accessData);
    _popupWin!.close();
  } else {
    _digikeyCode = '';
    _popupWin!.close();
  }
}

String _getCode(String data) {
  /// Parse data into an Uri to extract the token easily.
  String values = data.split('?').toList()[1];
  Map<String, String> valuesMap = Map<String, String>.fromIterable(
    values.split('&'),
    key: (element) => element.split('=')[0],
    value: (element) => element.split('=')[1],
  );

  return valuesMap['code']!;
}

Future<Map<String, dynamic>?> searchInDigikey(String text) async {
  // print(_accessData);
  if (_accessData == null) {
    if (await getOAuthToken()) {
      return await searchInDigikey(text);
    } else {
      return null;
    }
  } else {
    http.Response response =
        await http.get(Uri.parse(_searchProductUrl + text), headers: {
      'Authorization': 'Bearer ' + _accessData!['access_token'],
      'X-DIGIKEY-Client-Id': _clientId,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      await _refreshToken();
      return await searchInDigikey(text);
    } else {
      // print('error ${response.body} ${response.headers['Retry-After']}');
    }
  }

  return null;

  // int i = 0;
  // while (i < 125) {
  //   _popupWin = html.window.open(
  //     'https://share.htn.app/htn-promocional/e72d760a8952d3ae95a15f40cf8f56d3',
  //     // 'https://share.htn.app/htn-promocional/51a62ca0b1205fd7144f29e468393531'
  //     "DigiKey Auth",
  //     "width=800, height=900, scrollbars=yes",
  //   );
  //   await Future.delayed(const Duration(seconds: 1));
  //   _popupWin!.close();
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   i += 1;
  // }
}

Future<List<Map<String, dynamic>>?> searchKeywordDigikey(
  BuildContext context,
  String text,
  List<Map<String, dynamic>> parametricfilters,
) async {
  if (_accessData == null) {
    if (await getOAuthToken()) {
      return await searchKeywordDigikey(context, text, parametricfilters);
    } else {
      openDialog(
        context,
        container: TimedDialog(
          text: 'Authorization failed',
        ),
      );
    }
  } else {
    try {
      http.Response response = await http.post(
        Uri.parse(_searchKeywordUrl),
        headers: {
          'Authorization': 'Bearer ' + _accessData!['access_token'],
          'X-DIGIKEY-Client-Id': _clientId,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "Keywords": "$text",
            "RecordCount": 50,
            "RecordStartPosition": 0,
            "Filters": {
              "ParametricFilters": parametricfilters,
            },
            "Sort": {
              "SortOption": "SortByQuantityAvailable",
              "Direction": "Ascending",
              "SortParameterId": 0
            },
            "RequestedQuantity": 0,
            "SearchOptions": ["ManufacturerPartSearch"],
            "ExcludeMarketPlaceProducts": true
          },
        ),
      );
      if (response.statusCode == 200) {
        return filterKeywordSearch(jsonDecode(response.body)['Products']);
      } else if (response.statusCode == 401) {
        await _refreshToken();
        return await searchKeywordDigikey(context, text, parametricfilters);
      } else {
        print('error ${response.body}');
        return null;
      }
    } on Exception catch (e) {
      print(e);
    }
  }
  return null;
}

List<Map<String, dynamic>> filterKeywordSearch(List<dynamic> parts) {
  List<Map<String, dynamic>> filtered = [];

  for (dynamic part in parts) {
    Map<String, dynamic> entry = (part as Map<dynamic, dynamic>)
        .map((key, value) => MapEntry<String, dynamic>(key.toString(), value));

    double? unitPrice;
    int i = 0;
    for (dynamic pricing in entry['StandardPricing']) {
      if (pricing['BreakQuantity'] == 1) {
        unitPrice = pricing['UnitPrice'];
        break;
      } else {
        entry['StandardPricing'].remove(i);
      }
      i += 1;
    }

    if (unitPrice != null) {
      filtered.add(entry);
    }
  }

  filtered.sort(
    ((a, b) => a['StandardPricing'][0]['UnitPrice'].compareTo(
          b['StandardPricing'][0]['UnitPrice'],
        )),
  );
  if (filtered.length > 2) {
    filtered = filtered.sublist(0, 2);
  }

  return filtered;
}

List<Map<String, dynamic>> getParametricFiltersFromPart(
    Map<String, dynamic> part) {
  String id = (part['Category'] as Map<String, dynamic>)['ValueId'];
  // print(id);

  DigikeyFilter? parameterId = categoryParameterId[int.parse(id)];

  if (parameterId == null) {
    return [];
  }

  List<int?> filters = parameterId.filtersId;

  List<Map<String, dynamic>> listParameters = [];

  for (Map<String, dynamic> parameter in part['Parameters']) {
    if (filters.contains(parameter['ParameterId'])) {
      listParameters.add({
        'ParameterId': parameter['ParameterId'],
        'ValueId': parameter['ValueId'],
      });
    }
  }

  return listParameters;
}

Future<Map<String, Map<String, dynamic>>> getSimilarPartsInDigikey(
  BuildContext context,
  Map<String, dynamic> part,
) async {
  // for (MapEntry<String, dynamic> entry in part.entries) {
  //   print(entry);
  // }
  List<Map<String, dynamic>> listParameters =
      getParametricFiltersFromPart(part);
  List<Map<String, dynamic>>? similarParts = await searchKeywordDigikey(
    context,
    part['Category']['Value'],
    listParameters,
  );

  Map<String, Map<String, dynamic>> mapParts = {};
  if (similarParts != null) {
    for (Map<String, dynamic> partMap in similarParts) {
      mapParts.putIfAbsent(partMap['ManufacturerPartNumber'], () => partMap);
    }
  }
  return mapParts;
}
