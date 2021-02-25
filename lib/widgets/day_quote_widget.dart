import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

import '../model/quote.dart';
import '../database/database_helper.dart';
import '../widgets/read_quote_button.dart';

class DayQuoteWidget extends StatefulWidget {
  final int id;
  final String text;
  final String author;
  DayQuoteWidget(this.text, this.author, this.id);

  @override
  _DayQuoteWidgetState createState() => _DayQuoteWidgetState();
}

class _DayQuoteWidgetState extends State<DayQuoteWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }
  List colors = [ Color(0xff232441), Color(0xff232431), Colors.indigo[900], Colors.black45,Colors.deepPurple,Colors.grey[900]];
  Random random = new Random();

  int index = 0;

  void changeIndex() {
    setState(() => index = random.nextInt(3));
  }
  IconData _icon = Icons.favorite_border;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Color(0xff232441),
      child: ListView(

        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              widget.text,
              style: GoogleFonts.courgette(
                fontSize: 40 ,
                color:Colors.white,
                fontStyle: FontStyle.italic,
                //fontWeight: FontWeight.bold
              )),
            ),
          //GoogleFonts.pacific
          //GoogleFonts.architectsDaughte
          //GoogleFonts.courgette
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.author,
                style: GoogleFonts.cairo(
                    fontSize: 23,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                    ),
              ),
            ),
          ),
          SizedBox(height: 70,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.share,
                    size: 32,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Share.share('${widget.text}\n${widget.author}');
                  }),
              IconButton(
                  icon: Icon(
                    _icon,
                    color: Colors.red,
                    size: 32,
                  ),
                  onPressed: () {
                  setState(() {
                    _icon = Icons.favorite;
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
                  });
                  }),
              ReadQuoteButton(widget.text,Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
