import 'package:flutter/cupertino.dart';

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
  final ScrollController controller;
  final Future<bool> Function() onLoadMore; // 返回是否还有更多
  final bool hasMore;
  final double triggerDistance;

  const CupertinoSliverLoadMoreControl({
    super.key,
    required this.controller,
    required this.onLoadMore,
    required this.hasMore,
    this.triggerDistance = 80,
  });

  @override
  State<CupertinoSliverLoadMoreControl> createState() => _CupertinoSliverLoadMoreControlState();
}

class _CupertinoSliverLoadMoreControlState extends State<CupertinoSliverLoadMoreControl> {
  bool _loading = false;

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant CupertinoSliverLoadMoreControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!widget.hasMore || _loading) {
      return;
    }

    final position = widget.controller.position;
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
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasMore) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: _loading ? const CupertinoActivityIndicator() : const SizedBox(height: 16),
        ),
      ),
    );
  }
}
