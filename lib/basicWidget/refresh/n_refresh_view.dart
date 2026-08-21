//
//  NRefreshView.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/8 10:59.
//  Copyright © 2024/3/8 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_skeleton_screen.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_easy_refresh_mixin.dart';

/// 刷新组件,对标 NCustomScrollViewForModel
class NRefreshView<T> extends StatefulWidget {
  const NRefreshView({
    super.key,
    this.controller,
    this.scrollController,
    this.notRefresh = false,
    this.notLoad = false,
    required this.onRequest,
    required this.placeholder,
    this.skeletonScreen = const NSkeletonScreen(),
    required this.child,
  });

  /// 控制器
  final NRefreshController<T>? controller;

  final ScrollController? scrollController;

  /// 禁用刷新
  final bool notRefresh;

  /// 禁用加载
  final bool notLoad;

  /// 子视图(为空 默认 带刷新组件的 ListView)
  final Widget child;

  final Widget placeholder;

  final Widget? skeletonScreen;

  /// 请求方法
  final RequestModelCallback<T> onRequest;

  @override
  NRefreshViewState<T> createState() => NRefreshViewState<T>();
}

class NRefreshViewState<T> extends State<NRefreshView<T>>
    with AutomaticKeepAliveClientMixin, NModelRefreshMixin<T>, NRefreshStateMixin<NRefreshView<T>, T> {
  @override
  bool get wantKeepAlive => true;

  final scrollController = ScrollController();

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
    onRequest = widget.onRequest;
    initData();
  }

  @override
  void didUpdateWidget(covariant NRefreshView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
    onRequest = widget.onRequest;
  }

  Future<void> initData() async {
    await onRefresh();
    if (mounted) {
      isFirstLoad = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isFirstLoad && widget.skeletonScreen != null) {
      return widget.skeletonScreen!;
    }

    if (item == null) {
      return GestureDetector(onTap: onRefresh, child: Center(child: widget.placeholder));
    }

    return EasyRefresh(
      controller: refreshController,
      scrollController: widget.scrollController,
      triggerAxis: Axis.vertical,
      onRefresh: widget.notRefresh ? null : onRefresh,
      onLoad: widget.notLoad || indicator == IndicatorResult.noMore ? null : onLoad,
      notRefreshHeader: widget.notRefresh ? const NotRefreshHeader(clamping: true) : null,
      child: widget.child,
    );
  }

  @override
  void updateUI() {
    setState(() {});
  }
}
