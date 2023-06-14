import 'package:flutter/material.dart';

class ScrollControllerDemo extends StatefulWidget {

  const ScrollControllerDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ScrollControllerDemoState createState() => _ScrollControllerDemoState();
}

class _ScrollControllerDemoState extends State<ScrollControllerDemo> {

  final _trackingScrollController = TrackingScrollController();

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        // body: _buildSection(),
      body: _buildPageView(),
    );
  }

  ///共享 ScrollController 可以同步列表滚动位置
  _buildSection() {
    return PageView(
      children: <Widget>[
        ListView(
          controller: _trackingScrollController,
          children: _buildChildren(),
        ),
        ListView(
          controller: _trackingScrollController,
          children: _buildChildren(page: 1),
        ),
        ListView(
         controller: _trackingScrollController,
         children: _buildChildren(page: 2),
        ),
      ],
    );
  }

  _buildChildren({int page = 0, int count = 50}) {
    return List<Widget>.generate(count, (int i) => ListTile(leading: Text('page $page item $i'),)).toList();
  }

  _buildPageView() {
    return PageView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        ListView(
          controller: _trackingScrollController,
          children: buildChildren(page: 0, count: 20),
        ),
        ListView(
          controller: _trackingScrollController,
          children: buildChildren(page: 1, count: 20),
        ),
        ListView(
          controller: _trackingScrollController,
          children: buildChildren(page: 2, count: 20),
        ),
      ],
    );
  }

  List<Widget> buildChildren({required int page, required int count,}) {
    return List<Widget>.generate(count, (int i) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('page $page item $i'),
      );
    }).toList();
  }
}