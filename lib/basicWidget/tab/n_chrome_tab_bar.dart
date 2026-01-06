//
//  NChromeTabBar.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/5 17:22.
//  Copyright © 2026/1/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/tab/model/n_tabbar_data_model.dart';

/// Chrome 浏览器风格 tabbar
class NChromeTabBar extends StatefulWidget {
  const NChromeTabBar({
    super.key,
    this.height = 44,
    this.itemPadding,
    this.selectedBgColor,
    this.bgColor,
    required this.items,
    required this.indexVN,
    this.onChanged,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.itemBuilder,
  });

  final List<NTabbarDataModel> items;
  final ValueNotifier<int> indexVN;

  final ValueChanged<int>? onChanged;

  final double? height;
  final EdgeInsets? itemPadding;
  final Color? bgColor;
  final Color? selectedBgColor;

  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  /// 默认无法满足时自定义
  final IndexedWidgetBuilder? itemBuilder;

  @override
  State<NChromeTabBar> createState() => _NChromeTabBarState();
}

class _NChromeTabBarState extends State<NChromeTabBar> {
  late var currIndex = widget.indexVN.value;

  @override
  void dispose() {
    widget.indexVN.removeListener(onIndexLtr);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.indexVN.addListener(onIndexLtr);
  }

  onIndexLtr() {
    currIndex = widget.indexVN.value;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant NChromeTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items ||
        oldWidget.indexVN != widget.indexVN ||
        oldWidget.height != widget.height ||
        oldWidget.itemPadding != widget.itemPadding ||
        oldWidget.bgColor != widget.bgColor ||
        oldWidget.selectedBgColor != widget.selectedBgColor ||
        oldWidget.selectedLabelStyle != widget.selectedLabelStyle ||
        oldWidget.unselectedLabelStyle != widget.unselectedLabelStyle ||
        oldWidget.itemBuilder != widget.itemBuilder) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabBarTheme = theme.tabBarTheme;

    final selectedTextStyle = widget.selectedLabelStyle ??
        tabBarTheme.labelStyle ??
        TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        );

    final unselectedTextStyle = widget.unselectedLabelStyle ??
        tabBarTheme.unselectedLabelStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        );
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.bgColor,
      ),
      child: Row(
        children: [
          ...widget.items.map(
            (e) {
              final i = widget.items.indexOf(e);
              final isSelected = widget.indexVN.value == i;

              return Expanded(
                child: Container(
                  padding: widget.itemPadding,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isSelected)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          right: 0,
                          child: Image(
                            image: e.bg!,
                            fit: BoxFit.fill,
                            color: e.bgColor ?? widget.selectedBgColor,
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          if (currIndex == i) {
                            debugPrint("$runtimeType $i 重复点击");
                            return;
                          }
                          setState(() {});
                          currIndex = i;
                          widget.indexVN.value = i;
                          widget.onChanged?.call(widget.indexVN.value);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // decoration: BoxDecoration(
                          //   color: Colors.transparent,
                          //   border: Border.all(color: Colors.blue),
                          // ),
                          child: widget.itemBuilder?.call(context, i) ??
                              Text(
                                e.title,
                                maxLines: 1,
                                style: isSelected ? (e.style ?? selectedTextStyle) : unselectedTextStyle,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
