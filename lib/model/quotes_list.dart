class QuotesList {
  final List<Quote> quotes;
  QuotesList(this.quotes);

  factory QuotesList.fromJson(Map<String, dynamic> json) {
    var list = json['quotes'] as List;
    List<Quote> quotesList = list.map((e) => Quote.fromJson(e)).toList();
    return QuotesList(quotesList);
  }
}

class Quote {
  String quoteAuthor;
  String quoteText;
  var quoteId;

  Quote({this.quoteId, this.quoteAuthor, this.quoteText});

  factory Quote.fromJson(dynamic json) {
    return Quote(
        quoteAuthor: json['author'],
        quoteText: json['body'],
        quoteId: json['id']);
  }
}
