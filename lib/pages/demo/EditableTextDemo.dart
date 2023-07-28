

import 'package:flutter/material.dart';

class EditableTextDemo extends StatefulWidget {

  EditableTextDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _EditableTextDemoState createState() => _EditableTextDemoState();
}

class _EditableTextDemoState extends State<EditableTextDemo> {

  // EditableText

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

}