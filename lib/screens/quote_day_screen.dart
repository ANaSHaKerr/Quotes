import 'package:flutter/material.dart';

import '../model/models.dart';
import '../widgets/quote_widget.dart';
import '../repositories/quote_app_client.dart';

class QuoteDayScreen extends StatefulWidget {
  @override
  _QuoteDayScreenState createState() => _QuoteDayScreenState();
}

class _QuoteDayScreenState extends State<QuoteDayScreen> {
  Future<Quote> quotefuture;

  @override
  void initState() {
    super.initState();
    final QuoteApiClient client = new QuoteApiClient();
    quotefuture = client.fetchQuoteDay();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
        future: quotefuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return QuoteWidget(snapshot.data.quoteText,
                snapshot.data.quoteAuthor, snapshot.data.quoteId);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
