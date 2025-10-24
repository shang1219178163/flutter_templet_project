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

  late final tabController = TabController(length: tabTitles.length, vsync: this);

  final descVN = ValueNotifier("");

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
          color: Colors.lightGreen,
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

    var expandedHeight = 300.0;
    var collapseHeight = kToolbarHeight;

    var tabBarHeight = 40.0;

    return NSliverPageOne(
      expandedHeight: expandedHeight,
      collapsedHeight: collapseHeight,
      tabBarHeight: tabBarHeight,
      title: Text("$collapseHeight/$expandedHeight"),
      header: LayoutBuilder(builder: (context, constraints) {
        // 59 + 56 = 115 + 40 = 155
        var top = constraints.maxHeight;
        // final double opacity =
        //     ((constraints.maxHeight - collapseHeight) / (expandedHeight - collapseHeight)).clamp(0.0, 1.0);

        final fixedHeight = statusBarHeight + tabBarHeight;
        final double opacity = ((top - fixedHeight - kToolbarHeight) / (expandedHeight - fixedHeight)).clamp(0, 1.0);

        final desc = [statusBarHeight, collapseHeight, top, opacity].map((e) => e.toStringAsFixed(1)).join("_");

        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedOpacity(
              opacity: opacity,
              duration: Duration(milliseconds: 200),
              child: Container(
                margin: EdgeInsets.only(bottom: tabBarHeight),
                constraints: constraints,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.3),
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_jiguang.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset(
                        "assets/images/avatar.png",
                        width: 80,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "英格兰超级联赛$desc",
                      // style: TextStyle(fontSize: 20),
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
                        color: Colors.white.withOpacity(0.5),
                        value: 0.5,
                      ),
                    ),
                    // SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // HeaderCollapsedTopLeft(
            //   opacity: opacity,
            //   statusBarHeight: statusBarHeight,
            // ),
            Positioned(
              child: HeaderCollapsedTopLeft(
                opacity: opacity,
                statusBarHeight: 18,
              ),
            )
          ],
        );
      }),
      tabBuilder: (context, tab) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
          ),
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorColor: Colors.red,
            tabs: tabTitles.map((e) {
              return Tab(
                text: e,
                height: tabBarHeight,
              );
            }).toList(),
          ),
        );
      },
      body: buildTabBarView(),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: tabTitles.map(
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

class _NewsPageState extends State<NewsPage> {
  final items = List.generate(30, (i) => "item_$i");
  late String tabTitlte = widget.tabTitlte;

  final scrollController = ScrollController();

  // @override
  // bool get wantKeepAlive => true;

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
    // super.build(context);
    return EasyRefresh(
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scrollbar(
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
        ),
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
  const HeaderCollapsedTopLeft({
    super.key,
    required this.opacity,
    required this.statusBarHeight,
  });

  final double opacity;
  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    var opacityNew = 1 - opacity;
    // opacityNew = 1;
    return Container(
      padding: EdgeInsets.only(
        left: 56, // 避开返回按钮
        top: statusBarHeight, // 避开状态栏
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
      ),
      child: AnimatedOpacity(
        opacity: opacityNew,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.red,
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 6),
                child: const Icon(Icons.sports_soccer, size: 28, color: Colors.white),
              ),
              Text(
                "银河护卫度${opacityNew.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
