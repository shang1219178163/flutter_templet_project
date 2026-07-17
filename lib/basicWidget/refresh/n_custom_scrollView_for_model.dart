//
//  NCustomScrollViewOne.dart
//  projects
//
//  Created by shang on 2026/1/28 14:41.
//  Copyright © 2026/1/28 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_skeleton_screen.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_easy_refresh_mixin.dart';

/// 基于 CustomScrollView 的下拉刷新详情展示
/// 可以配合 NestedScrollView 添加吸顶组件使用
class NCustomScrollViewForModel<T> extends StatefulWidget {
  const NCustomScrollViewForModel({
    super.key,
    this.controller,
    this.scrollController,
    this.notRefresh = false,
    this.notLoad = false,
    this.placeholder = const NPlaceholder(),
    this.skeletonScreen = const NSkeletonScreen(),
    this.contentDecoration = const BoxDecoration(),
    this.contentPadding = const EdgeInsets.all(0),
    this.onlyHeader = false,
    required this.onRequest,
    required this.builder,
    this.headerBuilder,
    this.footerBuilder,
  });

  /// 刷新控制器
  final NRefreshController<T>? controller;

  final ScrollController? scrollController;

  /// 禁用刷新
  final bool notRefresh;

  /// 禁用加载
  final bool notLoad;

  final Widget? placeholder;

  final Widget? skeletonScreen;

  final Decoration contentDecoration;

  final EdgeInsets contentPadding;

  /// 列表为空时 header 是否可以显示
  final bool onlyHeader;

  /// 请求方法
  final RequestModelCallback<T> onRequest;

  final Widget Function(BuildContext context, T? model) builder;

  /// 表头
  final List<Widget> Function(BuildContext context, T? m)? headerBuilder;

  /// 表尾
  final List<Widget> Function(BuildContext context, T? m)? footerBuilder;

  @override
  State<NCustomScrollViewForModel<T>> createState() => _NCustomScrollViewForModelState<T>();
}

class _NCustomScrollViewForModelState<T> extends State<NCustomScrollViewForModel<T>>
    with AutomaticKeepAliveClientMixin, NModelRefreshMixin<T>, NRefreshStateMixin<NCustomScrollViewForModel<T>, T> {
  @override
  bool get wantKeepAlive => true;

  // @override
  // late RequestModelCallback<T> onRequest = widget.onRequest;

  /// 首次加载
  var isFirstLoad = true;

  @override
  void dispose() {
    widget.controller?.detach(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);

    initData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (item == null) {
        await onRefresh();
        isFirstLoad = false;
      }
    });
  }

  initData() {
    onRequest = widget.onRequest;
  }

  @override
  void didUpdateWidget(covariant NCustomScrollViewForModel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.scrollController != widget.scrollController ||
        oldWidget.notRefresh != widget.notRefresh ||
        oldWidget.notLoad != widget.notLoad ||
        oldWidget.placeholder != widget.placeholder ||
        oldWidget.contentDecoration != widget.contentDecoration ||
        oldWidget.contentPadding != widget.contentPadding ||
        oldWidget.onlyHeader != widget.onlyHeader ||
        oldWidget.onRequest != widget.onRequest) {
      if (widget.controller != null && oldWidget.controller != widget.controller) {
        oldWidget.controller?.detach(this);
        widget.controller?.attach(this);
      }
      initData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isFirstLoad && widget.skeletonScreen != null) {
      return widget.skeletonScreen!;
    }

    if (item == null && !widget.onlyHeader) {
      return GestureDetector(onTap: onRefresh, child: Center(child: widget.placeholder));
    }

    return EasyRefresh.builder(
      controller: refreshController,
      scrollController: widget.scrollController,
      onRefresh: widget.notRefresh ? null : onRefresh,
      onLoad: widget.notLoad || indicator == IndicatorResult.noMore ? null : onLoad,
      notRefreshHeader: widget.notRefresh ? const NotRefreshHeader(clamping: true) : null,
      notLoadFooter: widget.notLoad ? const NotLoadFooter(clamping: true) : null,
      childBuilder: (_, physics) {
        return CustomScrollView(
          controller: widget.scrollController,
          physics: physics,
          slivers: [
            ...(widget.headerBuilder?.call(context, item) ?? []),
            buildContent(),
            ...(widget.footerBuilder?.call(context, item) ?? []),
          ],
        );
      },
    );
  }

  Widget buildContent() {
    if (item == null) {
      return SliverToBoxAdapter(child: widget.placeholder);
    }

    return DecoratedSliver(
      decoration: widget.contentDecoration,
      sliver: SliverPadding(
        padding: widget.contentPadding,
        sliver: widget.builder(context, item),
      ),
    );
  }

  @override
  void updateUI() {
    setState(() {});
  }
}
