//
//  NFilledTab.dart
//  projects
//
//  Created by shang on 2026/7/8 18:12.
//  Copyright © 2026/7/8 shang. All rights reserved.
//

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

/// 渐进色背景 Tabbar
class NFilledTabBar<E> extends StatefulWidget {
  const NFilledTabBar({
    super.key,
    required this.controller,
    required this.items,
    required this.nameCb,
    this.gradientCb,
    this.height,
    this.backgroundColor,
    this.radius,
    this.itemPadding,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.onChanged,
  });

  final TabController? controller;
  final List<E> items;
  final String Function(E e) nameCb;
  final LinearGradient Function(E e)? gradientCb;

  /// default 36
  final double? height;

  final Color? backgroundColor;

  /// default 8
  final double? radius;

  /// default EdgeInsets.symmetric(horizontal: 8, vertical: 4)
  final EdgeInsets? itemPadding;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;

  final ValueChanged<int>? onChanged;

  @override
  State<NFilledTabBar<E>> createState() => _NFilledTabBarState<E>();
}

class _NFilledTabBarState<E> extends State<NFilledTabBar<E>> with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void dispose() {
    // tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    tabController?.dispose();
    tabController = null;
    tabController ??= widget.controller ?? TabController(length: widget.items.length, vsync: this);
  }

  @override
  void didUpdateWidget(covariant NFilledTabBar<E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.items != widget.items ||
        oldWidget.backgroundColor != widget.backgroundColor) {
      initData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    late final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final height = widget.height ?? 36.0;
    return Container(
      height: height,
      width: double.infinity,
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        return ListenableBuilder(
          listenable: tabController!,
          builder: (context, child) {
            final value = tabController!.index;
            return AnimatedToggleSwitch<int>.size(
              current: value,
              values: List.generate(widget.items.length, (index) => index),
              selectedIconScale: 1,
              iconOpacity: 1,
              height: height,
              indicatorSize: Size.fromWidth(constraints.maxWidth / widget.items.length),
              iconBuilder: (int i) {
                final isSelected = i == value;
                final textStyle = isSelected ? widget.labelStyle : widget.unselectedLabelStyle;

                final e = widget.items[i];

                return Padding(
                  padding: widget.itemPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.nameCb(e),
                      maxLines: 1,
                      style: textStyle ??
                          TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                );
              },
              iconAnimationType: AnimationType.onHover,
              style: ToggleStyle(
                borderRadius: BorderRadius.circular(widget.radius ?? 8),
                // backgroundColor: Colors.white.withOpacity(0.05),
                backgroundColor: widget.backgroundColor,
                borderColor: Colors.transparent,
              ),
              styleBuilder: (i) {
                final e = widget.items[i];

                return ToggleStyle(
                  borderRadius: BorderRadius.circular(widget.radius ?? 8),
                  indicatorGradient: widget.gradientCb?.call(e) ??
                      const LinearGradient(
                        colors: [Colors.red, Colors.purple],
                      ),
                );
              },
              onChanged: (i) {
                if (value == i) {
                  return;
                }
                tabController?.animateTo(i);
                widget.onChanged?.call(i);
              },
            );
          },
        );
      }),
    );
  }
}
