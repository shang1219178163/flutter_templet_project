//
//  TabExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/9/2 15:29.
//  Copyright © 2023/9/2 shang. All rights reserved.
//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

extension TabBarExt on TabBar {
  /// 自定义 copy
  TabBar copy({
    List<Widget>? tabs,
    TabController? controller,
    bool? isScrollable,
    EdgeInsetsGeometry? padding,
    Color? indicatorColor,
    double? indicatorWeight,
    EdgeInsetsGeometry? indicatorPadding,
    Decoration? indicator,
    bool? automaticIndicatorColorAdjustment,
    TabBarIndicatorSize? indicatorSize,
    Color? dividerColor,
    Color? labelColor,
    Color? unselectedLabelColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    EdgeInsetsGeometry? labelPadding,
    MaterialStateProperty<Color?>? overlayColor,
    DragStartBehavior? dragStartBehavior,
    MouseCursor? mouseCursor,
    bool? enableFeedback,
    ValueChanged<int>? onTap,
    ScrollPhysics? physics,
    InteractiveInkFeatureFactory? splashFactory,
    BorderRadius? splashBorderRadius,
  }) {
    return TabBar(
      tabs: tabs ?? this.tabs,
      controller: controller ?? this.controller,
      isScrollable: isScrollable ?? this.isScrollable,
      padding: padding ?? this.padding,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment ??
          this.automaticIndicatorColorAdjustment,
      indicatorWeight: indicatorWeight ?? this.indicatorWeight,
      indicatorPadding: indicatorPadding ?? this.indicatorPadding,
      indicator: indicator ?? this.indicator,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      dividerColor: dividerColor ?? this.dividerColor,
      labelColor: labelColor ?? this.labelColor,
      labelStyle: labelStyle ?? this.labelStyle,
      labelPadding: labelPadding ?? this.labelPadding,
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      overlayColor: overlayColor ?? this.overlayColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      onTap: onTap ?? this.onTap,
      physics: physics ?? this.physics,
      splashFactory: splashFactory ?? this.splashFactory,
      splashBorderRadius: splashBorderRadius ?? this.splashBorderRadius,
    );
  }

  /// 覆盖除了 tabs 和 controller 之外的所有属性
  TabBar cover(TabBar? tabBar) {
    if (tabBar == null) {
      return this;
    }

    return TabBar(
      tabs: tabs,
      controller: controller,
      isScrollable: tabBar.isScrollable,
      padding: tabBar.padding ?? padding,
      indicatorColor: tabBar.indicatorColor ?? indicatorColor,
      automaticIndicatorColorAdjustment:
          tabBar.automaticIndicatorColorAdjustment,
      indicatorWeight: tabBar.indicatorWeight,
      indicatorPadding: tabBar.indicatorPadding,
      indicator: tabBar.indicator ?? indicator,
      indicatorSize: tabBar.indicatorSize ?? indicatorSize,
      dividerColor: tabBar.dividerColor ?? dividerColor,
      labelColor: tabBar.labelColor ?? labelColor,
      labelStyle: tabBar.labelStyle ?? labelStyle,
      labelPadding: tabBar.labelPadding ?? labelPadding,
      unselectedLabelColor: tabBar.unselectedLabelColor ?? unselectedLabelColor,
      unselectedLabelStyle: tabBar.unselectedLabelStyle ?? unselectedLabelStyle,
      dragStartBehavior: tabBar.dragStartBehavior,
      overlayColor: tabBar.overlayColor ?? overlayColor,
      mouseCursor: tabBar.mouseCursor ?? mouseCursor,
      enableFeedback: tabBar.enableFeedback ?? enableFeedback,
      onTap: tabBar.onTap ?? onTap,
      physics: tabBar.physics ?? physics,
      splashFactory: tabBar.splashFactory ?? splashFactory,
      splashBorderRadius: tabBar.splashBorderRadius ?? splashBorderRadius,
    );
  }
}
