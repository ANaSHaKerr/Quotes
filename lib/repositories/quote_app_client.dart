import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../model/models.dart';

class QuoteApiClient {
  static const _apiKey = "\"c8bc4101569d2c54f34055e1da45df0c\"";
  static const _baseUrl = "https://favqs.com/api/";
  static const Map<String, String> _headers = {
    "Authorization": "Token token=$_apiKey"
  };

  Future<Quote> fetchQuoteDay() async {
    final client = new http.Client();
    final url = '$_baseUrl/qotd';
    final response = await client.get(url, headers: _headers);

    if (response.statusCode != 200) {
      throw new Exception('Failed to load Quote');
    }

    final json = jsonDecode(response.body);
    print(response.body.toString());
    return Quote.fromJson(json);
  }
}
