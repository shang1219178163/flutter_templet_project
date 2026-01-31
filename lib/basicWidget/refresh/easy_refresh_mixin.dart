//
//  EasyRefreshMixin.dart
//  projects
//
//  Created by shang on 2026/1/28 14:37.
//  Copyright © 2026/1/28 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

/// 带数据的自定义 itemBuilder
typedef ValueIndexedWidgetBuilder<T> = Widget Function(BuildContext context, int index, T data);

/// 请求列表回调
typedef RequestListCallback<T> = Future<List<T>> Function(
  bool isRefresh,
  int page,
  int pageSize,
  List<T> pres,
);

/// EasyRefresh刷新 mixin
mixin EasyRefreshMixin<W extends StatefulWidget, T> on State<W> {
  late final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  // late RequestListCallback<T> onRequest = throw UnimplementedError('onRequest Unimplemented');

  // late List<T> items = throw UnimplementedError('items Unimplemented');

  /// 请求方式
  late RequestListCallback<T> _onRequest;
  RequestListCallback<T> get onRequest => _onRequest;
  set onRequest(RequestListCallback<T> value) {
    _onRequest = value;
  }

  // 数据列表
  List<T> _items = [];
  List<T> get items => _items;
  set items(List<T> value) {
    _items = value;
  }

  int page = 1;
  final int pageSize = 20;
  var indicator = IndicatorResult.success;

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // DLog.d([widget.title, widget.key, hashCode]);
      if (items.isEmpty) {
        onRefresh();
      }
    });
  }

  Future<void> onRefresh() async {
    try {
      page = 1;
      final list = await onRequest(true, page, pageSize, <T>[]);
      items.replaceRange(0, items.length, list);
      page++;

      final noMore = list.length < pageSize;
      if (noMore) {
        indicator = IndicatorResult.noMore;
      }
      refreshController.finishRefresh();
      refreshController.resetFooter();
    } catch (e) {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
    setState(() {});
  }

  Future<void> onLoad() async {
    if (indicator == IndicatorResult.noMore) {
      refreshController.finishLoad();
      return;
    }

    try {
      final start = (items.length - pageSize).clamp(0, pageSize);
      final prePages = items.sublist(start);
      final list = await onRequest(false, page, pageSize, prePages);
      items.addAll(list);
      page++;

      final noMore = list.length < pageSize;
      if (noMore) {
        indicator = IndicatorResult.noMore;
      }
      refreshController.finishLoad(indicator);
    } catch (e) {
      refreshController.finishLoad(IndicatorResult.fail);
    }
    setState(() {});
  }
}
