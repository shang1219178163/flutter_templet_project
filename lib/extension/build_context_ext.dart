//
//  build_context_ext.dart
//  flutter_templet_project
//
//  Created by shang on 10/14/21 2:21 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';
import 'package:flutter_templet_project/extension/bottom_sheet_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

extension BuildContextExt on BuildContext {
  // final state = (context as StatefulElement).state as CustomeTabBarState;
  /// 通过 context 获取 state, builder 里使用
  T? getStatefulElementState<T>() {
    if (this is StatefulElement && (this as StatefulElement).state is T) {
      return (this as StatefulElement).state as T;
    }
    return null;
  }

  /// 获取当前组件的 RenderBox
  RenderBox? get renderBox {
    var renderObj = findRenderObject();
    return renderObj is RenderBox ? renderObj : null;
  }

  /// 获取当前组件的坐标点
  Offset? origin({Offset offset = Offset.zero}) {
    return renderBox?.localToGlobal(offset); //组件坐标
  }

  /// 获取当前组件的 Size
  Size? get renderBoxSize => renderBox?.size;

  double? minX({Offset offset = Offset.zero}) {
    return origin(offset: offset)?.dx;
  }

  double? minY({Offset offset = Offset.zero}) {
    return origin(offset: offset)?.dy;
  }

  double? maxX({Offset offset = Offset.zero}) {
    if (minX(offset: offset) == null || size == null) {
      return null;
    }
    return minX(offset: offset)! + size!.width;
  }

  double? maxY({Offset offset = Offset.zero}) {
    if (minX(offset: offset) == null || size == null) {
      return null;
    }
    return minX(offset: offset)! + size!.height;
  }

  double? midX({Offset offset = Offset.zero}) {
    if (minX(offset: offset) == null || size == null) {
      return null;
    }
    return origin()!.dx + size!.width * 0.5;
  }

  double? midY({Offset offset = Offset.zero}) {
    if (minX(offset: offset) == null || size == null) {
      return null;
    }
    return origin()!.dy + size!.height * 0.5;
  }

  ///扩展方法
  void logRendBoxInfo() {
    debugPrint("${[DateTime.now(), origin(), size]}");
  }

  /// 扩展属性 Theme.of(context)
  ThemeData get theme => Theme.of(this);
  /// 扩展属性 Theme.of(context).primaryColor
  Color get primaryColor => theme.primaryColor;
  /// 扩展属性 MediaQuery.of(context)
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  /// 扩展属性 MediaQuery.of(context).size
  Size get screenSize => mediaQuery.size;
  /// 扩展属性 MediaQuery.of(this).devicePixelRatio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// 安全区域距离顶部高度(电池栏高度:有刘海的屏幕:47 没有刘海的屏幕为20)
  double get safeAreaTop => mediaQuery.viewPadding.top;
  /// 安全区域底部高度(有刘海的屏幕:34 没有刘海的屏幕0)
  double get safeAreaBottom => mediaQuery.viewPadding.bottom;

  /// 状态栏高度
  double get statusBarHeight => mediaQuery.padding.top;
  /// appbar 高度
  double get appBarHeight => kToolbarHeight;

  /// 弹出键盘为0,不弹为 34(有 BottomNavigationBar为 0)
  double get paddingBottom => mediaQuery.padding.bottom;

  /// 键盘顶部距离屏幕下边的距离(有键盘:键盘高度 + 34, 无键盘为 0)
  double get viewBottomShowKeyboard => mediaQuery.viewInsets.bottom;

  /// 视图距离底边的高度(有键盘:键盘高度 + 34, 无键盘 0)
  double get viewBottom => mediaQuery.viewInsets.bottom;


  ///alert弹窗
  showCupertinoSheet({
    Widget? title,
    Widget? message,
    List<Widget> items = const [],
    ScrollController? messageScrollController,
    ScrollController? actionScrollController,
    required Widget cancel,
    required ValueChanged<int>? onSelected,
    VoidCallback? onCancel,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
  }) {
    final child = CupertinoActionSheet(
      title: title,
      message: message,
      actions: items.map((e) => CupertinoActionSheetAction(
        onPressed: () {
          onSelected?.call(items.indexOf(e));
          Navigator.pop(this);
        },
        child: e,
      ),).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: onCancel ?? () {
          Navigator.pop(this);
        },
        child: cancel,
      ),
    );

    showCupertinoModalPopup(
      context: this,
      builder: (context) => child,
      filter: filter,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      semanticsDismissible: semanticsDismissible,
      routeSettings: routeSettings,
    );
  }

  /// 底部选择器
  showBottomPicker({
    double? height = 300,
    required Widget child,
    required void Function(String title) callback,
  }) {

    const title = "请选择";
    final actionTitles = ['取消', '确定'];

    final widget =
    Container(
      height: height,
      // color: Color.fromARGB(255, 255, 255, 255),
      color: Colors.white,
      child: Column(
        children: [
          NPickerToolBar(
            onCancel: (){
              callback(actionTitles[0]);
              Navigator.of(this).pop();
            },
            onConfirm: (){
              callback(actionTitles[1]);
              Navigator.of(this).pop();
            },
          ),
          Divider(),
          Expanded(
            child: Container(
              // height: (height ?? 300) - kCupertinoButtonHeight,
              color: Colors.white,
              child: child,
            )
          ),
        ],
      ),
    );

    return showModalBottomSheet(
      context: this,
      builder: (BuildContext context) {
        return widget;
      }
    );
  }

  /// 时间选择器
  showDatePicker({
    DateTime? initialDateTime,
    CupertinoDatePickerMode? mode,
    required void Function(DateTime dateTime, String title) callback
  }) {
    var dateTime = initialDateTime ?? DateTime.now();

    const title = "请选择";
    final actionTitles = ['取消', '确定'];

    final widget =
    Container(
      height: 300,
      // color: Color.fromARGB(255, 255, 255, 255),
      color: Colors.white,
      child: Column(
        children: [
          NPickerToolBar(
            onCancel: (){
              callback(dateTime, actionTitles[0]);
              Navigator.of(this).pop();
            },
            onConfirm: (){
              callback(dateTime, actionTitles[1]);
              Navigator.of(this).pop();
            },
          ),
          Divider(),
          Container(
            height: 216,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: mode ?? CupertinoDatePickerMode.date,
              initialDateTime: initialDateTime,
              onDateTimeChanged: (val) {
                dateTime = val;
              }),
          ),
        ],
      ),
    );

    return showModalBottomSheet(
      context: this,
      builder: (BuildContext context) {
        return widget;
      }
    );
  }


  /// 列表选择器
  showPickerList({
    required List<Widget> children,
    required void Function(int index, String title) callback
  }) {

    var selectedIndex = 0;

    return showBottomPicker(
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 30,
        scrollController: FixedExtentScrollController(initialItem: 1),
        onSelectedItemChanged: (value) {
          selectedIndex = value;
        },
        children: children,
      ),
      callback: (title){
        callback(selectedIndex, title);
        ddlog([selectedIndex, title]);
      });
  }
}

extension StatefulWidgetExt<T extends StatefulWidget> on State<T> {
  /// 扩展属性 Theme.of(context)
  ThemeData get theme => context.theme;

  /// 扩展属性 Theme.of(context)
  Color get primaryColor => theme.primaryColor;

  /// 扩展属性 MediaQuery.of(context)
  MediaQueryData get mediaQuery => context.mediaQuery;

  /// 弹出键盘时键盘顶部高度
  double get keyboardBottom => context.viewBottomShowKeyboard;

  /// 安全区域距离顶部高度(电池栏高度:有刘海的屏幕:44 没有刘海的屏幕为20)
  double get safeAreaTop => context.safeAreaTop;

  /// 没有弹出键盘时底部高度(有刘海的屏幕:34 没有刘海的屏幕0)
  double get safeAreaBottom => context.safeAreaBottom;

  /// 弹出键盘为0,不弹为 34
  double get paddingBottom => context.paddingBottom;


  /// 扩展属性 MediaQuery.of(context).size
  Size get screenSize => context.screenSize;
  /// 扩展属性 MediaQuery.of(.devicePixelRatio
  double get devicePixelRatio => context.devicePixelRatio;

}


extension GlobalKeyExt on GlobalKey{

  /// 获取当前组件的 RenderBox
  RenderBox? get renderBox => currentContext?.renderBox;
  /// 获取当前组件的 position
  Offset? position({Offset offset = Offset.zero}) => currentContext?.origin(offset: offset);
  /// 获取当前组件的 Size
  Size? get size => currentContext?.size;

  double? minX({Offset offset = Offset.zero}) => currentContext?.minX(offset: offset);
  double? minY({Offset offset = Offset.zero}) => currentContext?.minY(offset: offset);
  double? midX({Offset offset = Offset.zero}) => currentContext?.midX(offset: offset);
  double? midY({Offset offset = Offset.zero}) => currentContext?.midY(offset: offset);
  double? maxX({Offset offset = Offset.zero}) => currentContext?.maxX(offset: offset);
  double? maxY({Offset offset = Offset.zero}) => currentContext?.maxY(offset: offset);

}
