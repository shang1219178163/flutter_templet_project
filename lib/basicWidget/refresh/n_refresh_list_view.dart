import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_refresh_view.dart';

/// 列表
class NRefreshListView<T> extends StatefulWidget {
  const NRefreshListView({
    super.key,
    this.title,
    this.placeholder = const NPlaceholder(),
    this.needRemovePadding = false,
    required this.onRequest,
    required this.itemBuilder,
    this.separatorBuilder,
    this.headerBuilder,
    this.footerBuilder,
  });

  final String? title;

  final Widget? placeholder;

  /// 使用使用 MediaQuery.removePadding
  final bool needRemovePadding;

  /// 请求方法
  final RequestListCallback<T> onRequest;

  /// ListView 的 itemBuilder
  final ValueIndexedWidgetBuilder<T> itemBuilder;

  final IndexedWidgetBuilder? separatorBuilder;

  /// 列表表头
  final Widget Function(int count)? headerBuilder;

  /// 列表表尾
  final Widget Function(int count)? footerBuilder;

  @override
  State<NRefreshListView<T>> createState() => _NRefreshListViewState<T>();
}

class _NRefreshListViewState<T> extends State<NRefreshListView<T>> with AutomaticKeepAliveClientMixin {
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
  void didUpdateWidget(covariant NRefreshListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title != oldWidget.title ||
        widget.placeholder != oldWidget.placeholder ||
        widget.needRemovePadding != oldWidget.needRemovePadding ||
        widget.onRequest != oldWidget.onRequest ||
        widget.itemBuilder != oldWidget.itemBuilder ||
        widget.separatorBuilder != oldWidget.separatorBuilder) {
      onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (items.isEmpty) {
      return GestureDetector(onTap: onRefresh, child: widget.placeholder);
    }

    final itemCount = items.length + 2;

    Widget child = EasyRefresh(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: onMore,
      child: ListView.separated(
        key: PageStorageKey(widget.title ?? hashCode),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            return widget.headerBuilder?.call(items.length) ?? const SizedBox();
          }

          if (index == itemCount - 1) {
            return widget.footerBuilder?.call(items.length) ?? const SizedBox();
          }

          final i = index - 1;
          return widget.itemBuilder(context, i, items[i]);
        },
        separatorBuilder: (context, i) {
          return widget.separatorBuilder?.call(context, i) ?? const SizedBox();
        },
      ),
    );

    if (widget.needRemovePadding) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: child,
      );
    }
    return child;
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

mixin EasyRefreshMixin<W extends StatefulWidget, T extends Object> on State<W> {
  late final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final List<T> items = [];
  int page = 1;
  final int pageSize = 20;
  IndicatorResult indicator = IndicatorResult.success;

  RequestListCallback<T> onRequest = throw UnimplementedError('onRequest Unimplemented');

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

  Future<void> onRefresh() async {
    try {
      page = 1;

      final list = await onRequest(true, page, pageSize, <T>[]);
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
      final list = await onRequest(false, page, pageSize, prePages);
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
