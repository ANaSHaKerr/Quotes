import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/author_quotes_screen.dart';
import '../model/models.dart';
import '../repositories/quote_app_client.dart';

class AuthorsScreen extends StatefulWidget {
  @override
  _AuthorsScreenState createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  Future<List<Author>> futureAuthors;
  List<Author> listAuthors;
  List<Author> searchResult;
  Future loadData() async {
    final QuoteApiClient client = new QuoteApiClient();
    futureAuthors = client.fetchAuthors().then((value) {
      setState(() {
        listAuthors = value;
        //print(listAuthors);
      });
      return listAuthors;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _filterAuthors(value) {
    List<Author> result = searchResult
        .where((element) =>
            element.name.toLowerCase().contains(value.toString().toLowerCase()))
        .toList();
    //print(result.where((i) => i.name.startsWith(value)).toList());
    setState(() {
      listAuthors = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: FutureBuilder<List<Author>>(
          future: futureAuthors,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //listAuthors = snapshot.data;
              searchResult = snapshot.data;
              //print(searchResult);
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      //style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,color: Colors.white,),
                          hintText: 'Search',
                          hintStyle:  GoogleFonts.aclonica(
                          fontSize: 20.0, color: Colors.grey),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width:0.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width:0.0),
                        ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),),
                      onChanged: (value) {
                        _filterAuthors(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: listAuthors.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuthorQuotesScreen(
                                          listAuthors[index].name,
                                          listAuthors[index].permalink)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    listAuthors[index].name,
                                    style: GoogleFonts.courgette(
                                        fontSize: 18, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),

                                ),
                                subtitle: Divider(color: Colors.grey,thickness: 1,),
                              ),
                            )
                          );
                        }),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
