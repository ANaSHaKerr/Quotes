class Quote {
  final String author;
  final String quoteText;
  final String quoteDate;

  const Quote({this.author, this.quoteText, this.quoteDate});

  static Quote fromJson(dynamic json) {
    return Quote(
        author: json['quote']['author'],
        quoteText: json['quote']['body'],
        quoteDate: json['qotd_date']);
  }
}
