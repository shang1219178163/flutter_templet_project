

import 'package:flutter/material.dart';

class PageBuilderDemo extends StatefulWidget {

  PageBuilderDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _PageBuilderDemoState createState() => _PageBuilderDemoState();
}

class _PageBuilderDemoState extends State<PageBuilderDemo> {

  final items = [
    "OpenUpwardsPageTransitionsBuilder",
    "ZoomPageTransitionsBuilder",
    "CupertinoPageTransitionsBuilder",
    "FadeUpwardsPageTransitionsBuilder",
  ];


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