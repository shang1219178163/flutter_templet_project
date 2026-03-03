import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_overlay_manager.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:tuple/tuple.dart';

///  Overlay 动画
class OverlayAnimationDemo extends StatefulWidget {
  const OverlayAnimationDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<OverlayAnimationDemo> createState() => _OverlayAnimationDemoState();
}

class _OverlayAnimationDemoState extends State<OverlayAnimationDemo> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var initialIndex = 0;

  late var items = <Tuple2<Tab, Widget>>[];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    items = <Tuple2<Tab, Widget>>[
      Tuple2(Tab(text: "选项1"), buildPage()),
      Tuple2(Tab(text: "选项2"), buildPage1()),
      Tuple2(Tab(text: "选项2"), buildPage2()),
    ];

    return DefaultTabController(
      initialIndex: initialIndex,
      length: items.length,
      child: Scaffold(
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
                        NOverlayManager.showAnimation(
                          child: Container(
                            height: 500,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorExt.random,
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                debugPrint("showAnimation");
                              },
                              child: Text("showAnimation"),
                            ),
                          ),
                        );
                      },
                      child: Text("NOverlayManager"),
                    ),
                  ],
                ),
              ),
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

  void onPressed() {
    debugPrint("onPressed");
  }
}
