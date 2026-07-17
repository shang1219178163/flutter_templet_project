import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_easy_refresh_mixin.dart';

/// 使用示例:
//   buildBody() {
//     return NRefreshListView<DepartmentPageDetailModel>(
//       pageSize: 2,
//       onRequest: (bool isRefresh, int page, int pageSize, last) async {
//         return await requestList(pageNo: page, pageSize: pageSize);
//       },
//       itemBuilder: (BuildContext context, int index, e) {
//         return InkWell(
//           onTap: () {
//             DLog.d("${e.toJson()}");
//           },
//           child: PatientSchemeCell(model: e, index: index),
//         );
//       },
//     );
//   }
//
//   /// 列表数据请求
//   Future<List<DepartmentPageDetailModel>> requestList({
//     required int pageNo,
//     int pageSize = 20,
//   }) async {
//     var api = SchemePageApi(
//       ownerId: arguments['userId'] ?? '',
//       pageNo: pageNo,
//       pageSize: pageSize,
//     );
//
//     Map<String, dynamic>? response = await api.startRequest();
//     if (response['code'] != 'OK') {
//       return [];
//     }
//
//     final rootModel = DepartmentPageRootModel.fromJson(response ?? {});
//     var list = rootModel.result?.content ?? [];
//     return list;
//   }
// }

/// 刷新组件,对标 NCustomScrollView
class NRefreshListView<T> extends StatefulWidget {
  const NRefreshListView({
    super.key,
    this.controller,
    this.scrollController,
    this.physics,
    this.notRefresh = false,
    this.notLoad = false,
    this.title,
    this.placeholder = const NPlaceholder(),
    this.needRemovePadding = false,
    this.page = 1,
    this.pageInitial = 1,
    this.pageSize = 20,
    this.firstPageItems = const [],
    required this.onRequest,
    required this.itemBuilder,
    this.separatorBuilder,
    this.headerBuilder,
    this.footerBuilder,
  });

  /// 控制器
  final NListRefreshController<T>? controller;

  final ScrollController? scrollController;

  final ScrollPhysics? physics;

  final String? title;

  /// 禁用刷新
  final bool notRefresh;

  /// 禁用加载
  final bool notLoad;

  final Widget? placeholder;

  /// 使用使用 MediaQuery.removePadding
  final bool needRemovePadding;

  /// 页面索引
  final int page;

  /// 下拉刷新时重置到的页码
  final int pageInitial;

  /// 每页数量
  final int pageSize;

  final List<T> firstPageItems;

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
  State<NRefreshListView<T>> createState() => NRefreshListViewState<T>();
}

class NRefreshListViewState<T> extends State<NRefreshListView<T>>
    with AutomaticKeepAliveClientMixin, NListRefreshMixin<T>, NListRefreshStateMixin<NRefreshListView<T>, T> {
  @override
  bool get wantKeepAlive => true;

  // @override
  // late RequestListCallback<T> onRequest = widget.onRequest;

  // @override
  // late List<T> firstPageItems = widget.firstPageItems;

  @override
  void dispose() {
    widget.controller?.detach(this);
    super.dispose();
  }

  @override
  void initState() {
    initData();
    super.initState();
    widget.controller?.attach(this);
  }

  initData() {
    onRequest = widget.onRequest;
    page = widget.page;
    pageSize = widget.pageSize;
    pageInitial = widget.pageInitial;
    firstPageItems = widget.firstPageItems;
  }

  @override
  void didUpdateWidget(covariant NRefreshListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title ||
        oldWidget.controller != widget.controller ||
        oldWidget.notRefresh != widget.notRefresh ||
        oldWidget.notLoad != widget.notLoad ||
        oldWidget.placeholder != widget.placeholder ||
        oldWidget.needRemovePadding != widget.needRemovePadding ||
        oldWidget.page != widget.page ||
        oldWidget.pageInitial != widget.pageInitial ||
        oldWidget.pageSize != widget.pageSize ||
        oldWidget.firstPageItems != widget.firstPageItems) {
      if (widget.controller != null && widget.controller != widget.controller) {
        oldWidget.controller?.detach(this);
        widget.controller?.attach(this);
      }

      onRequest = widget.onRequest;
      final shouldReload = oldWidget.page != widget.page ||
          oldWidget.pageSize != widget.pageSize ||
          oldWidget.pageInitial != widget.pageInitial ||
          oldWidget.firstPageItems != widget.firstPageItems;
      if (shouldReload) {
        initData();
        onRefresh();
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (items.isEmpty) {
      return GestureDetector(onTap: onRefresh, child: Center(child: widget.placeholder));
    }

    final itemCount = items.length + 2;

    Widget child = EasyRefresh(
      controller: refreshController,
      scrollController: widget.scrollController,
      onRefresh: widget.notRefresh ? null : onRefresh,
      onLoad: widget.notLoad || indicator == IndicatorResult.noMore ? null : onLoad,
      notRefreshHeader: widget.notRefresh ? const NotRefreshHeader(clamping: true) : null,
      notLoadFooter: widget.notLoad ? const NotLoadFooter(clamping: true) : null,
      child: ListView.separated(
        key: PageStorageKey(widget.title ?? hashCode),
        controller: widget.scrollController,
        physics: widget.physics,
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

  @override
  void updateUI() {
    setState(() {});
  }
}
