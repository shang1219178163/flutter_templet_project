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

/// 请求模型回调
typedef RequestModelCallback<T> = Future<T> Function();

/// 请求列表回调
typedef RequestListCallback<T> = Future<List<T>> Function(
  bool isRefresh,
  int page,
  int pageSize,
  List<T> pres,
);

abstract interface class NRefreshable {
  bool get isLoading;
  set isLoading(bool value);

  IndicatorResult get indicator;
  set indicator(IndicatorResult value);

  Future<void> onRefresh();

  Future<void> onLoad();

  /// 更新UI
  void updateUI();
}

/// 列表页使用 mixin
mixin NListRefreshable<T> on NRefreshable {
  // 预置列表(弹窗类, 先请求第一页数据再显示页面)
  List<T> get firstPageItems;
  set firstPageItems(List<T> value);

  List<T> get items;
  set items(List<T> value);

  int get page;
  set page(int value);

  int get pageSize;
  set pageSize(int value);

  /// 更新数据源
  void updateItems(List<T> list);
}

/// EasyRefresh刷新 mixin, 控制器可用
mixin NListRefreshMixin<T> implements NListRefreshable<T> {
  var refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 请求方式
  late RequestListCallback<T> _onRequest;
  RequestListCallback<T> get onRequest => _onRequest;
  set onRequest(RequestListCallback<T> value) {
    _onRequest = value;
  }

  /// 数据列表
  @override
  List<T> items = [];

  @override
  List<T> firstPageItems = [];

  @override
  int page = 1;

  @override
  int pageSize = 20;

  @override
  var indicator = IndicatorResult.success;

  @override
  bool isLoading = false;

  bool get hasMore => indicator != IndicatorResult.noMore;

  @override
  Future<void> onRefresh() async {
    try {
      if (isLoading) {
        refreshController.finishRefresh();
        return;
      }
      isLoading = true;

      page = 1;
      final list = firstPageItems.isNotEmpty ? firstPageItems : await onRequest(true, page, pageSize, <T>[]);
      // items.replaceRange(0, items.length, list);
      items = [...list];
      page++;

      indicator = list.length < pageSize ? IndicatorResult.noMore : IndicatorResult.success;
      refreshController.finishRefresh();
      refreshController.resetFooter();
    } catch (e) {
      refreshController.finishRefresh(IndicatorResult.fail);
    } finally {
      isLoading = false;
      updateUI();
    }
  }

  @override
  Future<void> onLoad() async {
    if (indicator == IndicatorResult.noMore) {
      refreshController.finishLoad(indicator);
      return;
    }

    try {
      if (isLoading) {
        refreshController.finishLoad(indicator);
        return;
      }
      isLoading = true;

      final start = (items.length - pageSize).clamp(0, pageSize);
      final prePages = items.sublist(start);
      final list = await onRequest(false, page, pageSize, prePages);
      // items.addAll(list);
      items = [...items, ...list];
      page++;

      indicator = list.length < pageSize ? IndicatorResult.noMore : IndicatorResult.success;
      refreshController.finishLoad(indicator);
    } catch (e) {
      refreshController.finishLoad(IndicatorResult.fail);
    } finally {
      isLoading = false;
      updateUI();
    }
  }

  @override
  void updateItems(List<T> list) {
    items = [...list];
  }

  @override
  void updateUI() => throw UnimplementedError('updateUI');
}

/// EasyRefresh刷新 mixin, StatefulWidget 列表页使用
mixin NListRefreshStateMixin<W extends StatefulWidget, T> on State<W>, NListRefreshMixin<T> {
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

  @override
  void updateItems(List<T> list) {
    items.replaceRange(0, items.length, list);
    updateUI();
  }

  @override
  void updateUI() {
    setState(() {});
  }
}

/// 列表刷新控制器,配和 NListRefreshable 使用
class NListRefreshController<T> {
  NListRefreshable<T>? _anchor;

  void attach(NListRefreshable<T> anchor) {
    _anchor = anchor;
  }

  void detach(NListRefreshable<T> anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  List<T> get items {
    assert(_anchor != null);
    return _anchor!.items;
  }

  void onRefresh() {
    assert(_anchor != null);
    _anchor!.onRefresh();
  }

  /// 页码减一
  void turnPrePage() {
    assert(_anchor != null);
    _anchor!.page--;
  }

  /// 页码加一
  void turnNextPage() {
    assert(_anchor != null);
    _anchor!.page++;
  }

  void updateItems(List<T> list) {
    assert(_anchor != null);
    _anchor!.updateItems(list);
  }

  void updateUI() {
    assert(_anchor != null);
    _anchor!.updateUI();
  }
}

/******************************* after for model *******************************/

/// 详情页使用
mixin NModelRefreshable<T> on NRefreshable {
  T? get item;
  set item(T? value);

  /// 更新数据源
  void updateItem(T v);
}

/// EasyRefresh刷新 mixin, 控制器可用
mixin NModelRefreshMixin<T> implements NModelRefreshable<T> {
  var refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 请求方式
  late RequestModelCallback<T> _onRequest;
  RequestModelCallback<T> get onRequest => _onRequest;
  set onRequest(RequestModelCallback<T> value) {
    _onRequest = value;
  }

  /// 数据列表
  @override
  T? item;

  @override
  var indicator = IndicatorResult.success;

  @override
  bool isLoading = false;

  @override
  Future<void> onRefresh() async {
    try {
      if (isLoading) {
        refreshController.finishRefresh();
        return;
      }
      isLoading = true;

      item = await onRequest();
      indicator = item == null ? IndicatorResult.fail : IndicatorResult.success;
      refreshController.finishRefresh(indicator);
      refreshController.resetFooter();
    } catch (e) {
      refreshController.finishRefresh(IndicatorResult.fail);
    } finally {
      isLoading = false;
      updateUI();
    }
  }

  @override
  Future<void> onLoad() => throw UnimplementedError('onLoad');

  @override
  void updateItem(T v) {
    item = v;
    updateUI();
  }

  @override
  void updateUI() => throw UnimplementedError('updateUI');
}

/// EasyRefresh刷新 mixin, StatefulWidget 详情页使用
mixin NRefreshStateMixin<W extends StatefulWidget, T> on State<W>, NModelRefreshMixin<T> {
  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (item == null) {
        onRefresh();
      }
    });
  }

  @override
  void updateUI() {
    setState(() {});
  }
}

/// 列表刷新控制器,配和 NModelRefreshable 使用
class NRefreshController<T> {
  NModelRefreshable<T>? _anchor;

  void attach(NModelRefreshable<T> anchor) {
    _anchor = anchor;
  }

  void detach(NModelRefreshable<T> anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  T? get item {
    assert(_anchor != null);
    return _anchor!.item;
  }

  Future<void> onRefresh() {
    assert(_anchor != null);
    return _anchor!.onRefresh();
  }

  void updateItem(T v) {
    assert(_anchor != null);
    _anchor!.updateItem(v);
  }

  void updateUI() {
    assert(_anchor != null);
    _anchor!.updateUI();
  }
}
