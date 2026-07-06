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
    this.physics,
    this.title,
    this.placeholder = const NPlaceholder(),
    this.needRemovePadding = false,
    this.page = 1,
    this.pageSize = 20,
    required this.onRequest,
    required this.itemBuilder,
    this.separatorBuilder,
    this.headerBuilder,
    this.footerBuilder,
  });

  /// 控制器
  final NListRefreshController<T>? controller;

  final ScrollPhysics? physics;

  final String? title;

  final Widget? placeholder;

  /// 使用使用 MediaQuery.removePadding
  final bool needRemovePadding;

  /// 页面初始索引
  final int page;

  /// 每页数量
  final int pageSize;

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

  final scrollController = ScrollController();

  @override
  late RequestListCallback<T> onRequest = widget.onRequest;

  @override
  void dispose() {
    widget.controller?.detach(this);
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
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
        widget.page != oldWidget.page ||
        widget.pageSize != oldWidget.pageSize) {
      if (widget.controller != null && oldWidget.controller != widget.controller) {
        oldWidget.controller?.detach(this);
        widget.controller?.attach(this);
      }

      onRequest = widget.onRequest;
      final shouldReload = widget.page != oldWidget.page || widget.pageSize != oldWidget.pageSize;
      if (shouldReload) {
        page = widget.page;
        pageSize = widget.pageSize;
        onRefresh();
      }
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
      onRefresh: onRefresh,
      onLoad: indicator == IndicatorResult.noMore ? null : onLoad,
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

  @override
  void updateUI() {
    setState(() {});
  }
}
