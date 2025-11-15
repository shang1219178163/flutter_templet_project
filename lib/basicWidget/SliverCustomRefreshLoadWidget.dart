import 'package:flutter/material.dart';

/// 刷新状态
enum RefreshState { idle, dragging, armed, refreshing, done }

/// 自定义 Sliver 下拉刷新 + 上拉加载组件
class SliverCustomRefreshLoadWidget extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Future<void> Function()? onLoadMore;
  final Widget Function(BuildContext, double, RefreshState)? headerBuilder;
  final Widget Function(BuildContext, double, bool)? footerBuilder;
  final List<Widget> slivers;
  final double triggerOffset;
  final double loadMoreOffset;

  const SliverCustomRefreshLoadWidget({
    super.key,
    required this.onRefresh,
    required this.slivers,
    this.onLoadMore,
    this.headerBuilder,
    this.footerBuilder,
    this.triggerOffset = 100,
    this.loadMoreOffset = 60,
  });

  @override
  State<SliverCustomRefreshLoadWidget> createState() => _SliverCustomRefreshLoadWidgetState();
}

class _SliverCustomRefreshLoadWidgetState extends State<SliverCustomRefreshLoadWidget> {
  double _offset = 0;
  RefreshState _refreshState = RefreshState.idle;
  bool _isLoadingMore = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleNotification,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ✅ 顶部刷新头
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: _offset > 0 ? _offset : 0,
              alignment: Alignment.center,
              child: widget.headerBuilder?.call(context, _offset, _refreshState) ?? _defaultHeader(context),
            ),
          ),

          // ✅ 主要内容
          ...widget.slivers,

          // ✅ 底部加载更多
          if (widget.onLoadMore != null)
            SliverToBoxAdapter(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: _isLoadingMore ? widget.loadMoreOffset : 0,
                alignment: Alignment.center,
                child: widget.footerBuilder?.call(context, _offset, _isLoadingMore) ?? _defaultFooter(context),
              ),
            ),
        ],
      ),
    );
  }

  bool _handleNotification(ScrollNotification notification) {
    DLog.d(notification.runtimeType);
    if (notification is OverscrollNotification) {
      // 下拉刷新区域
      if (notification.overscroll < 0 && !_isLoadingMore) {
        setState(() {
          _offset += -notification.overscroll / 2; // 阻尼
          if (_offset > widget.triggerOffset) {
            _refreshState = RefreshState.armed;
          } else {
            _refreshState = RefreshState.dragging;
          }
        });
      }

      // 上拉加载更多区域
      else if (notification.overscroll > 0 && !_isLoadingMore && widget.onLoadMore != null) {
        final metrics = notification.metrics;
        if (metrics.pixels >= metrics.maxScrollExtent - 10) {
          _startLoadMore();
        }
      }
    } else if (notification is ScrollEndNotification) {
      // 释放时触发刷新
      if (_refreshState == RefreshState.armed) {
        _startRefresh();
      } else if (_offset > 0) {
        _reset();
      }
    }
    return false;
  }

  Future<void> _startRefresh() async {
    setState(() => _refreshState = RefreshState.refreshing);
    await widget.onRefresh();
    setState(() => _refreshState = RefreshState.done);
    await Future.delayed(const Duration(milliseconds: 400));
    _reset();
  }

  Future<void> _startLoadMore() async {
    setState(() => _isLoadingMore = true);
    await widget.onLoadMore?.call();
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _isLoadingMore = false);
  }

  void _reset() {
    setState(() {
      _offset = 0;
      _refreshState = RefreshState.idle;
    });
  }

  Widget _defaultHeader(BuildContext context) {
    switch (_refreshState) {
      case RefreshState.dragging:
        return const Icon(Icons.arrow_downward, color: Colors.grey);
      case RefreshState.armed:
        return const Icon(Icons.arrow_upward, color: Colors.blue);
      case RefreshState.refreshing:
        return const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case RefreshState.done:
        return const Icon(Icons.check_circle, color: Colors.green);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _defaultFooter(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
