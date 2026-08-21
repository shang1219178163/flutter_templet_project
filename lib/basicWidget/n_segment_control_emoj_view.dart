//
//  NSegmentControlEmojView.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/25 12:05.
//  Copyright © 2024/3/25 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_segment_control_emoji.dart';

/// 表情页面
class NSegmentControlEmojView extends StatefulWidget {
  const NSegmentControlEmojView({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.segmentGap = 5,
    this.segmentRadius = 4,
    this.segmentPadding = const EdgeInsets.symmetric(vertical: 7),
  });

  /// 数据源
  final List<SegmentEmojiModel> items;

  /// 默认选项
  final int selectedIndex;

  /// 间距
  final double segmentGap;

  /// 圆角
  final double segmentRadius;

  /// 内边距
  final EdgeInsets segmentPadding;

  @override
  State<NSegmentControlEmojView> createState() => _NSegmentControlEmojViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<SegmentEmojiModel>('items', items));
    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties.add(DoubleProperty('segmentGap', segmentGap));
    properties.add(DoubleProperty('segmentRadius', segmentRadius));
    properties.add(DiagnosticsProperty<EdgeInsets>('segmentPadding', segmentPadding));
  }
}

class _NSegmentControlEmojViewState extends State<NSegmentControlEmojView> with SingleTickerProviderStateMixin {
  late final tabController = TabController(
    initialIndex: widget.selectedIndex,
    length: widget.items.length,
    vsync: this,
  );

  late final pageController = PageController(initialPage: widget.selectedIndex, keepPage: true);

  late final selectedIndex = ValueNotifier(widget.selectedIndex);

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedIndex,
          builder: (context, value, child) {
            return NSegmentControlEmoji(
              items: widget.items,
              selectedIndex: value,
              segmentGap: widget.segmentGap,
              segmentRadius: widget.segmentRadius,
              segmentPadding: widget.segmentPadding,
              onChanged: (index) {
                tabController.index = index;
                pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 350),
                  curve: Curves.ease,
                );
              },
            );
          },
        ),
        Expanded(
          child: buildPageView(),
        ),
      ],
    );
  }

  Widget buildTabBarView() {
    return TabBarView(
      controller: tabController,
      children: widget.items
          .map((e) =>
              e.child ??
              Center(
                child: Text("tab ${widget.items.indexOf(e)}"),
              ))
          .toList(),
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        selectedIndex.value = index;
        setState(() {});
      },
      children: widget.items
          .map((e) =>
              e.child ??
              Center(
                child: Text("tab ${widget.items.indexOf(e)}"),
              ))
          .toList(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TabController>('tabController', tabController));
    properties.add(DiagnosticsProperty<PageController>('pageController', pageController));
    properties.add(DiagnosticsProperty<ValueNotifier<int>>('selectedIndex', selectedIndex));
  }
}
