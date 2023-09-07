//
//  NPageView.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 2:32 PM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:tuple/tuple.dart';

/// 多页面左右滑动封装
class NPageView extends StatefulWidget {


  const NPageView({
    Key? key,
    required this.items,
    this.hideAppbar = false,
    this.isTabBar = false,
  }) : super(key: key);

  final List<Tuple2<String, Widget>> items;

  final bool hideAppbar;

  final bool isTabBar;

  @override
  _NPageViewState createState() => _NPageViewState();
}

class _NPageViewState extends State<NPageView> with SingleTickerProviderStateMixin {

  late final _tabController = TabController(length: widget.items.length, vsync: this);

  late final _pageController = PageController(initialPage: 0, keepPage: true);

  late final _isTabBarVN = ValueNotifier(widget.isTabBar);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTabBar == oldWidget.isTabBar) {
      return;
    }
    _isTabBarVN.value = widget.isTabBar;
    debugPrint("didUpdateWidget isTabBarVN:${widget.isTabBar}, _isTabBarVN:${_isTabBarVN.value}");
  }

  @override
  Widget build(BuildContext context) {
    return _buildPageView(items: widget.items);
  }

  TabBar _buildTabBar({required List<Tuple2<String, Widget>> items,}) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: items.map((e) => Tab(text: e.item1)).toList(),
      indicatorSize: TabBarIndicatorSize.label,
      // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
      onTap: (index){
        _pageController.jumpToPage(index);
        setState(() {});
      },
    );
  }

  Material _buildBottomNavigationBar({required List<Tuple2<String, Widget>> items,}) {
    final textColor = Theme.of(context).colorScheme.secondary;
    const bgColor = Colors.white;

    return Material(
      color: bgColor,
      child: SafeArea(
        child: TabBar(
          controller: _tabController,
          tabs: items.map((e) => Tab(text: e.item1)).toList(),
          labelColor: textColor,
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: textColor,
                  width: 3.0
              ),
            ),
          ),
          onTap: (index){
            _pageController.jumpToPage(index);
            setState(() {});
          },
        ),
      )
    );
  }

  Widget _buildPageView({required List<Tuple2<String, Widget>> items,}) {
    return Column(
      children: [
        ValueListenableBuilder(
           valueListenable: _isTabBarVN,
           builder: (context,  value, child){
            if (value) {
              return SizedBox();
            }
            return Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              constraints: BoxConstraints(maxHeight: 48.0),
              child: _buildTabBar(items: items),
            );
          }
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _tabController.animateTo(index);
              setState(() {});
            },
            // children: _pages.map((e) => Tab(text: e.item1)).toList(),
            children: items.map((e) => e.item2).toList(),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: _isTabBarVN,
            builder: (context,  value, child){
              if (!value) {
                return SizedBox();
              }
              return _buildBottomNavigationBar(items: items);
            }
        ),
      ],
    );
  }


}
