//
//  NAccountSheet.dart
//  yl_health_app_v2.20.4.1
//
//  Created by shang on 2024/3/27 16:24.
//  Copyright © 2024/3/27 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

/// 账号选择器
class NAccountSheet<E> extends StatefulWidget {
  const NAccountSheet({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.selecetdCb,
    required this.titleCb,
    this.subtitleCb,
  });

  final List<E> items;

  final E selectedItem;

  /// 改变回调
  final ValueChanged<E> onChanged;

  final String Function(E e) selecetdCb;
  final String Function(E e) titleCb;
  final String Function(E e)? subtitleCb;

  @override
  State<NAccountSheet<E>> createState() => _NAccountSheetState<E>();
}

class _NAccountSheetState<E> extends State<NAccountSheet<E>> {
  late var current = widget.selectedItem;

  List<E> get items {
    List<E> array = [...widget.items];
    if (!widget.items.contains(widget.selectedItem)) {
      array.add(widget.selectedItem);
    }
    return array;
  }

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onChooseAccount,
            child: Text(widget.selecetdCb(current)),
          ),
        ],
      ),
    );
  }

  void onChooseAccount() {
    showAlertSheet(
      message: Text(current.toString()),
      actions: items.map((e) {
        return ListTile(
          dense: true,
          onTap: () {
            Navigator.of(context).pop();

            current = e;
            widget.onChanged(e);

            setState(() {});
          },
          title: Text(widget.titleCb(e)),
          subtitle: Text(widget.subtitleCb?.call(e) ?? ""),
          trailing: Icon(
            Icons.check,
            color: current == e ? Colors.blue : Colors.transparent,
          ),
        );
      }).toList(),
    );
  }

  void showAlertSheet({
    Widget title = const Text("请选择"),
    Widget? message,
    required List<Widget> actions,
  }) {
    CupertinoActionSheet(
      title: title,
      message: message,
      actions: actions,
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('取消'),
      ),
    ).toShowCupertinoModalPopup(context: context);
  }
}
