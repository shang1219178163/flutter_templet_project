import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';

import 'package:flutter_templet_project/basicWidget/n_refresh_view.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 列表
class NRefreshListView<T> extends StatefulWidget {
  const NRefreshListView({
    super.key,
    this.title,
    required this.onRequest,
    required this.itemBuilder,
  });

  final String? title;

  /// 请求方法
  final RequestListCallback<T> onRequest;

  /// ListView 的 itemBuilder
  final ValueIndexedWidgetBuilder<T> itemBuilder;

  @override
  State<NRefreshListView<T>> createState() => _NRefreshListViewState<T>();
}

class _NRefreshListViewState<T> extends State<NRefreshListView<T>> with AutomaticKeepAliveClientMixin {
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (items.isEmpty) {
      return GestureDetector(
        onTap: onRefresh,
        child: const NPlaceholder(),
      );
    }
    return EasyRefresh(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: onMore,
      child: ListView.builder(
        key: PageStorageKey(widget.title ?? hashCode),
        itemCount: items.length,
        itemBuilder: (context, i) {
          return widget.itemBuilder(context, i, items[i]);
        },
      ),
    );
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
      final list = await widget.onRequest(true, page, pageSize, prePages);
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

  @override
  bool get wantKeepAlive => true;
}
