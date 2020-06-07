import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../model/Quote.dart';

class FavoritiesQuotesScreen extends StatefulWidget {
  @override
  _FavoritiesQuotesScreenState createState() => _FavoritiesQuotesScreenState();
}

class _FavoritiesQuotesScreenState extends State<FavoritiesQuotesScreen> {
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
                    return Card(
                      child: ListTile(
                        title: Text(
                          snapshot.data[index].quoteText,
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: 'quoteScript'),
                        ),
                        subtitle: Text(
                          snapshot.data[index].quoteAuthor,
                          style: TextStyle(
                              fontSize: 17.0, fontFamily: 'quoteScript'),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Colors.red,
                            onPressed: () {
                              dbHelper.deleteQuoteFromFavorite(
                                  snapshot.data[index].quoteId);
                              fetchDatafromTable();
                              final removedSnackBar = SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  'Removed from Favorites',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              );
                              Scaffold.of(context)
                                  .showSnackBar(removedSnackBar);
                            }),
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
