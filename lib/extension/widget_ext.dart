//
//  widget_ext.dart
//  flutter_templet_project
//
//  Created by shang on 5/17/21 10:43 AM.
//  Copyright © 5/17/21 shang. All rights reserved.
//


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

// const double kCupertinoButtonHeight = 56.0;


extension WidgetExt on Widget {

  ///运算符重载
  List<Widget> operator *(int value) {
    var l = <Widget>[];
    for (var i = 0; i < value; i++) {
      l.add(this);
    }
    return l;
  }

  /// 展示边框线
  Widget toBorder({
    Color? color,
    Color borderColor = Colors.blue,
  }) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: borderColor),
    ),
    child: this,
  );

  ColoredBox toColoredBox({
    Color? color,
  }) => ColoredBox(color: color ?? ColorExt.random, child: this,);

  DecoratedBox toDecoratedBox({
    Color color = Colors.blue,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape shape = BoxShape.rectangle,
  }) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      image: image,
      border: border,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      gradient: gradient,
      backgroundBlendMode: backgroundBlendMode,
      shape: shape,
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
    bool semanticsDismissible = false,
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

  ///弹窗
  toShowGeneralDialog({
    required BuildContext context,
    bool barrierDismissible = false,
    String? barrierLabel = 'barrierLabel',
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    VoidCallback? onBarrier,
    Alignment alignment = Alignment.center,
  }) => showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    transitionBuilder: transitionBuilder,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    pageBuilder: (context, animation, secondaryAnimation) {

      return Material(
        color: barrierColor,
        child: InkWell(
          onTap: onBarrier,
          child: Align(
            alignment: alignment,
            child: this,
          ),
        ),
      );
    },
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

  /// 转为 SliverFillRemaining
  SliverFillRemaining toSliverFillRemaining({
    Key? key,
    bool hasScrollBody = true,
    bool fillOverscroll = false,
  }) => SliverFillRemaining(
    key: key,
    hasScrollBody: hasScrollBody,
    fillOverscroll: fillOverscroll,
    child: this,
  );

  /// 转为 ValueListenableBuilder
  ValueListenableBuilder toValueListenableBuilder<T>({
    Key? key,
    required ValueListenable<T> valueListenable,
    Widget? child,
  }) => ValueListenableBuilder<T>(
    valueListenable: valueListenable,
    child: child,
    builder: (context, value, child) {
      return this;
    },
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
    controller: controller,
    thumbVisibility: isAlwaysShown,
    thickness: thickness,
    radius: radius,
    notificationPredicate: notificationPredicate ?? defaultScrollNotificationPredicate,
    child: this,
  );
}


extension FlexExt on Flex {

  /// 转为 SliverToBoxAdapter
  CustomScrollView toCustomScrollView({
    Key? key,
    Widget Function(Widget e)? itemBuilder,
  }) => CustomScrollView(
    key: key,
    slivers: children.map((e) => itemBuilder?.call(e) ?? e.toSliverToBoxAdapter()).toList(),
    clipBehavior: clipBehavior,
  );
}


extension ListViewExt on ListView {

  /// 转为 CustomScrollView
  CustomScrollView toCustomScrollView({
    Widget Function(Widget e)? itemBuilder,
  }) {
    final slivers = (childrenDelegate as SliverChildListDelegate).children.map((e) => itemBuilder?.call(e) ?? e.toSliverToBoxAdapter()).toList();
    return CustomScrollView(
      key: key,
      slivers: slivers,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      scrollBehavior: scrollBehavior,
      shrinkWrap: shrinkWrap,
      center: center,
      anchor: anchor,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
    );
  }
}


extension CustomScrollViewExt on CustomScrollView {

  /// 转为 ListView
  ListView toListView() {
    final children = slivers.map((e) => (e is SliverToBoxAdapter ? e.child ?? SizedBox() : e)).toList();
    return ListView(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      children: children,
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
    final children = slivers.map((e) => (e is SliverToBoxAdapter ? e.child ?? SizedBox() : e)).toList();
    return Flex(
      key: key,
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

  // ///添加分割符
  // Widget addBottomSeparator({
  //   EdgeInsets margin = const EdgeInsets.symmetric(horizontal:10),
  //   EdgeInsets padding = const EdgeInsets.all(0),
  //   double height = 0.5,
  //   Color color = const Color(0xffeeeeee),
  // }) {
  //   return Container(
  //     margin: margin,
  //     padding: padding,
  //     decoration: BoxDecoration(
  //       border: Border(
  //         bottom: BorderSide(width: height, color: color),
  //       )
  //     ),
  //     child: this,
  //   );
  // }
}

