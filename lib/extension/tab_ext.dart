//
//  TabExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/9/2 15:29.
//  Copyright © 2023/9/2 shang. All rights reserved.
//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


extension TabBarExt on TabBar{
  /// 自定义 copy
  TabBar copy({
    List<Widget>? tabs,
    TabController? controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
    Color? indicatorColor,
    double indicatorWeight = 2.0,
    EdgeInsetsGeometry indicatorPadding = EdgeInsets.zero,
    Decoration? indicator,
    bool automaticIndicatorColorAdjustment = true,
    TabBarIndicatorSize? indicatorSize,
    Color? dividerColor,
    Color? labelColor,
    Color? unselectedLabelColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    EdgeInsetsGeometry? labelPadding,
    MaterialStateProperty<Color?>? overlayColor,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
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
      isScrollable: isScrollable,
      padding: padding ?? this.padding,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment,
      indicatorWeight: indicatorWeight,
      indicatorPadding: indicatorPadding,
      indicator: indicator ?? this.indicator,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      dividerColor: dividerColor ?? this.dividerColor,
      labelColor: labelColor ?? this.labelColor,
      labelStyle: labelStyle ?? this.labelStyle,
      labelPadding: labelPadding ?? this.labelPadding,
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      dragStartBehavior: dragStartBehavior,
      overlayColor: overlayColor ?? this.overlayColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      onTap: onTap ?? this.onTap,
      physics: physics ?? this.physics,
      splashFactory: splashFactory ?? this.splashFactory,
      splashBorderRadius: splashBorderRadius ?? this.splashBorderRadius,
    );
  }
}