import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import '../database/database_helper.dart';
import '../model/models.dart';
import '../widgets/read_quote_button.dart';

class FavoritesQuotesScreen extends StatefulWidget {
  @override
  _FavoritesQuotesScreenState createState() => _FavoritesQuotesScreenState();
}

class _FavoritesQuotesScreenState extends State<FavoritesQuotesScreen> {
  Future<List<Quote>> quotesList;
  var dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    fetchDatafromTable();
  }

  fetchDatafromTable() {
    setState(() {
      quotesList = dbHelper.fetchSavedQuotes();
    });
  }
  List colors = [ Color(0xff232441), Color(0xff232431), Colors.indigo[900], Colors.black45,Colors.deepPurple,Colors.grey[900]];
  Random random = new Random();

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: FutureBuilder(
          future: quotesList,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (builder, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        //Key(snapshot.data[index].quoteId),
                        background: Container(
                          color:Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          dbHelper.deleteQuoteFromFavorite(
                              snapshot.data[index].quoteId);
                        },
                        confirmDismiss: (direction) {
                          return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text(
                                        'Do you want to remove the quote from the favorites?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Yes'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);

                                        },
                                      )
                                    ],
                                  ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            elevation: 10,
                            color: Color(0xff232449),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              trailing:  Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.share,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Share.share('${snapshot.data[index].quoteText}\n${snapshot.data[index].quoteAuthor}');
                                      }),
                                  ReadQuoteButton(snapshot.data[index].quoteText,Colors.white),

                                ],
                              ),

                                title: Text(
                                snapshot.data[index].quoteText,
                                style:  GoogleFonts.aclonica(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                              subtitle:Padding(
                                padding: const EdgeInsets.only(top: 20.0,bottom: 5),
                                child: Text(
                                  snapshot.data[index].quoteAuthor,
                                  style: GoogleFonts.courgette(
                                      fontSize: 17.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              )


                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Text(
                    'No Data in the Favorites',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Failed to Load Favorites' + "${snapshot.error}"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
