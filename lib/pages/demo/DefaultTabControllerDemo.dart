import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:tuple/tuple.dart';

class DefaultTabControllerDemo extends StatefulWidget {
  const DefaultTabControllerDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DefaultTabControllerDemoState createState() =>
      _DefaultTabControllerDemoState();
}

class _DefaultTabControllerDemoState extends State<DefaultTabControllerDemo>
    with AutomaticKeepAliveClientMixin {
  var initialIndex = 0;

  var items = <Tuple2<Tab, Widget>>[];

  @override
  void initState() {
    items = <Tuple2<Tab, Widget>>[
      Tuple2(
        Tab(icon: Icon(Icons.directions_railway)),
        _buildPage(),
      ),
      Tuple2(
        Tab(icon: Icon(Icons.directions_car)),
        _buildPage1(),
      ),
      Tuple2(
        Tab(icon: Icon(Icons.directions_bus)),
        _buildPage2(),
      ),
      Tuple2(
        Tab(icon: Icon(Icons.directions_bike)),
        _buildPage3(),
      ),
      Tuple2(
        Tab(icon: Icon(Icons.directions_boat)),
        _buildPage4(),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      home: DefaultTabController(
        initialIndex: initialIndex,
        length: items.length,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            bottom: TabBar(
              tabs: items.map((e) => e.item1).toList(),
            ),
            title: Text('$widget'),
          ),
          body: TabBarView(
            children: items.map((e) => e.item2).toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _buildPage() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                width: double.infinity,
                color: ColorExt.random,
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    ElevatedButton(
                        onPressed: onPressed, child: Text("Iterable")),
                  ],
                ),
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  _buildPage1() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                color: ColorExt.random,
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  _buildPage2() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                color: ColorExt.random,
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  _buildPage3() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                color: ColorExt.random,
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  _buildPage4() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                color: ColorExt.random,
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  onPressed() {
    var nums = <int>[1, 2, 3, 4, 5];
    final sum = nums.reduce((pre, e) => pre + e);

    final join = nums.fold("", (prev, int e) => "$prev $e");

    debugPrint("sum: $sum");
    debugPrint("join: $join");
  }
}
