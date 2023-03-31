import 'package:flutter/material.dart';

class SliverToolsDemo extends StatefulWidget {

  final String? title;

  const SliverToolsDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _SliverToolsDemoState createState() => _SliverToolsDemoState();
}

class _SliverToolsDemoState extends State<SliverToolsDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Text(arguments.toString())
    );
  }

}