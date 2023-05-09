

import 'package:flutter/material.dart';

class TextFieldColorChangeDemo extends StatefulWidget {

  TextFieldColorChangeDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _TextFieldColorChangeDemoState createState() => _TextFieldColorChangeDemoState();
}

class _TextFieldColorChangeDemoState extends State<TextFieldColorChangeDemo> {
  late final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getAppBarBackgroundColor(),
        title: Text('Changing Colors'),
      ),
      body: Container(
          color: _getContainerBackgroundColor(),
          padding: EdgeInsets.all(40.0),
          child: TextField(
            style: TextStyle(color: _getInputTextColor()),
            focusNode: _focusNode,
              decoration: InputDecoration(
            // focusColor: Colors.blue,
            filled: true,
            // fillColor: bgColor,
            )
          )
      ),
    );
  }

  Color _getContainerBackgroundColor() {
    return _focusNode.hasFocus ? Colors.blueGrey : Colors.white;
  }

  Color _getAppBarBackgroundColor() {
    return _focusNode.hasFocus ? Colors.green : Colors.red;
  }

  Color _getInputTextColor() {
    return _focusNode.hasFocus ? Colors.white : Colors.pink;
  }
}