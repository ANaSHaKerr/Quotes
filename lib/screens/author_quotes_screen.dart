import 'package:flutter/material.dart';

import '../repositories/quote_app_client.dart';
import '../model/quotes_list.dart';

class AuthorQuotesScreen extends StatefulWidget {
  static const roueName = '/AuthorQuotesScreen';
  final String author;
  final String permalink;
  AuthorQuotesScreen(this.author, this.permalink);
  @override
  _AuthorQuotesScreenState createState() => _AuthorQuotesScreenState();
}

class _AuthorQuotesScreenState extends State<AuthorQuotesScreen> {
  Future<List<Quote>> futureQuotes;
  @override
  void initState() {
    super.initState();
    final QuoteApiClient client = QuoteApiClient();
    futureQuotes = client.fetchQuotesFromAuthor(widget.permalink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.author),
        ),
        body: FutureBuilder<List<Quote>>(
            future: futureQuotes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Quote> listQuotes = snapshot.data;
                //print(listQuotes);
                return ListView.builder(
                    itemCount: listQuotes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            listQuotes[index].quoteText,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Text(
                            listQuotes[index].quoteAuthor,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
