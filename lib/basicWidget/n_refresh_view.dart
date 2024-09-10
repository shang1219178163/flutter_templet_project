//
//  NRefreshView.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/8 10:59.
//  Copyright © 2024/3/8 shang. All rights reserved.
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_skeleton_screen.dart';

typedef ValueIndexedWidgetBuilder<T> = Widget Function(
    BuildContext context, int index, T data);

/// 请求列表回调
typedef RequestListCallback<T> = Future<List<T>> Function(
  bool isRefresh,
  int pageNo,
  int pageSize,
  T? last,
);

/// 使用示例:
// class SchemeListPage extends StatefulWidget {
//
//   const SchemeListPage({
//     super.key,
//     this.arguments,
//   });
//
//   final Map<String, dynamic>? arguments;
//
//   @override
//   State<SchemeListPage> createState() => _SchemeListPageState();
// }
//
// class _SchemeListPageState extends State<SchemeListPage> {
//
//   /// 获取上个页面传的参数
//   /// userId --- 用户id
//   late Map<String, dynamic> arguments = widget.arguments ?? Get.arguments;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("$widget"),
//         actions: ['done',].map((e) => TextButton(
//           child: Text(e,
//             style: TextStyle(color: Colors.white),
//           ),
//           onPressed: () => debugPrint(e),)
//         ).toList(),
//       ),
//       body: buildBody(),
//     );
//   }
//
//   buildBody() {
//     return NRefreshListView<DepartmentPageDetailModel>(
//       pageSize: 2,
//       onRequest: (bool isRefresh, int page, int pageSize, last) async {
//
//         return await requestList(pageNo: page, pageSize: pageSize);
//       },
//       itemBuilder: (BuildContext context, int index, e, onRefresh) {
//
//         return InkWell(
//           onTap: () {
//             YLog.d("${e.toJson()}");
//           },
//           child: PatientSchemeCell(
//             model: e,
//             index: index,
//           ),
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

/// 刷新列表
/// 刷新列表组件化
class NRefreshView<T> extends StatefulWidget {
  const NRefreshView({
    super.key,
    this.listViewKey,
    this.controller,
    this.child,
    this.placeholder,
    required this.onRequest,
    this.pageSize = 20,
    this.pageNoInitial = 1,
    this.disableOnReresh = false,
    this.disableOnLoad = false,
    this.needRemovePadding = false,
    required this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.separatorBuilder,
    this.cachedChild,
    this.refreshController,
    this.tag,
  });

  /// 列表 key
  final Key? listViewKey;

  /// 控制器
  final NRefreshViewController<T>? controller;

  /// 子视图(为空 默认 带刷新组件的 ListView)
  final Widget? child;

  /// 刷新页面不变的部分,
  final Widget? cachedChild;

  final Widget? placeholder;

  /// 每页数量
  final int pageSize;

  /// 页面初始索引
  final int pageNoInitial;

  /// 禁用下拉刷新
  final bool disableOnReresh;

  /// 禁用上拉加载
  final bool disableOnLoad;

  /// 使用使用 MediaQuery.removePadding
  final bool needRemovePadding;

  /// 请求方法
  final RequestListCallback<T> onRequest;

  /// ListView 的 itemBuilder
  final ValueIndexedWidgetBuilder<T> itemBuilder;

  /// ListView 的 separatorBuilder
  final IndexedWidgetBuilder? separatorBuilder;

  /// 列表表头
  final Widget Function(int count)? headerBuilder;

  /// 列表表尾
  final Widget Function(int count)? footerBuilder;

  /// 刷新控制器
  final EasyRefreshController? refreshController;

  final String? tag;

  @override
  NRefreshViewState<T> createState() => NRefreshViewState<T>();
}

class NRefreshViewState<T> extends State<NRefreshView<T>>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _easyRefreshController = widget.refreshController ??
      EasyRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true,
      );

  final _scrollController = ScrollController();

  var indicator = IndicatorResult.none;

  late var pageNo = widget.pageNoInitial;

  late final items = ValueNotifier(<T>[]);

  /// 首次加载
  var isFirstLoad = true;

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    initData();
  }

  @override
  void didUpdateWidget(covariant NRefreshView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        widget.placeholder != oldWidget.placeholder ||
        widget.onRequest != oldWidget.onRequest ||
        widget.itemBuilder != oldWidget.itemBuilder ||
        widget.separatorBuilder != oldWidget.separatorBuilder ||
        widget.cachedChild != oldWidget.cachedChild ||
        widget.tag != widget.tag) {
      onRefresh();
    }
  }

  Future<void> initData() async {
    await onRefresh();
    isFirstLoad = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isFirstLoad) {
      return const NSkeletonScreen();
    }

    return buildBody();
  }

  Widget buildBody() {
    return ValueListenableBuilder<List<T>>(
      valueListenable: items,
      builder: (context, list, child) {
        if (list.isEmpty) {
          return widget.placeholder ??
              NPlaceholder(
                onTap: onRefresh,
              );
        }

        return buildRefresh(
          child: widget.child ??
              buildListView(
                controller: _scrollController,
                needRemovePadding: widget.needRemovePadding,
                items: list,
              ),
        );
      },
    );
  }

  Widget buildRefresh({
    Widget? child,
  }) {
    return EasyRefresh(
      controller: _easyRefreshController,
      triggerAxis: Axis.vertical,
      onRefresh: widget.disableOnReresh ? null : () => onRefresh(),
      onLoad: widget.disableOnLoad || indicator == IndicatorResult.noMore
          ? null
          : () => onLoad(),
      child: child,
    );
  }

  onRefresh() async {
    pageNo = widget.pageNoInitial;
    items.value = await widget.onRequest(true, pageNo, widget.pageSize, null);
    indicator = items.value.length < widget.pageSize
        ? IndicatorResult.noMore
        : IndicatorResult.success;
    _easyRefreshController.finishRefresh(IndicatorResult.success);
  }

  onLoad() async {
    if (!mounted) {
      return;
    }
    if (indicator == IndicatorResult.noMore) {
      return;
    }

    pageNo += 1;

    final models = await widget.onRequest(false, pageNo, widget.pageSize,
        items.value.isNotEmpty ? items.value.last : null);
    items.value = [...items.value, ...models];

    indicator = models.length < widget.pageSize
        ? IndicatorResult.noMore
        : IndicatorResult.success;
    _easyRefreshController.finishLoad(indicator);
  }

  Widget buildListView({
    ScrollController? controller,
    bool needRemovePadding = false,
    required List<T> items,
  }) {
    final itemCount = items.length + 2;

    Widget child = Scrollbar(
      controller: controller,
      child: ListView.separated(
        key: widget.listViewKey,
        controller: controller,
        itemCount: itemCount,
        // itemBuilder: (context, index) => widget.itemBuilder(
        //   context,
        //   index,
        //   items[index],
        // ),
        itemBuilder: (context, index) {
          if (index == 0) {
            return widget.headerBuilder?.call(items.length) ?? const SizedBox();
          }

          if (index == itemCount - 1) {
            return widget.footerBuilder?.call(items.length) ?? const SizedBox();
          }

          final i = index - 1;
          return widget.itemBuilder(
            context,
            i,
            items[i],
          );
        },
        separatorBuilder: widget.separatorBuilder ??
            (context, index) {
              return const Divider(
                color: Color(0xffe4e4e4),
                height: 1,
              );
            },
      ),
    );
    if (needRemovePadding) {
      child = MediaQuery.removePadding(
        removeTop: true,
        removeBottom: true,
        context: context,
        child: child,
      );
    }
    return child;
  }
}

/// NRefreshListView 组件控制器,将 NRefreshListViewState 的私有属性或者方法暴漏出去
class NRefreshViewController<E> {
  NRefreshViewState<E>? _anchor;

  void _attach(NRefreshViewState<E> anchor) {
    _anchor = anchor;
  }

  void _detach(NRefreshViewState<E> anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  List<E> get items {
    assert(_anchor != null);
    return _anchor!.items.value;
  }

  void onRefresh() {
    assert(_anchor != null);
    _anchor!.onRefresh();
  }

  /// 页码减一
  void turnPrePage() {
    assert(_anchor != null);
    _anchor!.pageNo--;
  }

  /// 页码加一
  void turnNextPage() {
    assert(_anchor != null);
    _anchor!.pageNo++;
  }
}
