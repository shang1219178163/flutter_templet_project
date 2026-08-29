import 'package:flutter/material.dart';

class RotatedBoxDemo extends StatefulWidget {

  const RotatedBoxDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _RotatedBoxDemoState createState() => _RotatedBoxDemoState();
}

class _RotatedBoxDemoState extends State<RotatedBoxDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: RotatedBox(
        quarterTurns: 3,
        child: const Text('Hello World!'),
      ),
    );
  }
}
