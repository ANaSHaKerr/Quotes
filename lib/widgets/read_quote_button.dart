import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadQuoteButton extends StatefulWidget {
  final String text;
  ReadQuoteButton(this.text);
  @override
  _ReadQuoteButtonState createState() => _ReadQuoteButtonState();
}

class _ReadQuoteButtonState extends State<ReadQuoteButton> {
  static const platform = const MethodChannel('flutter.dev/awspolly');
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.volume_up),
        onPressed: () {
          readQuote(widget.text);
        });
  }

  void readQuote(String textQuote) async {
    try {
      await platform.invokeMethod('readQuote', {'textQuote': textQuote});
    } catch (e) {
      print(e);
    }
  }
}
