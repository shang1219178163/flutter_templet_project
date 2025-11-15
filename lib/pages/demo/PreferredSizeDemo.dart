import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:tuple/tuple.dart';

class PreferredSizeDemo extends StatefulWidget {
  PreferredSizeDemo({super.key, this.title});

  final String? title;

  @override
  State<PreferredSizeDemo> createState() => _PreferredSizeDemoState();
}

class _PreferredSizeDemoState extends State<PreferredSizeDemo> with SingleTickerProviderStateMixin {
  late List<Tuple2<String, Widget>> items = [
    Tuple2('功能列表', buildSubpage(prefix: "选项zero")),
    Tuple2('功能列表1', buildSubpage(prefix: "选项one")),
    Tuple2('功能列表2', buildSubpage(prefix: "选项two")),
    Tuple2('功能列表3', buildSubpage(prefix: "选项three")),
    Tuple2('功能列表4', buildSubpage(prefix: "选项four")),
    Tuple2('功能列表5', buildSubpage(prefix: "选项five")),
  ];

  late final tabController = TabController(length: items.length, vsync: this);

  int tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
        // bottom: buildTabBar(),
      ),
      body: Column(
        children: [
          buildTabBar(),
          Expanded(
            child: items[tabBarIndex].item2,
          ),
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return Material(
      color: context.primaryColor,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabs: items.map((e) => Tab(text: e.item1)).toList(),
        indicatorSize: TabBarIndicatorSize.label,
        // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
        onTap: (index) {
          tabBarIndex = index;
          setState(() {});
        },
      ),
    );
  }

  Widget buildSubpage({String prefix = "选项"}) {
    return ListView.separated(
      cacheExtent: 180,
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("${prefix}_$index"),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}

class NTabBarPage extends StatefulWidget {
  NTabBarPage({super.key, this.title});

  final String? title;

  @override
  State<NTabBarPage> createState() => _NTabBarPageState();
}

class _NTabBarPageState extends State<NTabBarPage> with SingleTickerProviderStateMixin {
  late List<Tuple2<String, Widget>> items = [
    Tuple2('功能列表', buildSubpage(prefix: "选项zero")),
    Tuple2('功能列表1', buildSubpage(prefix: "选项one")),
    Tuple2('功能列表2', buildSubpage(prefix: "选项two")),
    Tuple2('功能列表3', buildSubpage(prefix: "选项three")),
    Tuple2('功能列表4', buildSubpage(prefix: "选项four")),
    Tuple2('功能列表5', buildSubpage(prefix: "选项five")),
  ];

  late final tabController = TabController(length: items.length, vsync: this);

  int tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
        // bottom: buildTabBar(),
      ),
      body: Column(
        children: [
          buildTabBar(),
          Expanded(
            child: items[tabBarIndex].item2,
          ),
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return Material(
      color: context.primaryColor,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabs: items.map((e) => Tab(text: e.item1)).toList(),
        indicatorSize: TabBarIndicatorSize.label,
        // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
        onTap: (index) {
          tabBarIndex = index;
          setState(() {});
        },
      ),
    );
  }

  Widget buildSubpage({String prefix = "选项"}) {
    return ListView.separated(
      cacheExtent: 180,
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("${prefix}_$index"),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
