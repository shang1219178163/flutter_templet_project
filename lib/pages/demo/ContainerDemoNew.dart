import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class ContainerDemoNew extends StatefulWidget {
  const ContainerDemoNew({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ContainerDemoNew> createState() => _ContainerDemoNewState();
}

class _ContainerDemoNewState extends State<ContainerDemoNew> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var initialIndex = 0;

  late var items = <(Tab, Widget)>[
    (Tab(text: "选项1"), buildPage()),
    (Tab(text: "选项2"), buildPage1()),
    (Tab(text: "选项2"), buildPage2()),
  ];

  bool isSliver = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      initialIndex: initialIndex,
      length: items.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: items.map((e) => e.$1).toList(),
          ),
          title: Text('$widget'),
        ),
        body: TabBarView(
          children: items.map((e) => e.$2).toList(),
        ),
      ),
    );
  }

  Widget buildPage() {
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
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        debugPrint("onPressed");
                      },
                      child: Text("Iterable"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  Widget buildPage1() {
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

  Widget buildPage2() {
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
}
