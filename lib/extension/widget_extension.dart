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
import 'package:styled_widget/styled_widget.dart';

const double kCupertinoButtonHeight = 56.0;

///默认分割线
const Divider kDivider = Divider(
  height: .5,
  indent: 15,
  endIndent: 15,
  color: Color(0xFFDDDDDD),
);


extension WidgetExt on Widget {

  Container toContainer({
    Key? key,
    alignment,
    padding,
    color,
    decoration,
    foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    margin,
    transform,
    transformAlignment,
    child,
    clipBehavior = Clip.none,
  }) => Container(
    key: key,
    alignment: alignment,
    padding: padding,
    color: color,
    decoration: decoration,
    foregroundDecoration: foregroundDecoration,
    width: width,
    height: height,
    constraints: constraints,
    margin: margin,
    transform: transform,
    transformAlignment: transformAlignment,
    clipBehavior: clipBehavior,
    child: this,
  );


  Material toMaterial({
    Key? key,
    type = MaterialType.canvas,
    elevation = 0.0,
    color,
    shadowColor,
    textStyle,
    borderRadius,
    shape,
    borderOnForeground = true,
    clipBehavior = Clip.none,
    animationDuration = kThemeChangeDuration,
    child,
  }) => Material(
    key: key,
    type: type,
    elevation: elevation,
    color: color,
    shadowColor: shadowColor,
    textStyle: textStyle,
    borderRadius: borderRadius,
    shape: shape,
    borderOnForeground: borderOnForeground,
    clipBehavior: clipBehavior,
    animationDuration: animationDuration,
    child: this,
  );

  // toShowCupertinoDialog({
  //   required BuildContext context,
  //   String? barrierLabel,
  //   bool useRootNavigator = true,
  //   bool barrierDismissible = false,
  //   RouteSettings? routeSettings,
  // }) => showCupertinoDialog(
  //   context: context,
  //   builder: (context) => this,
  //   barrierLabel: barrierLabel,
  //   useRootNavigator: useRootNavigator,
  //   barrierDismissible: barrierDismissible,
  //   routeSettings: routeSettings,
  // );

  ///底部弹窗
  void toShowModalBottomSheet({
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
  void toShowDialog({
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

  ConstrainedBox toConstrainedBox({
    Key? key,
    required BoxConstraints constraints,
  }) => ConstrainedBox(
    key: key,
    constraints: constraints,
    child: this,
  );

  /// 底部选择器
  void showBottomPicker({
    required BuildContext context,
    double? height = 300,
    required Widget child,
    required void callback(String title)}) {

    final title = "请选择";
    final actionTitles = ['取消', '确定'];

    Container(
      height: height,
      // color: Color.fromARGB(255, 255, 255, 255),
      color: Colors.white,
      child: Column(
        children: [
          Row(children: [
            // Close the modal
            CupertinoButton(
              child: Text(actionTitles[0]),
              // onPressed: () => Navigator.of(ctx).pop(),
              onPressed: (){
                callback(actionTitles[0]);
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: Text(title,
              style: TextStyle(fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                  backgroundColor: Colors.white,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,)
            ),

            CupertinoButton(
              child: Text(actionTitles[1]),
              // onPressed: () => Navigator.of(ctx).pop(),
              onPressed: (){
                callback(actionTitles[1]);
                Navigator.of(context).pop();
              },
            ),
          ],),
          Divider(),
          Container(
            // height: (height ?? 300) - kCupertinoButtonHeight,
            color: Colors.white,
            child: child,
          ).expanded(),
        ],
      ),
    )
        .toShowModalBottomSheet(context: context)
    ;
    
  }

  /// 时间选择器
  void showDatePicker({
    required BuildContext context,
    DateTime? initialDateTime,
    CupertinoDatePickerMode? mode,
    // required void Function(DateTime dateTime, String title) callback}) {
    required void callback(DateTime dateTime, String title)}) {

    DateTime dateTime = initialDateTime ?? DateTime.now();

    final title = "请选择";
    final actionTitles = ['取消', '确定'];

    Container(
      height: 300,
      // color: Color.fromARGB(255, 255, 255, 255),
      color: Colors.white,
      child: Column(
        children: [
          Row(children: [
            // Close the modal
            CupertinoButton(
              child: Text(actionTitles[0]),
              // onPressed: () => Navigator.of(ctx).pop(),
              onPressed: (){
                callback(dateTime, actionTitles[0]);
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: Text(title,
              style: TextStyle(fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,)
            ),

            CupertinoButton(
              child: Text(actionTitles[1]),
              // onPressed: () => Navigator.of(ctx).pop(),
              onPressed: (){
                callback(dateTime, actionTitles[1]);
                Navigator.of(context).pop();
              },
            ),
          ],),
          Container(
            height: 216,
            color: Colors.white,
            child: CupertinoDatePicker(
                mode: mode ?? CupertinoDatePickerMode.date,
                initialDateTime: initialDateTime,
                onDateTimeChanged: (val) {
                  dateTime = val;
                  // ddlog(val);
                }),
          ),
        ],
      ),
    ).toShowModalBottomSheet(context: context);
  }


  /// 列表选择器
  void showPickerList({
    required BuildContext context,
    required List<Widget> children,
    required void callback(int index, String title)}) {

    int selectedIndex = 0;

    showBottomPicker(
        context: context,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          itemExtent: 30,
          scrollController: FixedExtentScrollController(initialItem: 1),
          children: children,
          onSelectedItemChanged: (value) {
            selectedIndex = value;
          },
        ),
        callback: (title){
          callback(selectedIndex, title);
          ddlog([selectedIndex, title]);
        });
  }
}

extension DateTimeExt on DateTime {
  String toString19() => this.toString().split(".").first;

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



extension ConstrainedBoxExt on ConstrainedBox {
  SingleChildScrollView toSingleChildScrollView({
    Key? key,
    scrollDirection,
    reverse,
    padding,
    primary,
    physics,
    controller,
    dragStartBehavior,
    clipBehavior,
    restorationId,
    keyboardDismissBehavior,

  }) => SingleChildScrollView(
    key: key,
    scrollDirection: scrollDirection,
    reverse: reverse,
    padding: padding,
    primary: primary,
    physics: physics,
    controller: controller,
    child: this,
    dragStartBehavior: dragStartBehavior,
    clipBehavior: clipBehavior,
    restorationId: restorationId,
    keyboardDismissBehavior: keyboardDismissBehavior,
  );
}


extension ListTileExt on ListTile {

  ///添加分割符
  Widget addBottomSeparator({
    EdgeInsets inset = const EdgeInsets.symmetric(horizontal:10),
    double height = 0.5,
    Color color = const Color(0xffeeeeee),
  }) {
    return Container(
      margin: inset,
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: height, color: color),
          )
      ),
      child: this,
    );
  }
}


extension GetDynamicExt<T> on T {

  /// 返回可选值或者 `else` 闭包返回的值
  /// 例如. nullable.or(else: {
  /// ... code
  /// })
  T or(T Function() block) {
    return this ?? block();
  }
}

extension IterableExt<T> on Iterable<T> {

  double sum(double Function(T) extract) {
    double result = 0.0;
    for (T element in this) {
      result += extract(element);
    }
    return result;
  }
}

// extension on dynamic{
//
//   dynamic or({required dynamic callback()}) async {
//     return this ?? callback();
//   }
//
// }

// extension NullExt on Null{
//
//   dynamic or({required dynamic callback()}) async {
//     return
//   }
//
// }


