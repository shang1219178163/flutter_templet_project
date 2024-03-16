//
//  BottomSheetExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/14 14:46.
//  Copyright © 2023/1/14 shang. All rights reserved.
//


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';


mixin BottomSheetMixin{

  /// CupertinoSheet 弹窗
  presentCupertinoActionSheet({
    required BuildContext context,
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
    bool semanticsDismissible = false,
    RouteSettings? routeSettings,
  }) {
    final child = CupertinoActionSheet(
      title: title,
      message: message,
      actions: items.map((e) => CupertinoActionSheetAction(
        onPressed: () {
          onSelected?.call(items.indexOf(e));
          Navigator.pop(context);
        },
        child: e,
      ),).toList(),
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: onCancel ?? () {
          Navigator.pop(context);
        },
        child: cancel,
      ),
    );

    showCupertinoModalPopup(
      context: context,
      builder: (context) => child,
      filter: filter,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      semanticsDismissible: semanticsDismissible,
      routeSettings: routeSettings,
    );
  }

  ///自定义sheet DatePicker
  presentCupertinoDatePicker({
    required BuildContext context,
    DateTime? initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    VoidCallback? onCancel,
    required ValueChanged<DateTime> onDateTimeConfirm,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool semanticsDismissible = false,
    RouteSettings? routeSettings,
  }) {

    var dateTime = initialDateTime ?? DateTime.now();

    final content = StatefulBuilder(
        builder: (context, setState) {

          return Container(
            height: 300 + kToolbarHeight,
            color: Colors.white,
            child: Column(
              children: [
                NPickerToolBar(
                  onCancel: onCancel ?? (){
                    Navigator.of(context).pop();
                  },
                  onConfirm: (){
                    onDateTimeConfirm(dateTime);
                  },
                ),
                Divider(height: 1.0, color: Color(0xffe4e4e4),),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: CupertinoDatePicker(
                        mode: mode,
                        initialDateTime: dateTime,
                        dateOrder: DatePickerDateOrder.ymd,
                        onDateTimeChanged: (val) {
                          dateTime = val;
                          setState(() {});
                        }
                    ),
                  ),
                ),
              ],
            ),
          );
        },
    );

    showCupertinoModalPopup(
      context: context,
      builder: (context) => content,
      filter: filter,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      semanticsDismissible: semanticsDismissible,
      routeSettings: routeSettings,
    );
  }

  ///自定义sheet弹窗方法
  presentBottomSheet({
    required BuildContext context,
    String title = "请选择",
    double maxHeight = 300,
    required Widget child,
    VoidCallback? onCancel,
    required VoidCallback? onConfirm,
  }){
    final content = Material(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildPickerTitleBar(
            context: context,
            title: title,
            onCancel: onCancel,
            onConfirm: onConfirm,
          ),
          Expanded(
            child: child,
          ),

          // Expanded(
          //   child: CupertinoScrollbar(
          //     controller: scrollController,
          //     child: ConstrainedBox(
          //       constraints: BoxConstraints(
          //         maxHeight: maxHeight,
          //         minHeight: 100,
          //       ),
          //       child: SingleChildScrollView(
          //         controller: scrollController,
          //         child: child,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {

        return content;
      },
    );
  }


  Widget buildPickerTitleBar({
    required BuildContext context,
    String title = "请选择",
    VoidCallback? onCancel,
    required VoidCallback? onConfirm,
  }){
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xffe4e4e4))),
      ),
      child: NavigationToolbar(
        leading: TextButton(
          onPressed: onCancel ?? (){
            debugPrint("取消");
            Navigator.of(context).pop();
          },
          child: Text("取消",
            style: TextStyle(
              color: context.primaryColor
            ),
          )
        ),
        middle: Text(title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        trailing: TextButton(
          onPressed: onConfirm ?? (){
            debugPrint("确定");
          },
          child: Text("确定",
            style: TextStyle(
              color: context.primaryColor
            ),
          )
        ),
      ),
    );
  }
}
