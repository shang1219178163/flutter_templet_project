//
//  NAccountSheetNew.dart
//  yl_health_app_v2.20.4.1
//
//  Created by shang on 2024/3/27 16:24.
//  Copyright © 2024/3/27 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

/// 账号选择器(泛型尝试)
class NAccountSheetNew<E extends MapEntry<String, dynamic>> extends StatefulWidget {
  const NAccountSheetNew({
    super.key,
    this.controller,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.selecetdCb,
    required this.titleCb,
    this.subtitleCb,
  });

  /// 控制器
  final NAccountSheetNewController<E>? controller;

  final List<E> items;

  final E selectedItem;

  /// 改变回调
  final ValueChanged<E> onChanged;

  final String Function(E e) selecetdCb;
  final String Function(E e) titleCb;
  final String Function(E e)? subtitleCb;

  @override
  State<NAccountSheetNew<E>> createState() => _NAccountSheetNewState<E>();
}

class _NAccountSheetNewState<E extends MapEntry<String, dynamic>> extends State<NAccountSheetNew<E>> {
  final cacheKey = CacheKey.accountList.name;

  late List<E> items = widget.items;

  late E? current = items.isEmpty ? null : items.first;

  String get btnTitle => current == null ? "请选择账号" : widget.selecetdCb(current!);

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    var map = CacheService().getMap(cacheKey) ?? <String, dynamic>{};
    if (map.isNotEmpty) {
      updateItems(map.entries.toList() as List<E>);
    }
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
            child: Text(btnTitle),
          ),
        ],
      ),
    );
  }

  void onChooseAccount() {
    showAlertSheet(
      message: Text(btnTitle),
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

  void updateItems(List<E> value) {
    items = value;
  }

  void updateCurrent(E e) {
    current = e;
    debugPrint("current: $current");
  }
}

class NAccountSheetNewController<E extends MapEntry<String, dynamic>> {
  _NAccountSheetNewState? _anchor;

  void _attach(_NAccountSheetNewState anchor) {
    _anchor = anchor;
  }

  void _detach(_NAccountSheetNewState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  void onChooseAccount() {
    assert(_anchor != null);
    _anchor!.onChooseAccount();
  }

  void updateItems(List<MapEntry<String, dynamic>> items) {
    assert(_anchor != null);
    _anchor!.updateItems(items.reversed.toList());
  }

  /// 添加账户
  Future<void> addAccount({
    required String account,
    required String pwd,
  }) async {
    assert(_anchor != null);
    final map = await FileManager().readJson(fileName: CacheKey.accountList.name) ?? {};
    map[account] = pwd;

    final accounts = map.entries.map((e) => (account: e.key, pwd: e.value) as E).toList();
    updateItems(accounts);
    _anchor?.updateCurrent(MapEntry(account, pwd));
  }
}
