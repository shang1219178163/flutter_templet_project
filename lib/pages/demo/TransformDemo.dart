import 'package:flutter/material.dart';
import 'dart:math' as math;

class TransformDemo extends StatefulWidget {

  final String? title;

  const TransformDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _TransformDemoState createState() => _TransformDemoState();
}

class _TransformDemoState extends State<TransformDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  _buildBody() {
    return  Container(
      color: Colors.black,
      child: Transform(
        alignment: Alignment.topRight,
        transform: Matrix4.skewY(0.3)..rotateZ(-math.pi / 12.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color(0xFFE8581C),
          child: const Text('Apartment for rent!'),
        ),
      ),
    );
  }
}