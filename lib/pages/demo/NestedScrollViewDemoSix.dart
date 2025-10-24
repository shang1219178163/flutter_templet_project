import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_page.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_page_one.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:get/get.dart';

class NestedScrollViewDemoSix extends StatefulWidget {
  const NestedScrollViewDemoSix({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NestedScrollViewDemoSix> createState() => _NestedScrollViewDemoSixState();
}

class _NestedScrollViewDemoSixState extends State<NestedScrollViewDemoSix> with SingleTickerProviderStateMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final tabTitles = List.generate(10, (i) => "item_$i");
  final items = List.generate(100, (i) => "item_$i");

  late final tabController = TabController(length: items.length, vsync: this);

  @override
  void didUpdateWidget(covariant NestedScrollViewDemoSix oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return buildBodyOne();
    return buildBody();
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBodyOne(),
    );
  }

  Widget buildBody() {
    return NSliverPage(
      title: Text("NSliverPage"),
      header: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: Text("header"),
      ),
      tabBuilder: (context, tab) {
        return tab;
      },
      body: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: buildListView(tabTitlte: "tab"),
      ),
    );
  }

  Widget buildBodyOne() {
    var statusBarHeight = MediaQuery.of(context).padding.top;

    final expandedHeight = 300.0;
    final double collapseHeight = statusBarHeight + kToolbarHeight;

    final tabBarHeight = 36.0;

    return NSliverPageOne(
      expandedHeight: expandedHeight,
      collapsedHeight: collapseHeight,
      tabBarHeight: tabBarHeight,
      title: Text("NSliverPageOne"),
      header: LayoutBuilder(builder: (context, constraints) {
        var top = constraints.maxHeight;
        final double opacity = ((top - collapseHeight) / (expandedHeight - collapseHeight)).clamp(0.0, 1.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/bg_jiguang.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            HeaderContentAnimated(
              opacity: opacity,
              statusBarHeight: statusBarHeight,
              child: Container(
                constraints: constraints,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/avatar.png",
                        width: 60,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "英格兰超级联赛",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 4),
                    Text("English Premier League"),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                        backgroundColor: Colors.black12,
                        color: Colors.red,
                        value: 0.5,
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            HeaderCollapsedTopLeft(
              opacity: opacity,
              statusBarHeight: statusBarHeight,
            ),
          ],
        );
        return Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          child: Text("header"),
        );
      }),
      tabBuilder: (context, tab) {
        return Container(
          height: tabBarHeight,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(color: Colors.blue),
          ),
          child: buildTab(),
        );
      },
      body: buildTabBarView(),
    );
  }

  // Widget buildHeader() {
  //   return
  // }

  Widget buildTab() {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      tabs: items.map((e) => Tab(text: e)).toList(),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: items.map(
        (e) {
          return buildListView(tabTitlte: e);
        },
      ).toList(),
    );
  }

  Widget buildListView({required String tabTitlte}) {
    return NewsPage(
      key: ValueKey(tabTitlte),
      tabTitlte: tabTitlte,
      tabController: tabController,
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({
    super.key,
    required this.tabTitlte,
    required this.tabController,
  });

  final String tabTitlte;
  final TabController tabController;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with AutomaticKeepAliveClientMixin {
  final items = List.generate(100, (i) => "item_$i");
  late String tabTitlte = widget.tabTitlte;

  final scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    widget.tabController.removeListener(onTabLtr);
    super.dispose();
  }

  @override
  void initState() {
    widget.tabController.addListener(onTabLtr);
    super.initState();
  }

  void onTabLtr() {
    if (widget.tabController.indexIsChanging) {
      return;
    }
    // scrollController.jumpTo(0);
  }

  @override
  void didUpdateWidget(covariant NewsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: ListView.separated(
        key: PageStorageKey(tabTitlte),
        controller: scrollController,
        itemBuilder: (_, i) {
          final e = items[i];

          return ListTile(
            title: Text([tabTitlte, e].join("_")),
          );
        },
        separatorBuilder: (_, i) {
          return Divider();
        },
        itemCount: items.length,
      ),
    );
  }

  Future<void> onRefresh() async {
    DLog.d("onRefresh");
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> onLoad() async {
    DLog.d("onLoad");
    await Future.delayed(Duration(seconds: 1));
  }
}

class HeaderContentAnimated extends StatelessWidget {
  const HeaderContentAnimated({
    super.key,
    required this.opacity,
    required this.statusBarHeight,
    required this.child,
  });

  final double opacity;
  final double statusBarHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: statusBarHeight + kToolbarHeight,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, (1 - opacity) * 20),
          child: Transform.scale(
            scale: 0.9 + 0.1 * opacity,
            child: child,
          ),
        ),
      ),
    );
  }
}

class HeaderCollapsedTopLeft extends StatelessWidget {
  const HeaderCollapsedTopLeft({super.key, required this.opacity, required this.statusBarHeight});

  final double opacity;
  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    final opacityNew = 1 - opacity;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: 56, // 避开返回按钮
          top: statusBarHeight, // 避开状态栏
        ),
        child: AnimatedOpacity(
          opacity: opacityNew,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.blue),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  child: const Icon(Icons.sports_soccer, size: 28),
                ),
                Text(
                  "银河护卫度${opacityNew.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
