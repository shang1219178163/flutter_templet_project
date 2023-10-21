

import 'package:flutter/material.dart';

class GlowingOverscrollIndicatorDemo extends StatefulWidget {

  GlowingOverscrollIndicatorDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  State<GlowingOverscrollIndicatorDemo> createState() => _GlowingOverscrollIndicatorDemoState();
}

class _GlowingOverscrollIndicatorDemoState extends State<GlowingOverscrollIndicatorDemo> {

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
    // return buildPage1();
    return buildPage2();
  }

  Widget buildPage1() {
    double top = MediaQuery.of(context).padding.top;
    final leadingPaintOffset = top + AppBar().preferredSize.height;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification notification) {
        if (notification.leading) {
          notification.paintOffset = leadingPaintOffset;
        }
        return false;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(title: Text('Custom PaintOffset')),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.amberAccent,
              height: 100,
              child: const Center(child: Text('Glow all day!')),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              color: Colors.green,
                child: FlutterLogo()
            )
          ),
        ],
      ),
    );
  }


  Widget buildPage2() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return const <Widget>[
          SliverAppBar(title: Text('Custom NestedScrollViews')),
        ];
      },
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: Colors.amberAccent,
              height: 100,
              child: const Center(child: Text('Glow all day!')),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              color: Colors.green,
              child: FlutterLogo()
            )
          ),
        ],
      ),
    );
  }
}

