import 'package:flutter/material.dart';

class SelectableTextDemo extends StatefulWidget {

  final String? title;

  const SelectableTextDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _SelectableTextDemoState createState() => _SelectableTextDemoState();
}

class _SelectableTextDemoState extends State<SelectableTextDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: SelectableText('Hello world! This is selectable Text',
          style: const TextStyle(fontSize: 22),
          onSelectionChanged: (selection, cause) {
            print(selection);
            print(cause);
          },
        ),
    );
  }

}