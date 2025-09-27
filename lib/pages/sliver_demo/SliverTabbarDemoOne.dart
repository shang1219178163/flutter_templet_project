//
//  SliverTabbarDemoOne.dart
//  flutter_templet_project
//
//  Created by shang on 6/8/21 6:00 PM.
//  Copyright © 6/8/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class SliverTabbarDemoOne extends StatefulWidget {
  const SliverTabbarDemoOne({Key? key}) : super(key: key);

  @override
  _SliverTabbarDemoOneState createState() => _SliverTabbarDemoOneState();
}

class _SliverTabbarDemoOneState extends State<SliverTabbarDemoOne>
    with SingleTickerProviderStateMixin {
  var items = List.generate(3, (index) => "Tab $index");

  late final tabController = TabController(length: items.length, vsync: this);

  @override
  void initState() {
    super.initState();
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
    return DefaultTabController(
      length: items.length, // This is the number of tabs.
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
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
                title: Text("$widget"),
                centerTitle: false,
                pinned: true,
                floating: false,
                snap: false,
                primary: true,
                expandedHeight: 300,
                elevation: 0,
                //是否显示阴影，直接取值innerBoxIsScrolled，展开不显示阴影，合并后会显示
                forceElevated: innerBoxIsScrolled,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () => debugPrint("更多"),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  // background: Image.asset("assets/images/bg.png", fit: BoxFit.fill),
                  background: Container(
                    padding: EdgeInsets.fromLTRB(20, safeAreaTop, 20, 60),
                    // height: 80,
                    // color: Colors.green,
                    child: buildTopMenu(),
                  ),
                ),
                // bottom: TabBar(
                //   tabs: items.map((String name) => Tab(text: name)).toList(),
                //   controller: tabController,
                //   isScrollable: true,
                //   indicatorColor: Colors.white,
                // ),
                bottom: ColoredTabBar(
                  width: double.maxFinite,
                  // backgroudColor: Colors.white,
                  // labelColor: context.primaryColor,
                  labelColor: Colors.white,
                  backgroudColor: context.primaryColor,
                  child: TabBar(
                    tabs: items.map((String name) => Tab(text: name)).toList(),
                    controller: tabController,
                    isScrollable: true,
                  ),
                ),
              ),
            ),
          ];
        },
        body: buildTabBarView(),
      ),
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      // These are the contents of the tab views, below the tabs.
      children: items.map((String name) {
        //SafeArea 适配刘海屏的一个widget
        return Builder(
          builder: (BuildContext context) {
            return CustomScrollView(
              key: PageStorageKey<String>(name),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
        );
      }).toList(),
    );
  }

  Widget buildTopMenu() {
    final list = List.generate(8, (index) => "item_$index");

    return Container(
      // height: 160,
      color: Colors.orange,
      child: Scrollbar(
        child: GridView.count(
          // physics: NeverScrollableScrollPhysics(),
          // padding: EdgeInsets.all(15.0),
          //一行多少个
          crossAxisCount: 4,
          //滚动方向
          scrollDirection: Axis.vertical,
          // 左右间隔
          crossAxisSpacing: 8,
          // 上下间隔
          mainAxisSpacing: 8,
          //宽高比
          // childAspectRatio: 3 / 4,
          children: list
              .map((e) => buildMenuItem(top: FlutterLogo(), bottom: Text(e)))
              .toList(),
        ),
      ),
    );
  }

  Widget buildMenuItem({required Widget top, required Widget bottom}) {
    return Container(
      color: ColorExt.random,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          top,
          bottom,
        ],
      ),
    );
  }
}

class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  ColoredTabBar({
    super.key,
    this.backgroudColor,
    this.padding,
    this.decoration,
    this.height,
    this.width,
    this.labelColor,
    this.tabBarTheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: padding,
      color: backgroudColor,
      decoration: decoration,
      width: width ?? double.maxFinite,
      height: height,
      // child: child,
      child: Theme(
        data: ThemeData(
          tabBarTheme: tabBarTheme ??
              TabBarTheme(
                dividerColor: Colors.transparent,
                labelColor: labelColor,
                unselectedLabelColor: labelColor,
                indicatorColor: labelColor,
              ),
        ),
        child: child,
      ),
    );
  }

  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;

  final double? height;
  final double? width;

  final Color? labelColor;
  final Color? backgroudColor;
  final TabBarTheme? tabBarTheme;

  final PreferredSizeWidget child;

  @override
  Size get preferredSize => child.preferredSize;
}

// class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
//
//   ColoredTabBar({
//     super.key,
//     required this.color,
//     this.padding,
//     this.decoration,
//     this.width,
//     this.height,
//     required this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Ink(
//       padding: padding,
//       color: color,
//       decoration: decoration,
//       width: width,
//       height: height,
//       child: child,
//     );
//   }
//
//   final EdgeInsetsGeometry? padding;
//   final Color? color;
//   final Decoration ? decoration;
//
//   final double? width;
//   final double? height;
//   final PreferredSizeWidget child;
//
//
//   @override
//   Size get preferredSize => child.preferredSize;
// }
