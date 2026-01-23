import 'package:flutter/material.dart';

class TrackingScrollDemo extends StatefulWidget {
  const TrackingScrollDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TrackingScrollDemo> createState() => _TrackingScrollDemoState();
}

class _TrackingScrollDemoState extends State<TrackingScrollDemo> {
  final trackingScrollController = TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildPageView(),
    );
  }

  ///共享 ScrollController 可以同步列表滚动位置
  buildPageView() {
    return PageView(
      scrollDirection: Axis.horizontal,
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
