import '../model/quote.dart';

class QuotesList {
  final List<Quote> quotes;
  QuotesList(this.quotes);

  factory QuotesList.fromJson(Map<String, dynamic> json) {
    var list = json['quotes'] as List;
    List<Quote> quotesList = list.map((e) => Quote.fromJson(e)).toList();
    return QuotesList(quotesList);
  }
}
