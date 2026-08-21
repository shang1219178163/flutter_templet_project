import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_page.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

class NestedScrollViewDemoSix extends StatefulWidget {
  const NestedScrollViewDemoSix({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NestedScrollViewDemoSix> createState() => _NestedScrollViewDemoSixState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, dynamic>?>('arguments', arguments));
  }
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
    return buildBody();
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('hideApp', hideApp));
    properties.add(DiagnosticsProperty<ScrollController>('scrollController', scrollController));
    properties.add(IterableProperty<String>('tabTitles', tabTitles));
    properties.add(DiagnosticsProperty<TabController>('tabController', tabController));
    properties.add(DiagnosticsProperty<ValueNotifier<String>>('descVN', descVN));
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('tabTitlte', tabTitlte));
    properties.add(DiagnosticsProperty<TabController>('tabController', tabController));
  }
}

class _NewsPageState extends State<NewsPage> {
  var items = List.generate(20, (i) => "item_$i");
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
          controller: scrollController,
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
    items = List.generate(20, (i) => "item_$i");
    setState(() {});
  }

  Future<void> onLoad() async {
    DLog.d("onLoad");
    await Future.delayed(Duration(seconds: 1));
    items.addAll(List.generate(20, (i) => "item_${items.length + i}"));
    setState(() {});
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('items', items));
    properties.add(StringProperty('tabTitlte', tabTitlte));
    properties.add(DiagnosticsProperty<ScrollController>('scrollController', scrollController));
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('opacity', opacity));
    properties.add(DoubleProperty('statusBarHeight', statusBarHeight));
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('opacity', opacity));
    properties.add(DoubleProperty('statusBarHeight', statusBarHeight));
  }
}
