//
//  widget_extension.dart
//  flutter_templet_project
//
//  Created by shang on 5/17/21 10:43 AM.
//  Copyright © 5/17/21 shang. All rights reserved.
//


import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

const double kCupertinoButtonHeight = 56.0;

///默认分割线
const Divider kDivider = Divider(
  height: .5,
  indent: 15,
  endIndent: 15,
  color: Color(0xFFDDDDDD),
);


extension WidgetExt on Widget {

  toShowCupertinoDialog({
    required BuildContext context,
    String? barrierLabel,
    bool useRootNavigator = true,
    bool barrierDismissible = false,
    RouteSettings? routeSettings,
  }) => showCupertinoDialog(
    context: context,
    builder: (context) => this,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    routeSettings: routeSettings,
  );

  ///底部弹窗
  toShowModalBottomSheet({
    required BuildContext context,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) => showModalBottomSheet(
    context: context,
    builder: (context) => this,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    barrierColor: barrierColor,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
  );

  ///正面弹窗
  toShowDialog({
    required BuildContext context,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) => showDialog(
    context: context,
    builder: (context) => this,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    routeSettings: routeSettings,
  );
}

extension ScrollViewExt on ScrollView {
  CupertinoScrollbar addCupertinoScrollbar({
    Key? key,
    ScrollController? controller,
    bool isAlwaysShown = false,
    double thickness = CupertinoScrollbar.defaultThickness,
    thicknessWhileDragging = CupertinoScrollbar.defaultThicknessWhileDragging,
    Radius radius = CupertinoScrollbar.defaultRadius,
    radiusWhileDragging = CupertinoScrollbar.defaultRadiusWhileDragging,
    ScrollNotificationPredicate? notificationPredicate,
  }) =>
      CupertinoScrollbar(
        key: key,
        child: this,
        controller: controller,
        isAlwaysShown: isAlwaysShown,
        thickness: thickness,
        radius: radius,
        notificationPredicate: notificationPredicate ?? defaultScrollNotificationPredicate,
      );
}

extension ListTileExt on ListTile {

  ///添加分割符
  Widget addBottomSeparator({
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal:10),
    EdgeInsets padding = const EdgeInsets.all(0),
    double height = 0.5,
    Color color = const Color(0xffeeeeee),
  }) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: height, color: color),
        )
      ),
      child: this,
    );
  }
}

