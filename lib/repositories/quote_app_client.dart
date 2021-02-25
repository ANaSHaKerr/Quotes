import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/models.dart';

class QuoteApiClient {
  static const _apiKey = "\"c8bc4101569d2c54f34055e1da45df0c\"";
  static const _baseUrl = "https://favqs.com/api/";
  static const Map<String, String> _headers = {
    "Authorization": "Token token=$_apiKey"
  };

  Future<Quote> fetchQuoteDay() async {
    final client = http.Client();
    final url = '$_baseUrl/qotd';
    final response = await client.get(url, headers: _headers);

    if (response.statusCode != 200) {
      throw new Exception('Failed to load Quote');
    }

    final json = jsonDecode(response.body);
    final quote = json['quote'];
    return Quote.fromJson(quote);
  }

  Future<List<Author>> fetchAuthors() async {
    final client = http.Client();
    final url = '$_baseUrl/typeahead';
    final response = await client.get(url, headers: _headers);
    if (response.statusCode != 200) {
      throw new Exception('Failed to load Quote');
    }

    final json = jsonDecode(response.body);
    print(response.body.toString());
    AuthorsList authorList = AuthorsList.fromJson(json);
    List<Author> list = authorList.authors;
    return list;
  }

  Future<List<Quote>> fetchQuotesFromAuthor(String author) async {
    final client = http.Client();
    final url = '$_baseUrl/quotes/?filter=$author&type=author';
    final response = await client.get(url, headers: _headers);
    if (response.statusCode != 200) {
      throw new Exception('Failed to load Quote');
    }

    final json = jsonDecode(response.body);
    //print(response.body.toString());
    QuotesList quotesList = QuotesList.fromJson(json);
    List<Quote> list = quotesList.quotes;
    return list;
  }
  Future<List<Quote>> fetchQuotesList() async {
    final client = http.Client();
    final url = '$_baseUrl/quotes';
    final response = await client.get(url, headers: _headers);
    if (response.statusCode != 200) {
      throw new Exception('Failed to load Quote');
    }

    final json = jsonDecode(response.body);
    //print(response.body.toString());
    QuotesList quotesList = QuotesList.fromJson(json);
    List<Quote> list = quotesList.quotes;
    return list;
  }
}
