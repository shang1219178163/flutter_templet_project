import 'package:flutter/material.dart';

class ScrollControllerDemo extends StatefulWidget {
  const ScrollControllerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ScrollControllerDemoState createState() => _ScrollControllerDemoState();
}

class _ScrollControllerDemoState extends State<ScrollControllerDemo> {
  final trackingScrollController = TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildPageView(),
    );
  }

  ///共享 ScrollController 可以同步列表滚动位置
  buildPageView() {
    return PageView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        ListView(
          controller: trackingScrollController,
          children: buildChildren(page: 0, count: 20),
        ),
        ListView(
          controller: trackingScrollController,
          children: buildChildren(page: 1, count: 20),
        ),
        ListView(
          controller: trackingScrollController,
          children: buildChildren(page: 2, count: 20),
        ),
      ],
    );
  }

  buildChildren({int page = 0, int count = 20}) {
    return List<Widget>.generate(count, (i) {
      return ListTile(
        leading: Text('page $page item $i'),
      );
    }).toList();
  }
}
