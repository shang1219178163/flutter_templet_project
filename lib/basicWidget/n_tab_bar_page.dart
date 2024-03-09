//
//  NTabBarPage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/9 09:45.
//  Copyright © 2024/3/9 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:tuple/tuple.dart';


/// TabBar 初步页面封装
class NTabBarPage extends StatefulWidget {

  NTabBarPage({
    super.key,
    required this.items,
    this.onChanged,
  });

  final List<Tuple2<String, Widget>> items;
  final ValueChanged<int>? onChanged;

  @override
  State<NTabBarPage> createState() => _NTabBarPageState();
}

class _NTabBarPageState extends State<NTabBarPage> with SingleTickerProviderStateMixin {

  late List<Tuple2<String, Widget>> items = widget.items;

  late final tabController = TabController(length: items.length, vsync: this);

  int tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTabBar(),
        Expanded(
          child: items[tabBarIndex].item2,
        ),
      ],
    );
  }

  Widget buildTabBar() {
    return Material(
      color: context.primaryColor,
      child: Center(
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: items.map((e) => Tab(text: e.item1)).toList(),
          indicatorSize: TabBarIndicatorSize.label,
          // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
          onTap: (index){
            tabBarIndex = index;
            setState(() {});
            widget.onChanged?.call(index);
          },
        ),
      ),
    );
  }
}