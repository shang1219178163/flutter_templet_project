//
//  NRefreshListView.dart
//  yl_health_app
//
//  Created by shang on 2024/3/8 10:59.
//  Copyright © 2024/3/8 shang. All rights reserved.
//


import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NNetContainer.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_skeleton_screen.dart';
import 'package:flutter_templet_project/util/color_util.dart';



typedef ValueIndexedWidgetBuilder<T> = Widget Function(
    BuildContext context, int index, T data);

/// 使用示例:
// class PatientSchemeNewPage extends StatefulWidget {
//
//   PatientSchemeNewPage({
//     super.key,
//     this.arguments,
//   });
//
//   final Map<String, dynamic>? arguments;
//
//   @override
//   State<PatientSchemeNewPage> createState() => _PatientSchemePageNewState();
// }
//
// class _PatientSchemePageNewState extends State<PatientSchemeNewPage> {
//
//   /// 获取上个页面传的参数
//   /// userId --- 患者id
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
//       itemBuilder: (BuildContext context, int index, e) {
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
class NRefreshListView<T> extends StatefulWidget {
  const NRefreshListView({
    super.key,
    this.child,
    required this.onRequest,
    this.onRequestError,
    this.pageSize = 20,
    this.pageNoInitial = 1,
    this.disableOnReresh = false,
    this.disableOnLoad = false,
    this.needRemovePadding = false,
    required this.itemBuilder,
    this.separatorBuilder,
    this.errorBuilder,
    this.cachedChild,
    this.refreshController,
  });

  /// 子视图(为空 默认 带刷新组件的 ListView)
  final Widget? child;

  /// 刷新页面不变的部分,
  final Widget? cachedChild;

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
  final Future<List<T>> Function(
      bool isRefresh,
      int pageNo,
      int pageSize,
      T? last,
      ) onRequest;

  /// 请求错误方法
  final void Function(Object error, StackTrace stack)? onRequestError;

  /// 错误视图构建器
  final TransitionBuilder? errorBuilder;

  /// ListView 的 itemBuilder
  final ValueIndexedWidgetBuilder<T> itemBuilder;

  /// ListView 的 separatorBuilder
  final IndexedWidgetBuilder? separatorBuilder;

  /// 刷新控制器
  final EasyRefreshController? refreshController;


  @override
  NRefreshListViewState<T> createState() => NRefreshListViewState<T>();
}

class NRefreshListViewState<T> extends State<NRefreshListView<T>> {
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
  void initState() {
    super.initState();

    widget.onRequest(true, pageNo, widget.pageSize, null).then((value) {
      items.value = value;
      isFirstLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstLoad) {
      return const NSkeletonScreen();
    }

    if (items.value.isEmpty) {
      return NPlaceholder(
        onTap: onLoad,
      );
    }

    return buildBody();
  }

  buildBody() {
    return NNetContainer<List<T>>(
      valueListenable: items,
      builder: (context, value, child) {
        return buildRefresh(
          child: widget.child ??
              buildListView(
                controller: _scrollController,
                needRemovePadding: widget.needRemovePadding,
                items: value,
              ),
        );
      },
      errorBuilder: (context, child) {
        return widget.errorBuilder?.call(context, widget.cachedChild) ??
            NPlaceholder(
              imageAndTextSpacing: 10,
              text: Text(
                "网络连接失败,请稍后重试",
                style: TextStyle(
                  color: fontColor[30],
                  fontSize: 14,
                ),
              ),
              onTap: () async {
                debugPrint("NPlaceholder");
                _easyRefreshController.callRefresh();
              },
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
    _easyRefreshController.finishRefresh(indicator);
  }

  onLoad() async {
    if (!mounted) {
      return;
    }
    if (indicator == IndicatorResult.noMore) {
      return;
    }

    pageNo += 1;
    final models = await widget.onRequest(
        false,
        pageNo,
        widget.pageSize,
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
    Widget child = Scrollbar(
      controller: controller,
      child: ListView.separated(
        controller: controller,
        itemCount: items.length,
        itemBuilder: (context, index) =>
            widget.itemBuilder(context, index, items[index]),
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
