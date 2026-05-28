//
//  NOverlayZIndexManager.dart
//  projects
//
//  Created by shang on 2026/5/6 11:27.
//  Copyright © 2026/5/6 shang. All rights reserved.
//

import 'package:flutter/widgets.dart';

class NOverlayZIndexItem {
  NOverlayZIndexItem({
    required this.entry,
    required this.zIndex,
    this.tag,
  });

  /// 视图
  final OverlayEntry entry;

  /// z 轴层次
  final int zIndex;

  /// 唯一 key
  final String? tag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['entry'] = entry.hashCode;
    map['zIndex'] = zIndex;
    map['tag'] = tag;
    return map;
  }
}

/// 全局 Overlay 层次 ZIndex 管理
class NOverlayZIndexManager {
  NOverlayZIndexManager._();

  static final instance = NOverlayZIndexManager._();

  // final context = AppNavigator.navigatorKey.currentContext!;
  // late final overlayState = Overlay.of(context, rootOverlay: true);

  final List<NOverlayZIndexItem> _items = [];
  List<NOverlayZIndexItem> get items => _items;

  bool checkExist({required String tag}) {
    final isNotEmpty = items.where((e) => e.tag == tag).isNotEmpty;
    return isNotEmpty;
  }

  void clear() {
    for (var i = 0; i < items.length; i++) {
      items[i].entry.remove();
    }
    _items.clear();
  }

  /// 插入（核心）
  NOverlayZIndexItem show({
    required BuildContext context,
    required OverlayEntry entry,
    required int zIndex,
    String? tag,
  }) {
    // context ??= AppNavigator.navigatorKey.currentContext!;

    /// ✅ 1. 已存在 → 更新
    if (tag != null) {
      final existIndex = _items.indexWhere((e) => e.tag == tag);
      if (existIndex != -1) {
        final existItem = _items[existIndex];
        existItem.entry.markNeedsBuild();

        // 👉 zIndex 变化才移动
        // if (existItem.zIndex != zIndex) {
        //   updateZIndex(tag: tag, newZIndex: zIndex);
        // }
        return existItem;
      }
    }

    /// 1️⃣ 先找插入位置（有序）
    var insertIndex = _items.indexWhere((e) => e.zIndex > zIndex);
    if (insertIndex == -1) {
      insertIndex = _items.length;
    }

    /// 2️⃣ 插入到本地列表
    final item = NOverlayZIndexItem(
      entry: entry,
      zIndex: zIndex,
      tag: tag,
    );

    _items.insert(insertIndex, item);
    return _insertOverlay(context: context, item: item, index: insertIndex);
  }

  NOverlayZIndexItem _insertOverlay({
    required BuildContext context,
    required NOverlayZIndexItem item,
    required int index,
  }) {
    final overlayState = Overlay.of(context, rootOverlay: true);

    NOverlayZIndexItem? below;
    NOverlayZIndexItem? above;

    /// 找“下方”元素（zIndex 更小）
    if (index > 0) {
      below = _items[index - 1];
    }

    /// 找“上方”元素（zIndex 更大）
    if (index < _items.length - 1) {
      above = _items[index + 1];
    }

    if (above != null) {
      overlayState.insert(item.entry, below: above.entry);
      return item;
    }

    /// 优先使用 below（更稳定）
    if (below != null) {
      overlayState.insert(item.entry, above: below.entry);
      return item;
    }

    /// 第一个元素
    overlayState.insert(item.entry);
    return item;
  }

  /// 删除
  void removeWhere(bool Function(NOverlayZIndexItem e) test, [int start = 0]) {
    final index = _items.indexWhere(test, start);
    if (index == -1) {
      return;
    }

    final item = _items.removeAt(index);
    item.entry.remove();
  }

  /// 根据 tag 删除
  void removeByTag(String tag) {
    final targets = _items.where((e) => e.tag == tag).toList();
    for (final item in targets) {
      item.entry.remove();
      _items.remove(item);
    }
  }

  /// 更新 UI（不动层级）
  void markNeedsBuild(String tag) {
    final item = _items.where((e) => e.tag == tag).firstOrNull;
    item?.entry.markNeedsBuild();
  }

  /// 修改 zIndex（关键：移动位置）
  void updateZIndex({required BuildContext context, required String tag, required int newZIndex}) {
    final overlayState = Overlay.of(context, rootOverlay: true);

    final index = _items.indexWhere((e) => e.tag == tag);
    if (index == -1) {
      return;
    }

    /// 重新计算位置
    var insertIndex = _items.indexWhere((e) => e.zIndex > newZIndex);
    if (insertIndex == -1) {
      insertIndex = _items.length;
    }

    final item = _items.removeAt(index);
    final itemNew = NOverlayZIndexItem(entry: item.entry, zIndex: newZIndex, tag: tag);
    _items.insert(insertIndex, itemNew);

    /// ⚠️ 关键：用 rearrange，而不是 insert
    overlayState.rearrange(_items.map((e) => e.entry));
  }
}
