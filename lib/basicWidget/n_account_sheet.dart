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
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 账号选择器
class NAccountSheet extends StatefulWidget {
  const NAccountSheet({
    super.key,
    this.controller,
    this.items = const [],
    required this.onChanged,
    this.titleCb,
    this.subtitleCb,
  });

  /// 控制器
  final NAccountSheetController? controller;

  /// 预置数据列表(默认值空)
  final List<MapEntry<String, dynamic>> items;

  /// 改变回调
  final ValueChanged<MapEntry<String, dynamic>> onChanged;

  /// 子项标题显示
  final String Function(MapEntry<String, dynamic> e)? titleCb;

  /// 子项目副标题显示
  final String Function(MapEntry<String, dynamic> e)? subtitleCb;

  @override
  State<NAccountSheet> createState() => _NAccountSheetState();
}

class _NAccountSheetState extends State<NAccountSheet> {
  final cacheKey = CacheKey.accountList.name;

  late List<MapEntry<String, dynamic>> items = widget.items;

  late MapEntry<String, dynamic>? current = items.isEmpty ? null : items.first;

  String get btnTitle => current == null ? "请选择账号" : current!.key;

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
      updateItems(map.entries.toList());
    }
  }

  /// 数据初始化
  Future<void> initData() async {
    await readFromSandbox();
  }

  /// 从沙盒读取数据
  Future<void> readFromSandbox() async {
    var map = CacheService().getMap(cacheKey) ?? <String, dynamic>{};
    if (map.isNotEmpty && items.isNotEmpty) {
      return;
    }
    final mapNew = await FileManager().readJson(fileName: cacheKey);
    if (mapNew == null) {
      return;
    }

    items.addAll(mapNew.entries);
    updateItems(items);
    CacheService().setMap(cacheKey, mapNew);
  }

  /// 保存数据到沙盒
  Future<void> saveToSandbox({required Map<String, dynamic> map}) async {
    final file = await FileManager().saveJson(fileName: cacheKey, map: map);
    DLog.d("file: $file");
  }

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      return const SizedBox();
    }

    if (items.isEmpty) {
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
        final title = widget.titleCb?.call(e) ?? e.key;

        return ListTile(
          dense: true,
          onTap: () {
            Navigator.of(context).pop();

            current = e;
            widget.onChanged(e);

            setState(() {});
          },
          title: Text(title),
          subtitle: Text(widget.subtitleCb?.call(e) ?? ""),
          trailing: Icon(
            Icons.check,
            color: current?.key == e.key ? Colors.blue : Colors.transparent,
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

  void updateItems(List<MapEntry<String, dynamic>> value) {
    value.sort((a, b) => a.key.compareTo(b.key));
    items = value;
  }

  void updateCurrent(MapEntry<String, dynamic>? e) {
    current = e;
    debugPrint("current: $current");
  }
}

class NAccountSheetController {
  _NAccountSheetState? _anchor;

  String get cacheKey => CacheKey.accountList.name;

  void _attach(_NAccountSheetState anchor) {
    _anchor = anchor;
  }

  void _detach(_NAccountSheetState anchor) {
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
    var map = CacheService().getMap(cacheKey) ?? <String, dynamic>{};
    map.putIfAbsent(account, () => pwd);

    _anchor?.items.forEach((e) {
      map.putIfAbsent(e.key, () => e.value);
    });

    CacheService().setMap(cacheKey, map);
    updateItems(map.entries.toList());
    _anchor?.updateCurrent(MapEntry(account, pwd));

    final file = await _anchor?.saveToSandbox(map: map);
    await _anchor?.readFromSandbox();
  }

  void clear() {
    CacheService().remove(cacheKey);
    updateItems([]);
    _anchor?.updateCurrent(null);
  }
}
