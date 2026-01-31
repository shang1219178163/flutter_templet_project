//
//  NCustomScrollView.dart
//  projects
//
//  Created by shang on 2026/1/28 14:41.
//  Copyright © 2026/1/28 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_decorated.dart';
import 'package:flutter_templet_project/basicWidget/refresh/easy_refresh_mixin.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_refresh_view.dart';

/// 基于 CustomScrollView 的下拉刷新,上拉加载更多的滚动列表
class NCustomScrollView<T> extends StatefulWidget {
  const NCustomScrollView({
    super.key,
    this.title,
    this.placeholder = const NPlaceholder(),
    this.contentDecoration = const BoxDecoration(),
    this.contentPadding = const EdgeInsets.all(0),
    required this.onRequest,
    required this.headerSliverBuilder,
    this.nestedScrollViewBuilder,
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

  /// 列表表头
  final NestedScrollViewHeaderSliversBuilder? headerSliverBuilder;

  final NestedScrollView Function(NestedScrollView scrollView)? nestedScrollViewBuilder;

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
    with AutomaticKeepAliveClientMixin, EasyRefreshMixin<NCustomScrollView<T>, T> {
  @override
  bool get wantKeepAlive => true;

  final scrollController = ScrollController();

  @override
  late RequestListCallback<T> onRequest = widget.onRequest;

  @override
  List<T> items = <T>[];

  @override
  void didUpdateWidget(covariant NCustomScrollView<T> oldWidget) {
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
      return GestureDetector(onTap: onRefresh, child: Center(child: widget.placeholder));
    }

    final child = EasyRefresh.builder(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: onLoad,
      childBuilder: (_, physics) {
        return CustomScrollView(
          physics: physics,
          slivers: [
            ...(widget.headerBuilder?.call(items.length) ?? []),
            buildContent(),
            ...(widget.footerBuilder?.call(items.length) ?? []),
          ],
        );
      },
    );
    if (widget.headerSliverBuilder == null) {
      return child;
    }

    final scrollView = NestedScrollView(
      headerSliverBuilder: widget.headerSliverBuilder!,
      body: child,
    );
    return widget.nestedScrollViewBuilder?.call(scrollView) ?? scrollView;
  }

  Widget buildContent() {
    if (items.isEmpty) {
      return SliverToBoxAdapter(child: Center(child: widget.placeholder));
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
}

extension NestedScrollViewExt on NestedScrollView {
  NestedScrollView copyWith({
    ScrollController? controller,
    Axis? scrollDirection,
    bool? reverse,
    ScrollPhysics? physics,
    NestedScrollViewHeaderSliversBuilder? headerSliverBuilder,
    Widget? body,
    DragStartBehavior? dragStartBehavior,
    bool? floatHeaderSlivers,
    Clip? clipBehavior,
    HitTestBehavior? hitTestBehavior,
    String? restorationId,
    ScrollBehavior? scrollBehavior,
  }) {
    return NestedScrollView(
      controller: controller ?? this.controller,
      scrollDirection: scrollDirection ?? this.scrollDirection,
      reverse: reverse ?? this.reverse,
      physics: physics ?? this.physics,
      headerSliverBuilder: headerSliverBuilder ?? this.headerSliverBuilder,
      body: body ?? this.body,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      floatHeaderSlivers: floatHeaderSlivers ?? this.floatHeaderSlivers,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      hitTestBehavior: hitTestBehavior ?? this.hitTestBehavior,
      restorationId: restorationId ?? this.restorationId,
      scrollBehavior: scrollBehavior ?? this.scrollBehavior,
    );
  }
}
