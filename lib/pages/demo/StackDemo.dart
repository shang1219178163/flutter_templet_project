import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class StackDemo extends StatefulWidget {
  final String? title;

  const StackDemo({Key? key, this.title}) : super(key: key);

  @override
  _StackDemoState createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        children: [
          _buildSection(),
          buildSection1(),
        ],
      ),
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
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                child: Text(
                  '99+',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildSection1() {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 150, height: 150, color: Colors.yellow),
            Container(width: 150, height: 28, color: Colors.transparent),
          ],
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: FloatingActionButton(
            onPressed: () {
              debugPrint('FAB tapped!');
            },
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.add),
          ),
        ),
      ],
    ).toColoredBox();
  }
}
