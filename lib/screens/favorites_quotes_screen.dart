import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                        color: Theme.of(context).errorColor,
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
                        //fetchDatafromTable();
//                          final removedSnackBar = SnackBar(
//                            backgroundColor: Colors.black,
//                            content: Text(
//                              'Removed from Favorites',
//                              style: TextStyle(
//                                  color: Colors.white, fontSize: 15.0),
//                            ),
//                          );
//                          Scaffold.of(context).showSnackBar(removedSnackBar);
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
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            trailing:
                                ReadQuoteButton(snapshot.data[index].quoteText),
                            title: Text(
                              snapshot.data[index].quoteText,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                snapshot.data[index].quoteAuthor,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
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
        });
  }
}
