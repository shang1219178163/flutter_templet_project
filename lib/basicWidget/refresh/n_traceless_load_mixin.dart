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

/// 无痕加载更多
mixin NTracelessLoadMixin<W extends StatefulWidget, T> on State<W> {
  /// ScrollController 绑定到滚动视图
  late ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  set scrollController(ScrollController value) {
    _scrollController = value;
  }

  /// 触发加载更多数据距离滚动视图底部距离
  double get triggerDistance => 200;

  bool _isLoading = false;

  /// 是否有下一页
  bool get hasNextPage => throw UnimplementedError("hasNextPage");

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - triggerDistance && !_isLoading && hasNextPage) {
      _isLoading = true;
      onLoad().then((v) {
        _isLoading = false;
      });
    }
  }

  Future<void> onLoad() async => throw UnimplementedError("onLoad");
}

/// 无痕加载更多
mixin NTracelessEasyRefreshLoadMixin on NEasyRefreshMixin {
  /// ScrollController 绑定到滚动视图
  late ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  set scrollController(ScrollController value) {
    _scrollController = value;
  }

  /// 触发加载请求距离
  double get triggerDistance => 200;

  bool _isLoading = false;

  /// 是否有下一页
  bool get hasNextPage => indicator != IndicatorResult.noMore;

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - triggerDistance && !_isLoading && hasNextPage) {
      _isLoading = true;
      onLoad().then((v) {
        _isLoading = false;
      });
    }
  }

  @override
  Future<void> onLoad() async => throw UnimplementedError("onLoad");
}

// /// 无痕加载更多
// mixin NTracelessEasyRefreshLoadMixin on NTracelessLoadMixin, NEasyRefreshMixin {
//   /// 触发加载请求距离
//   @override
//   double get triggerDistance => 200;
//
//   @override
//   bool isLoading = false;
//
//   /// 是否有下一页
//   @override
//   bool get hasNextPage => indicator != IndicatorResult.noMore;
// }
