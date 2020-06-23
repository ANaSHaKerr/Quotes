import 'package:flutter/material.dart';
import 'package:quotesapp/widgets/read_quote_button.dart';

import '../repositories/quote_app_client.dart';
import '../model/models.dart';
import '../database/database_helper.dart';

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
  var dbHelper;
  @override
  void initState() {
    super.initState();
    final QuoteApiClient client = QuoteApiClient();
    futureQuotes = client.fetchQuotesFromAuthor(widget.permalink);
    dbHelper = DatabaseHelper();
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ReadQuoteButton(listQuotes[index].quoteText),
                              IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    Quote q = Quote(
                                        quoteId: listQuotes[index].quoteId,
                                        quoteText: listQuotes[index].quoteText,
                                        quoteAuthor:
                                            listQuotes[index].quoteAuthor);
                                    dbHelper.saveQuote(q);
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Added to favorites',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      backgroundColor: Colors.black,
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }),
                            ],
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
