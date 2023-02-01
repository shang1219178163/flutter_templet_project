//
//  widget_ext.dart
//  flutter_templet_project
//
//  Created by shang on 5/17/21 10:43 AM.
//  Copyright © 5/17/21 shang. All rights reserved.
//


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
  /// 展示边框线
  Widget toContainer({
    Color? color,
    Color borderColor = Colors.blue,
  }) => Container(
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: borderColor),
    ),
    child: this,
  );

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

  ///showCupertinoModalPopup
  toShowCupertinoModalPopup({
    required BuildContext context,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
  }) => showCupertinoModalPopup(
    context: context,
    builder: (context) => this,
    filter: filter,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    semanticsDismissible: semanticsDismissible,
    routeSettings: routeSettings,
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

  /// 加拟物风格
  toNeumorphism({
    double borderRadius = 10.0,
    Offset offset = const Offset(5, 5),
    double blurRadius = 10,
    Color topShadowColor = Colors.white60,
    Color bottomShadowColor = const Color(0x26234395),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            offset: offset,
            blurRadius: blurRadius,
            color: bottomShadowColor,
          ),
          BoxShadow(
            offset: Offset(-offset.dx, -offset.dy),
            blurRadius: blurRadius,
            color: topShadowColor,
          ),
        ],
      ),
      child: this,
    );
  }

  /// 转为 SliverToBoxAdapter
  SliverToBoxAdapter toSliverToBoxAdapter({
    Key? key,
    }) => SliverToBoxAdapter(
      key: key,
      child: this,
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
  }) => CupertinoScrollbar(
    key: key,
    child: this,
    controller: controller,
    isAlwaysShown: isAlwaysShown,
    thickness: thickness,
    radius: radius,
    notificationPredicate: notificationPredicate ?? defaultScrollNotificationPredicate,
  );
}


extension FlexExt on Flex {

  /// 转为 SliverToBoxAdapter
  CustomScrollView toCustomScrollView({
    Key? key,
  }) => CustomScrollView(
    key: key,
    slivers: this.children.map((e) => e.toSliverToBoxAdapter()).toList(),
    clipBehavior: this.clipBehavior,
  );
}


extension ListViewExt on ListView {

  /// 转为 CustomScrollView
  CustomScrollView toCustomScrollView() {
    final slivers = (this.childrenDelegate as SliverChildListDelegate).children.map((e) => e.toSliverToBoxAdapter()).toList();
    return CustomScrollView(
      key: this.key,
      slivers: slivers,
      scrollDirection: this.scrollDirection,
      reverse: this.reverse,
      controller: this.controller,
      primary: this.primary,
      physics: this.physics,
      scrollBehavior: this.scrollBehavior,
      shrinkWrap: this.shrinkWrap,
      center: this.center,
      anchor: this.anchor,
      cacheExtent: this.cacheExtent,
      semanticChildCount: this.semanticChildCount,
      dragStartBehavior: this.dragStartBehavior,
      keyboardDismissBehavior: this.keyboardDismissBehavior,
      restorationId: this.restorationId,
      clipBehavior: this.clipBehavior,
    );
  }
}


extension CustomScrollViewExt on CustomScrollView {

  /// 转为 ListView
  ListView toListView() {
    final children = this.slivers.map((e) => (e as SliverToBoxAdapter).child!).toList();
    return ListView(
      key: this.key,
      children: children,
      scrollDirection: this.scrollDirection,
      reverse: this.reverse,
      controller: this.controller,
      primary: this.primary,
      physics: this.physics,
      shrinkWrap: this.shrinkWrap,
      cacheExtent: this.cacheExtent,
      semanticChildCount: this.semanticChildCount,
      dragStartBehavior: this.dragStartBehavior,
      keyboardDismissBehavior: this.keyboardDismissBehavior,
      restorationId: this.restorationId,
      clipBehavior: this.clipBehavior,
    );
  }

  /// 转为 Flex
  Flex toFlex({
    direction = Axis.vertical,
    mainAxisAlignment = MainAxisAlignment.start,
    mainAxisSize = MainAxisSize.max,
    crossAxisAlignment = CrossAxisAlignment.center,
    TextBaseline? textBaseline,
    verticalDirection = VerticalDirection.down,
    TextDirection? textDirection,
    clipBehavior = Clip.none,
  }) {
    final children = this.slivers.map((e) => (e is SliverToBoxAdapter ? e.child ?? SizedBox() : e)).toList();
    return Flex(
      key: this.key,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
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

