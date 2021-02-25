import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotesapp/repositories/quote_app_client.dart';
import 'package:quotesapp/widgets/read_quote_button.dart';
import '../database/database_helper.dart';
import '../model/models.dart';

class QuoteList extends StatefulWidget {

  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  Future<List<Quote>> futureQuotes;
  var dbHelper;
  @override
  void initState() {
    super.initState();
    final QuoteApiClient client = QuoteApiClient();
    futureQuotes = client.fetchQuotesList();
    dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,

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
                        elevation: 10,
                        color: Color(0xff232449),
                        child: ListTile(
                          title: Text(
                            listQuotes[index].quoteText,
                            style:  GoogleFonts.aclonica(
                                fontSize: 20.0, color: Colors.white),

                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ReadQuoteButton(listQuotes[index].quoteText,Colors.white),
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
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top:15.0,bottom: 10),
                            child: Text(
                              listQuotes[index].quoteAuthor,
                              style:  GoogleFonts.courgette(
                                  fontSize: 17.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),

                            ),
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
