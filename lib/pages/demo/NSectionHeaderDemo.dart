import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';

class NSectionHeaderDemo extends StatefulWidget {
  NSectionHeaderDemo({super.key, this.title});

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
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
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
            NSectionBox(
              title: "NSectionHeader - h1",
              style: TextStyle().h1,
              child: SizedBox(),
            ),
            NSectionBox(
              title: "NSectionHeader - h2",
              style: TextStyle().h2,
              child: SizedBox(),
            ),
            NSectionBox(
              title: "NSectionHeader - h3",
              style: TextStyle().h3,
              child: SizedBox(),
            ),
            NSectionBox(
              title: "NSectionHeader - h4",
              style: TextStyle().h4,
              child: SizedBox(),
            ),
            NSectionBox(
              title: "NSectionHeader - h5",
              style: TextStyle().h5,
              child: SizedBox(),
            ),
            NSectionBox(
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
