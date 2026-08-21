import 'package:flutter/material.dart';

class RotatedBoxDemo extends StatefulWidget {
  final String? title;

  const RotatedBoxDemo({Key? key, this.title}) : super(key: key);

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
