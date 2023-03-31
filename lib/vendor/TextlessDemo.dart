import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class TextlessDemo extends StatefulWidget {

  final String? title;
  const TextlessDemo({Key? key, this.title}) : super(key: key);

  @override
  _TextlessDemoState createState() => _TextlessDemoState();
}

class _TextlessDemoState extends State<TextlessDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        title: "TextLess".toUpperCase().h5.letterSpacing(15).light,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // "Headline1".h1.overflowFade,
            "Headline2".h2.overflowFade,
            "Headline3".h3,
            "Headline4".h4,
            "Headline5".h5,
            "Headline6".h6,
            "Subtitle1".s1,
            "Subtitle1".s2,
            "BodyText1".b1,
            "BodyText2".style(TextStyle(color: Colors.red)),
            "Button".btn,
            "Caption".cap,
            "Overline".ol,
          ],
        ),
      ),
    );
  }
}
