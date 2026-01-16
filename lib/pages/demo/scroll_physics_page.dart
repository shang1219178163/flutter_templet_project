import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/scroll/scroll_physics/bottom_bouncing_scroll_physics.dart';
import 'package:flutter_templet_project/basicWidget/scroll/scroll_physics/no_top_over_scroll_physics.dart';
import 'package:flutter_templet_project/mixin/MyScrollPhysics.dart';

class ScrollPhysicsPage extends StatefulWidget {
  const ScrollPhysicsPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ScrollPhysicsPage> createState() => _ScrollPhysicsPageState();
}

class _ScrollPhysicsPageState extends State<ScrollPhysicsPage> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  late final items = [
    (k: "Bouncing", v: BouncingScrollPhysics()),
    (k: "Clamping", v: ClampingScrollPhysics()),
    (k: "NeverScrollable", v: NeverScrollableScrollPhysics()),
    (k: "AlwaysScrollable", v: AlwaysScrollableScrollPhysics()),
    (k: "PageView", v: PageScrollPhysics()),
    (k: "RangeMaintaining", v: RangeMaintainingScrollPhysics()),
    (k: "Carousel", v: CarouselScrollPhysics()),
    (k: "NoTopOver", v: NoTopOverScrollPhysics()),
    (k: "BottomBouncing", v: BottomBouncingScrollPhysics()),
    (k: "My", v: MyScrollPhysics()),
  ];

  ScrollPhysics get scrollPhysics => items[tabController.index].v;

  late final tabController = TabController(length: items.length, vsync: this);

  @override
  void didUpdateWidget(covariant ScrollPhysicsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        bottom: buildTabBar(),
      ),
      body: buildBody(),
    );
  }

  TabBar buildTabBar() {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      tabs: items.map((e) => Tab(text: e.k)).toList(),
      indicatorSize: TabBarIndicatorSize.label,
      // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
      onTap: (index) {
        setState(() {});
      },
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        controller: scrollController,
        physics: scrollPhysics,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text("item$i"),
          );
        },
        separatorBuilder: (_, i) {
          return Divider();
        },
        itemCount: 20,
      ),
    );
  }
}
