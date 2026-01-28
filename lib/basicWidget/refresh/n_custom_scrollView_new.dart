//
//  NCustomScrollViewNew.dart
//  projects
//
//  Created by shang on 2026/1/28 14:41.
//  Copyright © 2026/1/28 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_decorated.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_refresh_view.dart';

/// 基于 CustomScrollView 的下拉刷新,上拉加载更多的滚动列表
class NCustomScrollViewNew<T> extends StatefulWidget {
  const NCustomScrollViewNew({
    super.key,
    this.title,
    this.placeholder = const NPlaceholder(),
    this.contentDecoration = const BoxDecoration(),
    this.contentPadding = const EdgeInsets.all(0),
    required this.onRequest,
    required this.itemBuilder,
    this.separatorBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.builder,
  });

  final String? title;

  final Widget? placeholder;

  final Decoration contentDecoration;

  final EdgeInsets contentPadding;

  /// 请求方法
  final RequestListCallback<T> onRequest;

  /// ListView 的 itemBuilder
  final ValueIndexedWidgetBuilder<T> itemBuilder;

  final IndexedWidgetBuilder? separatorBuilder;

  /// 列表表头
  final List<Widget> Function(int count)? headerBuilder;

  /// 列表表尾
  final List<Widget> Function(int count)? footerBuilder;

  final Widget Function(List<T> items)? builder;

  @override
  State<NCustomScrollViewNew<T>> createState() => _NCustomScrollViewNewState<T>();
}

class _NCustomScrollViewNewState<T> extends State<NCustomScrollViewNew<T>> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final scrollController = ScrollController();

  late final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final List<T> items = [];
  int page = 1;
  final int pageSize = 20;
  IndicatorResult indicator = IndicatorResult.success;

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
  void didUpdateWidget(covariant NCustomScrollViewNew<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title != oldWidget.title ||
        widget.placeholder != oldWidget.placeholder ||
        widget.contentDecoration != oldWidget.contentDecoration ||
        widget.contentPadding != oldWidget.contentPadding ||
        widget.onRequest != oldWidget.onRequest ||
        widget.itemBuilder != oldWidget.itemBuilder ||
        widget.separatorBuilder != oldWidget.separatorBuilder) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (items.isEmpty) {
      return GestureDetector(onTap: onRefresh, child: widget.placeholder);
    }

    Widget child = EasyRefresh(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: onMore,
      child: CustomScrollView(
        slivers: [
          ...(widget.headerBuilder?.call(items.length) ?? []),
          buildContent(),
          ...(widget.footerBuilder?.call(items.length) ?? []),
        ],
      ),
    );

    return child;
  }

  Widget buildContent() {
    if (items.isEmpty) {
      return SliverToBoxAdapter(child: widget.placeholder);
    }

    return NSliverDecorated(
      decoration: widget.contentDecoration,
      sliver: SliverPadding(
        padding: widget.contentPadding,
        sliver: widget.builder?.call(items) ?? buildSliverList(),
      ),
    );
  }

  Widget buildSliverList() {
    return SliverList.separated(
      itemBuilder: (_, i) => widget.itemBuilder(context, i, items[i]),
      separatorBuilder: (_, i) => widget.separatorBuilder?.call(context, i) ?? const SizedBox(),
      itemCount: items.length,
    );
  }

  Future<void> onRefresh() async {
    try {
      page = 1;

      final list = await widget.onRequest(true, page, pageSize, <T>[]);
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

  Future<void> onMore() async {
    if (indicator == IndicatorResult.noMore) {
      refreshController.finishLoad();
      return;
    }

    try {
      final start = (items.length - pageSize).clamp(0, pageSize);
      final prePages = items.sublist(start);
      final list = await widget.onRequest(false, page, pageSize, prePages);
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
