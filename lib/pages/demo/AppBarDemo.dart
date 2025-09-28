import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/util/Resource.dart';

class AppBarDemo extends StatefulWidget {
  AppBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AppBarDemoState createState() => _AppBarDemoState();
}

class _AppBarDemoState extends State<AppBarDemo> with SingleTickerProviderStateMixin {
  late final items = <String>[
    'AppBar隐藏',
    'AppBar背景',
    'Tabview',
    '滑动',
    '主题1',
    '位置1',
    '颜色1',
    '滑动1',
  ];

  late final tabController = TabController(length: items.length, vsync: this);

  late MediaQueryData mq = MediaQuery.of(context);

  ThemeData get theme => Theme.of(context);

  final tabIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        debugPrint("_tabController:${tabController.index}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tabIndex.value == 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          leading: SizedBox(),
          leadingWidth: 0,
          elevation: 0,
          flexibleSpace: buildFlexibleSpace(),
        ),
        body: buildBody(),
      );
    }

    if (tabIndex.value == 2) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildTabview(controller: tabController),
      );
    }

    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildFlexibleSpace() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(Resource.image.urls[5]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          height: mq.viewPadding.top,
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Text("statusBar ${mq.viewPadding.top}"),
        ),
        buildTab(),
      ],
    );
  }

  Widget buildTab() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Container(
        color: theme.primaryColor,
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorColor: theme.scaffoldBackgroundColor,
          tabs: items.map((e) => Tab(text: e)).toList(),
          // labelColor: textColor,
          // labelStyle: widget.labelStyle,
          // indicator: widget.isTabBottom ? decorationTop : decorationBom,
          onTap: (index) {
            debugPrint("index: $index");
            tabIndex.value = index;
            setState(() {});
          },
        ),
      ),
    );
  }

  /// TabBar 脱离 AppBar
  Widget buildTabview({
    required TabController controller,
    double barHeight = 50,
  }) {
    return Column(
      children: [
        TabBar(
          controller: controller,
          isScrollable: true,
          // padding: EdgeInsets.symmetric(horizontal: 42),
          // indicatorPadding: EdgeInsets.symmetric(horizontal: 42),
          labelColor: theme.primaryColor,
          labelPadding: EdgeInsets.symmetric(horizontal: 8),
          tabs: items.map((e) => Tab(text: e)).toList(),
          onTap: (index) {
            debugPrint("index: $index");
            tabIndex.value = index;
            setState(() {});
          },
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: items.map((e) {
              final i = items.indexOf(e);

              return Container(
                color: ColorExt.random,
                alignment: Alignment.center,
                child: NText("$i"),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  onPressed() {}
}
