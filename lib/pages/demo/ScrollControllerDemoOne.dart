import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class ScrollControllerDemoOne extends StatefulWidget {
  const ScrollControllerDemoOne({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ScrollControllerDemoOne> createState() => _ScrollControllerDemoOneState();
}

class _ScrollControllerDemoOneState extends State<ScrollControllerDemoOne> with SingleTickerProviderStateMixin {
  final trackingScrollController = TrackingScrollController();

  /// 嵌套滚动
  final scrollControllerNew = ScrollController();
  final scrollY = ValueNotifier(0.0);

  var items = List.generate(3, (index) => "Tab $index");

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    scrollControllerNew.addListener(() {
      scrollY.value = scrollControllerNew.offset;
    });
    tabController = TabController(length: items.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title ?? "$widget"),
      // ),
      body: buildDefaultTabController(),
    );
  }

  Widget buildDefaultTabController() {
    const collapsedHeight = 40.0;

    return DefaultTabController(
      length: items.length,
      child: NestedScrollView(
        controller: scrollControllerNew,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: ValueListenableBuilder(
                  valueListenable: scrollY,
                  builder: (context, value, child) {
                    try {
                      // YLog.d("scrollY: ${[
                      //   value,
                      //   scrollControllerNew.position.progress
                      // ]}");

                      final opacity = scrollControllerNew.position.progress > 0.9 ? 1.0 : 0.0;
                      return AnimatedOpacity(
                        opacity: opacity,
                        duration: const Duration(milliseconds: 100),
                        child: Row(
                          children: [
                            FlutterLogo(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.60),
                              child: Text("$widget"),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      debugPrint("$this $e");
                    }
                    return const SizedBox();
                  },
                ),
                toolbarHeight: collapsedHeight,
                collapsedHeight: collapsedHeight,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                centerTitle: false,
                pinned: true,
                floating: false,
                snap: false,
                primary: true,
                expandedHeight: 240,
                elevation: 10,
                //是否显示阴影，直接取值innerBoxIsScrolled，展开不显示阴影，合并后会显示
                forceElevated: innerBoxIsScrolled,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () => debugPrint("更多"),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  // background: Image.asset("assets/images/bg_football_pitch.png", fit: BoxFit.fill),
                  background: Container(
                    // padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg_football_pitch.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // height: 80,
                    // color: Colors.green,
                    child: buildTopMenu(),
                  ),
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    child: TabBar(
                      tabs: items.map((String name) => Tab(text: name)).toList(),
                      controller: tabController,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      dividerColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: buildTabBarView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      // These are the contents of the tab views, below the tabs.
      children: items.map((String name) {
        //SafeArea 适配刘海屏的一个widget
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (BuildContext context) {
              return CustomScrollView(
                key: PageStorageKey<String>(name),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(10.0),
                    sliver: SliverFixedExtentList(
                      itemExtent: 50.0, //item高度或宽度，取决于滑动方向
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Item $index, tab${tabController.index}'),
                          );
                        },
                        childCount: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget buildTopMenu() {
    final list = List.generate(8, (index) => "item_$index");

    return Container(
      // height: 160,
      // color: Colors.orange,
      child: Scrollbar(
        child: GridView.count(
          crossAxisCount: 4,
          scrollDirection: Axis.vertical,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          // childAspectRatio: 3 / 4,
          children: list.map((e) => buildMenuItem(e: e)).toList(),
        ),
      ),
    );
  }

  Widget buildMenuItem({required String e}) {
    return GestureDetector(
      onTap: () {
        DLog.d(e);
      },
      child: Container(
        decoration: BoxDecoration(
          // color: ColorExt.random,
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlutterLogo(),
            Text(e),
          ],
        ),
      ),
    );
  }
}
