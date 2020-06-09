class Quote {
  String quoteAuthor;
  String quoteText;
  var quoteId;

  Quote({this.quoteId, this.quoteAuthor, this.quoteText});

  factory Quote.fromJson(dynamic json) {
    return Quote(
        quoteAuthor: json['quote']['author'],
        quoteText: json['quote']['body'],
        quoteId: json['quote']['id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': quoteId,
      'quote_text': quoteText,
      'quote_author': quoteAuthor,
    };
  }

  Quote.fromMap(Map<String, dynamic> map) {
    quoteId = map['id'];
    quoteText = map['quote_text'];
    quoteAuthor = map['quote_author'];
  }
}
