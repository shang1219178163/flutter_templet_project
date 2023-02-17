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
import 'package:flutter_templet_project/basicWidget/nn_picker_tool_bar.dart';
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
    RenderObject? renderObj = this.findRenderObject();
    return renderObj is RenderBox ? renderObj : null;
  }

  /// 获取当前组件的坐标点
  Offset? origin({Offset offset = Offset.zero}) {
    return this.renderBox?.localToGlobal(offset); //组件坐标
  }

  /// 获取当前组件的 Size
  Size? get renderBoxSize => this.renderBox?.size;

  double? minX({Offset offset = Offset.zero}) {
    return this.origin(offset: offset)?.dx;
  }

  double? minY({Offset offset = Offset.zero}) {
    return this.origin(offset: offset)?.dy;
  }

  double? maxX({Offset offset = Offset.zero}) {
    if (this.minX(offset: offset) == null || this.size == null) {
      return null;
    }
    return this.minX(offset: offset)! + this.size!.width;
  }

  double? maxY({Offset offset = Offset.zero}) {
    if (this.minX(offset: offset) == null || this.size == null) {
      return null;
    }
    return this.minX(offset: offset)! + this.size!.height;
  }

  double? midX({Offset offset = Offset.zero}) {
    if (this.minX(offset: offset) == null || this.size == null) {
      return null;
    }
    return this.origin()!.dx + this.size!.width * 0.5;
  }

  double? midY({Offset offset = Offset.zero}) {
    if (this.minX(offset: offset) == null || this.size == null) {
      return null;
    }
    return this.origin()!.dy + this.size!.height * 0.5;
  }

  ///扩展方法
  void logRendBoxInfo() {
    print([DateTime.now(), this.origin(), this.size]);
  }

  /// 扩展属性 Theme.of(this.context)
  get theme => Theme.of(this);
  /// 扩展属性 Theme.of(this.context).primaryColor
  get primaryColor => Theme.of(this).primaryColor;
  /// 扩展属性 MediaQuery.of(this.context)
  get mediaQuery => MediaQuery.of(this);
  /// 扩展属性 MediaQuery.of(this.context).size
  get screenSize => mediaQuery.size;
  /// 扩展属性 MediaQuery.of(this).devicePixelRatio
  get devicePixelRatio => mediaQuery.devicePixelRatio;

  // 有刘海的屏幕:44 没有刘海的屏幕为20
  get statusBarHeight => mediaQuery.padding.header;
  // 有刘海的屏幕:34 没有刘海的屏幕0
  get bottomHeight => mediaQuery.padding.bottom;

  get scaffoldMessenger => ScaffoldMessenger.of(this);


  /// 清除 SnackBar
  clearSnackBars() {
    scaffoldMessenger.clearSnackBars();
  }

  /// 隐藏 SnackBar
  hideSnackBar({bool isClear = false}) {
    if (isClear) {
      scaffoldMessenger.clearSnackBars();
    } else {
      scaffoldMessenger.hideCurrentSnackBar();
    }
  }

  /// 展示 SnackBar
  showSnackBar(SnackBar snackBar, {bool isClear = false, bool isReplace = false}) {
    if (isClear) {
      scaffoldMessenger.clearSnackBars();
    }
    if (isReplace) {
      scaffoldMessenger.hideCurrentSnackBar();
    }
    hideSnackBar(isClear: isClear);
    scaffoldMessenger.showSnackBar(snackBar);
  }

  /// 隐藏 MaterialBanner
  hideMaterialBanner({bool isClear = false}) {
    if (isClear) {
      scaffoldMessenger.clearMaterialBanners();
    } else {
      scaffoldMessenger.hideCurrentMaterialBanner();
    }
  }

  /// 清除 MaterialBanner
  clearMaterialBanners() {
    scaffoldMessenger.clearMaterialBanners();
  }

  /// 展示 MaterialBanner
  showMaterialBanner(MaterialBanner banner, {bool isClear = false, bool isReplace = false}) {
    if (isClear) {
      scaffoldMessenger.clearMaterialBanners();
    }
    if (isReplace) {
      scaffoldMessenger.hideCurrentMaterialBanner();
    }
    scaffoldMessenger.showMaterialBanner(banner);
  }

  ///alert弹窗
  showCupertinoSheet({
    Widget? title,
    Widget? message,
    List<Widget> items = const [],
    ScrollController? messageScrollController,
    ScrollController? actionScrollController,
    required Widget cancel,
    required Function(BuildContext context, int index)? onSelect,
    Function(BuildContext context)? onCancell,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
  }) {
    final child =
    CupertinoActionSheet(
      title: title,
      message: message,
      actions: items.map((e) => CupertinoActionSheetAction(
        child: e,
        onPressed: () {
          if (onSelect != null) {
            onSelect(this, items.indexOf(e));
          }
          Navigator.pop(this);
        },
      ),).toList(),
      cancelButton: CupertinoActionSheetAction(
        child: cancel,
        isDestructiveAction: true,
        onPressed: onCancell != null ? onCancell(this) : () {
          Navigator.pop(this);
        },
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
    required void callback(String title)
  }) {

    final title = "请选择";
    final actionTitles = ['取消', '确定'];

    final widget =
    Container(
      height: height,
      // color: Color.fromARGB(255, 255, 255, 255),
      color: Colors.white,
      child: Column(
        children: [
          NNPickerToolBar(
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
    // required void Function(DateTime dateTime, String title) callback}) {
    required void callback(DateTime dateTime, String title)}) {

    DateTime dateTime = initialDateTime ?? DateTime.now();

    final title = "请选择";
    final actionTitles = ['取消', '确定'];

    final widget =
    Container(
      height: 300,
      // color: Color.fromARGB(255, 255, 255, 255),
      color: Colors.white,
      child: Column(
        children: [
          NNPickerToolBar(
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
    required void callback(int index, String title)}) {

    int selectedIndex = 0;

    return showBottomPicker(
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

extension StatefulWidgetExt<T extends StatefulWidget> on State<T> {
  /// 扩展属性 Theme.of(this.context)
  get theme => this.context.theme;
  /// 扩展属性 MediaQuery.of(this.context)
  get mediaQuery => this.context.mediaQuery;
  /// 扩展属性 MediaQuery.of(this.context).size
  get screenSize => this.context.screenSize;
  /// 扩展属性 MediaQuery.of(this).devicePixelRatio
  get devicePixelRatio => this.context.devicePixelRatio;

  /// 扩展属性 ScaffoldMessenger.of(this.context);
  get scaffoldMessenger => this.context.scaffoldMessenger;
  /// 扩展方法
  showSnackBar(SnackBar snackBar, {bool isClear = false}) => this.context.showSnackBar(snackBar, isClear: isClear);
}


extension GlobalKeyExt on GlobalKey{

  /// 获取当前组件的 RenderBox
  RenderBox? get renderBox => this.currentContext?.renderBox;
  /// 获取当前组件的 position
  Offset? position({Offset offset = Offset.zero}) => this.currentContext?.origin(offset: offset);
  /// 获取当前组件的 Size
  Size? get size => this.currentContext?.size;

  double? minX({Offset offset = Offset.zero}) => this.currentContext?.minX(offset: offset);
  double? minY({Offset offset = Offset.zero}) => this.currentContext?.minY(offset: offset);
  double? midX({Offset offset = Offset.zero}) => this.currentContext?.midX(offset: offset);
  double? midY({Offset offset = Offset.zero}) => this.currentContext?.midY(offset: offset);
  double? maxX({Offset offset = Offset.zero}) => this.currentContext?.maxX(offset: offset);
  double? maxY({Offset offset = Offset.zero}) => this.currentContext?.maxY(offset: offset);

}


// extension StatefulWidgetExt<T extends StatefulWidget> on State<T> {
//   /// 扩展属性 ScaffoldMessenger.of(this.context);
//   get scaffoldMessenger => ScaffoldMessenger.of(this.context);
//   /// 扩展方法
//   void showSnackBar(SnackBar snackBar, [bool isReplace = false]) {
//     if (isReplace) {
//       // scaffoldMessenger.hideCurrentSnackBar();
//       scaffoldMessenger.clearSnackBars();
//     }
//     scaffoldMessenger.showSnackBar(snackBar);
//   }
//
//   /// 扩展属性 Theme.of(this.context)
//   get theme => Theme.of(this.context);
//   /// 扩展属性 MediaQuery.of(this.context)
//   get mediaQuery => MediaQuery.of(this.context);
//   /// 扩展属性 MediaQuery.of(this.context).size
//   get screenSize => MediaQuery.of(this.context).size;
// }

// extension SnackBarExt on SnackBar {
//
//   void showBy(BuildContext context, [bool isReplace = false]) {
//     if (isReplace) {
//       context.scaffoldMessenger.hideCurrentSnackBar();
//     }
//     context.scaffoldMessenger.showSnackBar(this);
//   }
// }


// extension SmartIterable<T> on Iterable<T> {
//   void doTheSmartThing(void Function(T) smart) {
//     for (var e in this) smart(e);
//   }
// }
// extension SmartList<T> on List<T> {
//   void doTheSmartThing(void Function(T) smart) {
//     for (int i = 0; i < length; i++) smart(this[i]);
//   }
// }