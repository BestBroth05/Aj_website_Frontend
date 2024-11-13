import 'dart:convert';

import 'package:http/http.dart' as http;

String _apiMouserAddress = 'https://api.mouser.com/api/V1/search';
String _apiKey = '7d84aab7-5040-4a23-b0c0-a071a713c14b';

Future<Map<String, dynamic>?> searchInMouser(String partNumber) async {
  http.Response response = await http.post(
    Uri.parse('$_apiMouserAddress/partnumber?apiKey=$_apiKey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "SearchByPartRequest": {
        "mouserPartNumber": "$partNumber",
        "partSearchOptions": ""
      }
    }),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody =
        jsonDecode(response.body) as Map<String, dynamic>;
    int results = responseBody['SearchResults']['NumberOfResult'];
    if (results < 1) {
      return null;
    } else {
      return responseBody['SearchResults']['Parts'][0];
    }
  } else {
    return null;
  }
}
