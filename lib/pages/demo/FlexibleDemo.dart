import 'package:flutter/material.dart';

class FlexibleDemo extends StatefulWidget {
  const FlexibleDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FlexibleDemoState createState() => _FlexibleDemoState();
}

class _FlexibleDemoState extends State<FlexibleDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      // body: _buildSection(),
      body: _buildSection1(),
    );
  }

  _buildSection() {
    return Column(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            color: Colors.pink,
            child: Text('Flexible'),
          ),
        ),
        Container(
          height: 50,
          color: Colors.orange,
        ),
        Expanded(
          child: Container(
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  _buildSection1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.red,
            child: Text('Flexible 1/6'),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.green,
            child: Text('Flexible 2/6'),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.blue,
            child: Text('Flexible 3/6'),
          ),
        ),
      ],
    );
  }
}
