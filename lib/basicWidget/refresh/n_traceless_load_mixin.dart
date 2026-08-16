//
//  NTracelessLoadMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/14 10:30.
//  Copyright © 2026/5/14 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_easy_refresh_mixin.dart';

/// 无痕加载更多（接近底部触发，无 footer）
///
/// [scrollController] 必须由外部通过 setter 注入，dispose 由外部负责；
/// 本 mixin 只在 [dispose] 时移除监听，不释放 controller。
mixin NTracelessLoadMixin<W extends StatefulWidget> on State<W> {
  bool _isLoading = false;

  ScrollController? _scrollController;

  /// ScrollController 绑定到滚动视图
  ScrollController get scrollController {
    assert(_scrollController != null, 'scrollController 尚未初始化，请在 initState 之后使用');
    return _scrollController!;
  }

  /// 注入 ScrollController（外部持有并负责 dispose）
  set scrollController(ScrollController value) {
    if (identical(_scrollController, value)) {
      return;
    }
    _detachScrollListener();
    _scrollController = value;
    _attachScrollListener();
  }

  /// 触发加载更多时距滚动视图底部的距离（逻辑像素）
  double get triggerDistance => 200;

  /// 是否有下一页
  bool get hasNextPage => throw UnimplementedError("hasNextPage");

  @override
  void dispose() {
    _detachScrollListener();
    _scrollController = null;
    super.dispose();
  }

  void _attachScrollListener() {
    _scrollController?.addListener(_onScroll);
  }

  void _detachScrollListener() {
    _scrollController?.removeListener(_onScroll);
  }

  void _onScroll() {
    _tryLoadMore();
  }

  Future<void> _tryLoadMore() async {
    final controller = _scrollController;
    if (_isLoading || !hasNextPage || controller == null || !controller.hasClients) {
      return;
    }
    final position = controller.position;
    if (position.pixels < position.maxScrollExtent - triggerDistance) {
      return;
    }

    _isLoading = true;
    try {
      await onLoad();
    } catch (e) {
      // 加载失败不阻断滚动，仅记录；避免 unhandled exception 与 _isLoading 卡死
    } finally {
      _isLoading = false;
    }
  }

  Future<void> onLoad() async => throw UnimplementedError("onLoad");
}

/// 无痕加载更多（复用父类 [NListRefreshMixin] 的分页 [onLoad]，不覆盖分页实现）
///
/// [scrollController] 必须由外部通过 setter 注入，dispose 由外部负责；
/// 本 mixin 只在 [dispose] 时移除监听，不释放 controller。
mixin NTracelessEasyRefreshLoadMixin<W extends StatefulWidget, T> on NListRefreshStateMixin<W, T> {
  ScrollController? _scrollController;

  /// ScrollController 绑定到滚动视图
  ScrollController get scrollController {
    assert(_scrollController != null, 'scrollController 尚未初始化，请在 initState 之后使用');
    return _scrollController!;
  }

  /// 注入 ScrollController（外部持有并负责 dispose）
  set scrollController(ScrollController value) {
    if (identical(_scrollController, value)) {
      return;
    }
    _detachScrollListener();
    _scrollController = value;
    _attachScrollListener();
  }

  /// 触发加载请求距离（逻辑像素）
  double get triggerDistance => 200;

  /// 是否有下一页（复用父类 hasMore）
  bool get hasNextPage => indicator != IndicatorResult.noMore;

  @override
  void dispose() {
    _detachScrollListener();
    _scrollController = null;
    super.dispose();
  }

  void _attachScrollListener() {
    _scrollController?.addListener(_onScroll);
  }

  void _detachScrollListener() {
    _scrollController?.removeListener(_onScroll);
  }

  void _onScroll() {
    _tryLoadMore();
  }

  Future<void> _tryLoadMore() async {
    final controller = _scrollController;
    // 使用父类 isLoading，避免双标志不同步
    if (isLoading || !hasNextPage || controller == null || !controller.hasClients) {
      return;
    }
    final position = controller.position;
    if (position.pixels < position.maxScrollExtent - triggerDistance) {
      return;
    }

    // 走父类分页 onLoad（内部自带 try/catch/finally 与 finishLoad），不在此覆盖
    await onLoad();
  }
}
