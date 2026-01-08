//
//  CupertinoSliverLoadMoreControl.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/7 14:50.
//  Copyright © 2026/1/7 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// /// 刷新组件 builder
// typedef RefreshStateBuilder = Widget Function(BuildContext context, RefreshIndicatorMode state);

/// 加载更多占位
typedef LoadMorePlacehorlderBuilder = Widget Function(BuildContext context, bool hasMore, bool isLoading);

/// iOS 风格 Sliver 上拉加载更多组件
///
/// 用法：
/// CustomScrollView(
///   controller: controller,
///   slivers: [
///     CupertinoSliverRefreshControl(onRefresh: onRefresh),
///     SliverList(...),
///     CupertinoSliverLoadMoreControl(
///       controller: controller,
///       onLoadMore: loadMore,
///       hasMore: hasMore,
///     ),
///   ],
/// )
class CupertinoSliverLoadMoreControl extends StatefulWidget {
  const CupertinoSliverLoadMoreControl({
    super.key,
    // required this.controller,
    required this.onLoadMore,
    required this.hasMore,
    this.triggerDistance = 80,
    this.placehorlderBuilder,
  });

  // final ScrollController controller;
  final Future<bool> Function() onLoadMore; // 返回是否还有更多
  final bool hasMore;
  final double triggerDistance;
  final LoadMorePlacehorlderBuilder? placehorlderBuilder;

  @override
  State<CupertinoSliverLoadMoreControl> createState() => _CupertinoSliverLoadMoreControlState();
}

class _CupertinoSliverLoadMoreControlState extends State<CupertinoSliverLoadMoreControl> {
  ScrollNotificationObserverState? _scrollNotificationObserver;

  bool _loading = false;

  @override
  void dispose() {
    // widget.controller.removeListener(_onScroll);
    removeScrollObserver();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant CupertinoSliverLoadMoreControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.controller != widget.controller) {
    //   oldWidget.controller.removeListener(_onScroll);
    //   widget.controller.addListener(_onScroll);
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addScrollObserver();
  }

  void addScrollObserver() {
    if (!mounted) {
      return;
    }
    _scrollNotificationObserver?.removeListener(_onScroll);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_onScroll);
  }

  void removeScrollObserver() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver?.removeListener(_onScroll);
      _scrollNotificationObserver = null;
    }
  }

  void _onScroll(ScrollNotification n) {
    if (!widget.hasMore || _loading) {
      return;
    }

    final position = n.metrics;
    if (position.pixels >= position.maxScrollExtent - widget.triggerDistance) {
      _load();
    }
  }

  Future<void> _load() async {
    if (_loading) {
      return;
    }
    _loading = true;
    setState(() {});

    await widget.onLoadMore();

    _loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.placehorlderBuilder != null) {
      return widget.placehorlderBuilder!(context, widget.hasMore, _loading);
    }

    if (!widget.hasMore) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: _loading ? const CupertinoActivityIndicator() : const SizedBox(height: 16),
        ),
      ),
    );
  }
}
