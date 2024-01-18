import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NSectionHeader.dart';
import 'package:flutter_templet_project/extension/text_style_ext.dart';

class NSectionHeaderDemo extends StatefulWidget {

  NSectionHeaderDemo({
    super.key, 
    this.title
  });

  final String? title;

  @override
  State<NSectionHeaderDemo> createState() => _NSectionHeaderDemoState();
}

class _NSectionHeaderDemoState extends State<NSectionHeaderDemo> {

  final _scrollController = ScrollController();

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
          children: [
            NSectionHeader(
              title: "NSectionHeader - h1",
              style: TextStyle().h1,
              child: SizedBox(),
            ),
            NSectionHeader(
              title: "NSectionHeader - h2",
              style: TextStyle().h2,
              child: SizedBox(),
            ),
            NSectionHeader(
              title: "NSectionHeader - h3",
              style: TextStyle().h3,
              child: SizedBox(),
            ),
            NSectionHeader(
              title: "NSectionHeader - h4",
              style: TextStyle().h4,
              child: SizedBox(),
            ),
            NSectionHeader(
              title: "NSectionHeader - h5",
              style: TextStyle().h5,
              child: SizedBox(),
            ),
            NSectionHeader(
              title: "NSectionHeader - h6",
              style: TextStyle().h6,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
  
}