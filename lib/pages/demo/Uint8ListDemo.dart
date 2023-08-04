


import 'dart:typed_data';

import 'package:flutter/material.dart';

class Uint8ListDemo extends StatefulWidget {

  Uint8ListDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _Uint8ListDemoState createState() => _Uint8ListDemoState();
}

class _Uint8ListDemoState extends State<Uint8ListDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: Text(arguments.toString())
    );
  }

  onPress() {
    Uint8List bytes = Uint8List.fromList([63, 158, 184, 82]);
    List<int> floatList = bytes.buffer.asInt8List();
    debugPrint(floatList.toString());
  }
}