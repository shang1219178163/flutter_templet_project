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

/// 使用示例:
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
/// 刷新列表组件化
class NRefreshView<T> extends StatefulWidget {
  const NRefreshView({
    super.key,
    this.controller,
    required this.onRequest,
    required this.placeholder,
    required this.child,
    this.page = 1,
    this.pageSize = 20,
    this.disableOnReresh = false,
    this.disableOnLoad = false,
  });

  /// 控制器
  final NRefreshController<T>? controller;

  /// 子视图(为空 默认 带刷新组件的 ListView)
  final Widget child;

  final Widget placeholder;

  /// 页面初始索引
  final int page;

  /// 每页数量
  final int pageSize;

  /// 禁用下拉刷新
  final bool disableOnReresh;

  /// 禁用上拉加载
  final bool disableOnLoad;

  /// 请求方法
  final RequestListCallback<T> onRequest;

  @override
  NRefreshViewState<T> createState() => NRefreshViewState<T>();
}

class NRefreshViewState<T> extends State<NRefreshView<T>>
    with AutomaticKeepAliveClientMixin, NRefreshMixin<T>, NEasyRefreshMixin<NRefreshView<T>, T> {
  @override
  bool get wantKeepAlive => true;

  final scrollController = ScrollController();

  @override
  late RequestListCallback<T> onRequest = widget.onRequest;

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
    page = widget.page;
    pageSize = widget.pageSize;
    initData();
  }

  @override
  void didUpdateWidget(covariant NRefreshView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        widget.placeholder != oldWidget.placeholder ||
        widget.page != oldWidget.page ||
        widget.pageSize != oldWidget.pageSize ||
        widget.onRequest != oldWidget.onRequest) {
      if (widget.controller != null && oldWidget.controller != widget.controller) {
        oldWidget.controller?.detach(this);
        widget.controller?.attach(this);
      }
      page = widget.page;
      pageSize = widget.pageSize;
    }
  }

  Future<void> initData() async {
    await onRefresh();
    isFirstLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isFirstLoad) {
      return const NSkeletonScreen();
    }

    if (items.isEmpty) {
      return GestureDetector(onTap: onRefresh, child: Center(child: widget.placeholder));
    }

    return EasyRefresh(
      controller: refreshController,
      triggerAxis: Axis.vertical,
      onRefresh: widget.disableOnReresh ? null : onRefresh,
      onLoad: widget.disableOnLoad || indicator == IndicatorResult.noMore ? null : onLoad,
      child: widget.child,
    );
  }
}
