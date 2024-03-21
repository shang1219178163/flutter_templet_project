//
//  NSlidingSegmentedPageView.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/22 00:49.
//  Copyright © 2024/3/22 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/n_sliding_segmented_control.dart';

/// 分段按钮的切换页面
class NSlidingSegmentedPageView extends StatefulWidget {

  const NSlidingSegmentedPageView({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.segmentedBuilder,
    this.middleBuilder,
  });

  /// title 分段组件每项标题
  /// icon 分段组件每项本地图片路径
  /// child 分段组件每项页面
  final List<({String title, String icon, Widget child,})> items;
  /// 默认索引
  final int selectedIndex;
  /// 头部所在构造器
  final Widget Function(NSlidingSegmentedControl segmentedControl)? segmentedBuilder;
  /// 分段按钮和页面之间的位置
  final IndexedWidgetBuilder? middleBuilder;

  @override
  State<NSlidingSegmentedPageView> createState() => _NSlidingSegmentedPageViewState();
}

class _NSlidingSegmentedPageViewState extends State<NSlidingSegmentedPageView> {

  late final selectedIndexVN = ValueNotifier(widget.selectedIndex.clamp(0, widget.items.length));

  late var pageController = PageController(initialPage: widget.selectedIndex, keepPage: true);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NSlidingSegmentedPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (
      oldWidget.items != widget.items ||
      oldWidget.selectedIndex != widget.selectedIndex ||
      oldWidget.segmentedBuilder != widget.segmentedBuilder ||
      oldWidget.middleBuilder != widget.middleBuilder
    ) {
      selectedIndexVN.value = widget.selectedIndex.clamp(0, widget.items.length);
      pageController = PageController(initialPage: widget.selectedIndex, keepPage: true);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<int>(
            valueListenable: selectedIndexVN,
            builder: (context, index, child){

              final segmentedControl = NSlidingSegmentedControl(
                items: widget.items.map((e) => (title: e.title, icon: e.icon)).toList(),
                selectedIndex: index,
                onChanged: (int page) {
                  pageController.animateToPage(page, duration: Duration(milliseconds: 350), curve: Curves.ease);
                  // pageController.jumpToPage(index);
                },
              );

              return widget.segmentedBuilder?.call(segmentedControl) ?? Container(
                // padding: EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                padding: EdgeInsets.only(left: 48, right: 48, top: 12, bottom: 16),
                decoration: BoxDecoration(
                  // color: Colors.green,
                  // border: Border.all(color: Colors.blue),
                  // borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: segmentedControl,
              );
            }
        ),
        ValueListenableBuilder<int>(
          valueListenable: selectedIndexVN,
          builder: (context, index, child) {
            return widget.middleBuilder?.call(context, index) ?? SizedBox();
          },
        ),
        Expanded(
          child: buildPageView(),
        ),
      ],
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        selectedIndexVN.value = index;
      },
      children: widget.items.map((e) => e.child).toList(),
    );
  }

}