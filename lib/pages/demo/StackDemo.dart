import 'package:flutter/material.dart';

class StackDemo extends StatefulWidget {

  final String? title;

  StackDemo({ Key? key, this.title}) : super(key: key);


  @override
  _StackDemoState createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildSection(),
    );
  }

  _buildSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(10),
            color: Colors.green,
            child: Container(
              color: Colors.yellow,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            // bottom: 80,
            // left: 80,
            child: Container(
              // decoration: BoxDecoration(
              //   color: Colors.red,
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: Material(
                child: Text('99+',),
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}