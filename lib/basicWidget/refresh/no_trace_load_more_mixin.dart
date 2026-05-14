//
//  NoTraceLoadMoreMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/14 10:30.
//  Copyright © 2026/5/14 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_easy_refresh_mixin.dart';

/// 无痕加载更多
mixin NoTraceLoadMoreMixin on NEasyRefreshMixin {
  bool _isLoading = false;

  // 添加一个新属性
  late ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  set scrollController(ScrollController value) {
    _scrollController = value;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final _hasMore = indicator != IndicatorResult.noMore;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200 && !_isLoading && _hasMore) {
      _isLoading = true;
      onLoad().then((v) {
        _isLoading = false;
      });
    }
  }
}
