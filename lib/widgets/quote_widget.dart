import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../model/Quote.dart';
import '../database/database_helper.dart';

class QuoteWidget extends StatefulWidget {
  final int id;
  final String text;
  final String author;
  QuoteWidget(this.text, this.author, this.id);

  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    MediaQueryData queryData = MediaQuery.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: queryData.size.width,
        height: queryData.size.height,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 30, color: Colors.indigo),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.author,
              style: TextStyle(fontSize: 23, color: Colors.black87),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share('${widget.text}\n${widget.author}');
                    }),
                IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Quote q = Quote(
                          quoteId: widget.id,
                          quoteText: widget.text,
                          quoteAuthor: widget.author);
                      dbHelper.saveQuote(q);
                      final snackBar = SnackBar(
                        content: Text(
                          'Added to favorites',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        backgroundColor: Colors.black,
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
