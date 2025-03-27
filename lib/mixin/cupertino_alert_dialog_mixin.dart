//
//  AlertMixin.dart
//  yl_health_app
//
//  Created by shang on 2023/10/5 18:38.
//  Copyright © 2023/10/5 shang. All rights reserved.
//

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

/// 简单提示信息
mixin CupertinoAlertDialogMixin<T extends StatefulWidget> on State<T> {
  presentAlert({
    String titleStr = "",
    String contentStr = "",
    Widget? title,
    Widget? content,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    if (titleStr.isEmpty &&
        contentStr.isEmpty &&
        title == null &&
        content == null) {
      return;
    }

    CupertinoAlertDialog(
      title: title ?? (titleStr.isEmpty ? null : Text(titleStr)),
      content: content ??
          Text(
            contentStr,
            textAlign: TextAlign.left,
          ),
      actions: [("取消", onCancel), ("确定", onConfirm)].map((e) {
        return TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 20),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size(50, 18),
          ),
          onPressed: () {
            e.$2?.call();
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(e.$1),
        );
      }).toList(),
    ).toShowCupertinoDialog(context: context);
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
    Function(BuildContext context)? onCancel,
    ui.ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool semanticsDismissible = false,
    RouteSettings? routeSettings,
  }) {
    final child = CupertinoActionSheet(
      title: title,
      message: message,
      actions: items
          .map(
            (e) => CupertinoActionSheetAction(
              onPressed: () {
                onSelect?.call(context, items.indexOf(e));
                Navigator.pop(context);
              },
              child: e,
            ),
          )
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: onCancel != null
            ? onCancel.call(context)
            : () {
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
}
