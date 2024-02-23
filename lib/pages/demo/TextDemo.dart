

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

/// TextStyle 研究
class TextDemo extends StatefulWidget {

  TextDemo({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<TextDemo> createState() => _TextDemoState();
}

class _TextDemoState extends State<TextDemo> {

  final _scrollController = ScrollController();

  final decorations = [
    TextDecoration.none,
    TextDecoration.underline,
    TextDecoration.overline,
    TextDecoration.lineThrough,
  ];


  @override
  Widget build(BuildContext context) {
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
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...decorations.map((e) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text("$e",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    decoration: e,
                    backgroundColor: Colors.blue.withOpacity(0.12),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

}