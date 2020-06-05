import 'package:flutter/material.dart';

class QuoteWidget extends StatelessWidget {
  final String text;
  final String author;
  QuoteWidget(this.text, this.author);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            text,
            style: TextStyle(fontSize: 30, color: Colors.indigo),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          author,
          style: TextStyle(fontSize: 23, color: Colors.black87),
        )
      ],
    );
  }
}
