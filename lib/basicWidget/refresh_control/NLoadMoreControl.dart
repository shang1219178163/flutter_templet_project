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
typedef LoadMoreBuilder = Widget Function(BuildContext context, bool hasMore, bool isLoading);

/// iOS 风格 Sliver 上拉加载更多组件
///
/// 用法：
/// CustomScrollView(
///   controller: controller,
///   slivers: [
///     NRefreshControl(onRefresh: onRefresh),
///     SliverList(...),
///     NLoadMoreControl(
///       controller: controller,
///       onLoadMore: loadMore,
///       hasMore: hasMore,
///     ),
///   ],
/// )
class NLoadMoreControl extends StatefulWidget {
  const NLoadMoreControl({
    super.key,
    required this.controller,
    required this.onLoad,
    this.triggerDistance = 80,
    this.builder,
  });

  // final ScrollController controller;
  final NLoadMoreController? controller;
  final Future<void> Function() onLoad;
  final double triggerDistance;
  final LoadMoreBuilder? builder;

  @override
  State<NLoadMoreControl> createState() => _NLoadMoreControlState();
}

class _NLoadMoreControlState extends State<NLoadMoreControl> {
  ScrollNotificationObserverState? _scrollNotificationObserver;

  bool _loading = false;
  bool _hasMore = true;

  @override
  void dispose() {
    // widget.controller.removeListener(_onScroll);
    widget.controller?._detach(this);
    removeScrollObserver();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // widget.controller.addListener(_onScroll);
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant NLoadMoreControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // oldWidget.controller.removeListener(_onScroll);
      // widget.controller.addListener(_onScroll);
      widget.controller?._attach(this);
    }
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
    if (!_hasMore || _loading) {
      return;
    }

    final metrics = n.metrics;
    if (metrics.pixels >= metrics.maxScrollExtent - widget.triggerDistance) {
      _load();
    }
  }

  Future<void> _load() async {
    if (_loading) {
      return;
    }
    _loading = true;
    setState(() {});

    await widget.onLoad();

    setState(() {});
    _loading = false;
  }

  /// 重置状态
  /// hasMore 是否有更多页
  void resetState({required bool noMore}) {
    _hasMore = !noMore;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context, _hasMore, _loading);
    }

    if (!_hasMore) {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: _loading ? const CupertinoActivityIndicator() : const SizedBox(height: 16),
      ),
    );
  }
}

class NLoadMoreController {
  _NLoadMoreControlState? _anchor;

  void _attach(_NLoadMoreControlState anchor) {
    _anchor = anchor;
  }

  void _detach(_NLoadMoreControlState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  void resetState({required bool noMore}) {
    _anchor!.resetState(noMore: noMore);
  }
}
