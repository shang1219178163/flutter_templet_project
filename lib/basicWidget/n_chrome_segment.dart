//
//  NChromeSegment.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/6 15:36.
//  Copyright © 2024/6/6 shang. All rights reserved.
//

import 'package:flutter/material.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';

typedef ChromeSegmentRecord = ({Widget title, int count});

/// 浏览器风格分段菜单
class NChromeSegment extends StatefulWidget {
  const NChromeSegment({
    super.key,
    required this.items,
    this.currentIndex = 0,
    required this.onChanged,
    this.selectedBgColor = Colors.white,
    this.bgColor = const Color(0xffF3F3F3),
    this.radius = 16,
  });

  final List<ChromeSegmentRecord> items;

  /// 当前索引
  final int currentIndex;

  /// 回调
  final ValueChanged<int> onChanged;

  /// 高亮背景色
  final Color selectedBgColor;

  /// 背景色
  final Color bgColor;

  /// 圆角
  final double radius;

  @override
  State<NChromeSegment> createState() => _NChromeSegmentState();
}

class _NChromeSegmentState extends State<NChromeSegment> {
  late int currentIndex = widget.currentIndex;

  /// 高亮背景色
  late var selectedBgColor = widget.selectedBgColor;
  late var unselectedBgColor = widget.bgColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NChromeSegment oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items ||
        oldWidget.radius != widget.radius ||
        oldWidget.selectedBgColor != widget.selectedBgColor ||
        oldWidget.bgColor != widget.bgColor ||
        oldWidget.currentIndex != widget.currentIndex) {
      selectedBgColor = widget.selectedBgColor;
      unselectedBgColor = widget.bgColor;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: selectedBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.radius),
          topRight: Radius.circular(widget.radius),
        ),
      ),
      child: Row(
        children: widget.items.map((e) {
          final eIndex = widget.items.indexOf(e);

          return Expanded(
            child: InkWell(
              onTap: () {
                if (currentIndex == eIndex) {
                  return;
                }
                currentIndex = eIndex;
                setState(() {});
                widget.onChanged(currentIndex);
              },
              child: buildTab(e: e, eIndex: eIndex),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildTab({
    required ChromeSegmentRecord e,
    required int eIndex,
  }) {
    final isSelected = (currentIndex == eIndex);

    var topLeftRadius = widget.radius;
    var bottomRightRadius = widget.radius;
    if (isSelected) {
      if (eIndex == currentIndex) {
        if (currentIndex == widget.items.length - 1) {
          bottomRightRadius = 0;
        } else if (currentIndex == 0) {
          topLeftRadius = 0;
        }
      }
    } else {
      if (eIndex == currentIndex - 1) {
        topLeftRadius = 0;
        bottomRightRadius = widget.radius;
      } else if (eIndex == currentIndex + 1) {
        topLeftRadius = widget.radius;
        bottomRightRadius = 0;
      } else {
        topLeftRadius = 0;
        bottomRightRadius = 0;
      }
    }

    // YLog.d("buildTab: ${{
    //   "eIndex": eIndex,
    //   "isSelected": isSelected,
    //   "topLeftRadius": topLeftRadius,
    //   "bottomRightRadius": bottomRightRadius,
    // }}");

    return ColoredBox(
      color: isSelected ? unselectedBgColor : selectedBgColor,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : unselectedBgColor,
          // gradient: LinearGradient(
          //   colors: isSelected
          //       ? [selectedColor, selectedColor]
          //       : [const Color(0xFFFAFAFA), bgColor],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeftRadius),
            bottomRight: Radius.circular(bottomRightRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            e.title,
            if (e.count > 0)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  '${e.count > 0 ? e.count : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? context.primaryColor : AppColor.fontColor737373,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
