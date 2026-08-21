//
//  CupertinoSliverLoadMoreControl.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/7 14:50.
//  Copyright © 2026/1/7 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

typedef RefreshBuilder = Widget Function(BuildContext context, bool isLoading);

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
class NRefreshControl extends StatefulWidget {
  const NRefreshControl({
    super.key,
    this.controller,
    required this.onRefresh,
    this.triggerDistance = 80,
    this.duration = const Duration(milliseconds: 300),
    this.builder,
  });

  // final ScrollController controller;
  final CupertinoRefreshController? controller;
  final Future<void> Function() onRefresh; // 返回是否还有更多
  final double triggerDistance;

  /// 消失动画时间
  final Duration duration;
  final RefreshBuilder? builder;

  @override
  State<NRefreshControl> createState() => _NRefreshControlState();
}

class _NRefreshControlState extends State<NRefreshControl> {
  ScrollNotificationObserverState? _scrollNotificationObserver;

  bool _loading = false;

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
  void didUpdateWidget(covariant NRefreshControl oldWidget) {
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
    // debugPrint(["$runtimeType", n.metrics.pixels].join("_"));
    if (_loading) {
      return;
    }

    final metrics = n.metrics;
    if (metrics.pixels <= -widget.triggerDistance) {
      _load();
    }
  }

  Future<void> _load() async {
    if (_loading) {
      return;
    }
    _loading = true;
    setState(() {});

    debugPrint(["$runtimeType", "onRefresh"].join("_"));
    await widget.onRefresh();

    setState(() {});
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context, _loading);
    }

    return AnimatedCrossFade(
      firstChild: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.blue),
        // ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: const CupertinoActivityIndicator(),
        ),
      ),
      secondChild: SizedBox(),
      crossFadeState: _loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: widget.duration,
    );
  }
}

class CupertinoRefreshController {
  _NRefreshControlState? _anchor;

  void _attach(_NRefreshControlState anchor) {
    _anchor = anchor;
  }

  void _detach(_NRefreshControlState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}
