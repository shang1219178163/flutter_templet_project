//
//  NCustomScrollView.dart
//  projects
//
//  Created by shang on 2026/1/28 14:41.
//  Copyright © 2026/1/28 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_easy_refresh_mixin.dart';

/// 基于 CustomScrollView 的下拉刷新,上拉加载更多的滚动列表
/// 可以配合 NestedScrollView 添加吸顶组件使用
class NCustomScrollView<T> extends StatefulWidget {
  const NCustomScrollView({
    super.key,
    this.controller,
    this.scrollController,
    this.placeholder = const NPlaceholder(),
    this.contentDecoration = const BoxDecoration(),
    this.contentPadding = const EdgeInsets.all(0),
    this.onlyHeader = false,
    this.page = 1,
    this.pageInitial = 1,
    this.pageSize = 20,
    this.firstPageItems = const [],
    required this.onRequest,
    required this.itemBuilder,
    this.separatorBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.builder,
  });

  /// 刷新控制器
  final NListRefreshController<T>? controller;

  final ScrollController? scrollController;

  final Widget? placeholder;

  final Decoration contentDecoration;

  final EdgeInsets contentPadding;

  /// 列表为空时 header 是否可以显示
  final bool onlyHeader;

  /// 页面初始索引
  final int page;

  /// 下拉刷新时重置到的页码
  final int pageInitial;

  /// 每页数量
  final int pageSize;

  final List<T> firstPageItems;

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
  State<NCustomScrollView<T>> createState() => _NCustomScrollViewState<T>();
}

class _NCustomScrollViewState<T> extends State<NCustomScrollView<T>>
    with AutomaticKeepAliveClientMixin, NListRefreshMixin<T>, NListRefreshStateMixin<NCustomScrollView<T>, T> {
  @override
  bool get wantKeepAlive => true;

  final scrollController = ScrollController();

  // @override
  // late RequestListCallback<T> onRequest = widget.onRequest;
  //
  // @override
  // late List<T> firstPageItems = widget.firstPageItems;

  @override
  void dispose() {
    widget.controller?.detach(this);
    super.dispose();
  }

  @override
  void initState() {
    initData();
    super.initState();
    widget.controller?.attach(this);
  }

  initData() {
    onRequest = widget.onRequest;
    page = widget.page;
    pageSize = widget.pageSize;
    pageInitial = widget.pageInitial;
    firstPageItems = widget.firstPageItems;
  }

  @override
  void didUpdateWidget(covariant NCustomScrollView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.scrollController != widget.scrollController ||
        oldWidget.placeholder != widget.placeholder ||
        oldWidget.contentDecoration != widget.contentDecoration ||
        oldWidget.contentPadding != widget.contentPadding ||
        oldWidget.onlyHeader != widget.onlyHeader ||
        widget.page != oldWidget.page ||
        widget.pageInitial != oldWidget.pageInitial ||
        widget.pageSize != oldWidget.pageSize ||
        oldWidget.firstPageItems != widget.firstPageItems) {
      if (widget.controller != null && oldWidget.controller != widget.controller) {
        oldWidget.controller?.detach(this);
        widget.controller?.attach(this);
      }

      final shouldReload = widget.page != oldWidget.page ||
          widget.pageSize != oldWidget.pageSize ||
          widget.pageInitial != oldWidget.pageInitial ||
          oldWidget.firstPageItems != widget.firstPageItems;
      if (shouldReload) {
        initData();
        onRefresh();
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (items.isEmpty && !widget.onlyHeader) {
      return GestureDetector(onTap: onRefresh, child: Center(child: widget.placeholder));
    }

    return EasyRefresh.builder(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: indicator == IndicatorResult.noMore ? null : onLoad,
      childBuilder: (_, physics) {
        return CustomScrollView(
          controller: widget.scrollController,
          physics: physics,
          slivers: [
            ...(widget.headerBuilder?.call(items.length) ?? []),
            buildContent(),
            ...(widget.footerBuilder?.call(items.length) ?? []),
          ],
        );
      },
    );
  }

  Widget buildContent() {
    if (items.isEmpty) {
      return SliverToBoxAdapter(child: Center(child: widget.placeholder));
    }

    return DecoratedSliver(
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

  @override
  void updateUI() {
    setState(() {});
  }
}
