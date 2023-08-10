//
//  NNetContainerListView.dart
//  flutter_templet_project
//
//  Created by shang on 3/30/23 5:12 PM.
//  Copyright © 3/30/23 shang. All rights reserved.
//


// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NNetContainer.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/uti/color_util.dart';


typedef ValueIndexedWidgetBuilder<T> = Widget Function(BuildContext context, int index, T data);

class NNetContainerListView<T> extends StatefulWidget {

  NNetContainerListView({
    Key? key,
    required this.onRequest,
    required this.onRequestError,
    this.pageSize = 30,
    this.pageInitial = 1,
    this.disableOnReresh = false,
    this.disableOnLoad = false,
    this.needRemovePadding = false,
    required this.itemBuilder,
    this.separatorBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.cachedChild,
    this.refreshController,
  }) : super(key: key);

  /// 子视图(为空 默认 带刷新组件的 ListView)
  Widget? child;
  /// 刷新页面不变的部分,
  Widget? cachedChild;
  /// 每页数量
  int pageSize;
  /// 页面初始索引
  int pageInitial;
  /// 禁用下拉刷新
  bool disableOnReresh;
  /// 禁用上拉加载
  bool disableOnLoad;
  /// 使用使用 MediaQuery.removePadding
  bool needRemovePadding;

  /// 请求方法
  Future<List<T>> Function(bool isRefesh, int page, int pageSize, T? last,) onRequest;
  /// 请求错误方法
  Function(Object error, StackTrace stack) onRequestError;
  /// 空视图构建器
  TransitionBuilder? emptyBuilder;
  /// 错误视图构建器
  TransitionBuilder? errorBuilder;
  /// ListView 的 itemBuilder
  ValueIndexedWidgetBuilder<T> itemBuilder;
  /// ListView 的 separatorBuilder
  IndexedWidgetBuilder? separatorBuilder;
  /// 刷新控制器
  EasyRefreshController? refreshController;

  @override
  NNetContainerListViewState createState() => NNetContainerListViewState<T>();
}

class NNetContainerListViewState<T> extends State<NNetContainerListView<T>> {

  late final _easyRefreshController = widget.refreshController ?? EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final _scrollController = ScrollController();

  var _indicatorResult = IndicatorResult.none;

  var _page = 0;

  final _items = ValueNotifier(<T>[]);

  /// 首次加载
  var _isFirstLoad = true;


  @override
  void initState() {
    _page = widget.pageInitial;

    widget.onRequest(true, _page, widget.pageSize, null).then((value) {
      _items.value = value;
      _isFirstLoad = false;
      // setState(() {});
    }).catchError((error, stackTrace) {
      // although `throw SecondError()` has the same effect.
      widget.onRequestError.call(error, stackTrace);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildNetListen();
  }

  _buildNetListen() {
    return NNetContainer<List<T>>(
      valueListenable: _items,
      builder: (context, value, child) {

        return Stack(
          children: [
            _buildRefresh(
              controller: _easyRefreshController,
              child: widget.child ?? _buildListView(
                controller: _scrollController,
                needRemovePadding: widget.needRemovePadding,
                items: value,
              ),
            ),
            if (value.isEmpty && !_isFirstLoad) Positioned.fill(
                child: NPlaceholder(
                  imageAndTextSpacing: 10.h,
                  onTap: () async {
                    debugPrint("NPlaceholder");
                    _easyRefreshController.callRefresh();
                  },
                )
            ),
          ],
        );
      },
      errorBuilder: (context,  child) {
        return widget.errorBuilder?.call(context, widget.cachedChild) ?? NPlaceholder(
          imageAndTextSpacing: 10.h,
          text: Text("网络连接失败,请稍后重试",
            style: TextStyle(
              color: fontColor[30],
              fontSize: 14.sp,
            ),
          ),
          onTap: () async {
            debugPrint("NPlaceholder");
            _easyRefreshController.callRefresh();
          },
        );

        // return widget.errorBuilder?.call(context, widget.cachedChild) ?? SizedBox(
        //   width: double.infinity,
        //   height: double.infinity,
        //   child: TextButton(
        //     onPressed: () => _easyRefreshController.callRefresh(),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Icon(Icons.error, color: Colors.red),
        //         SizedBox(height: 8,),
        //         Text("网络连接失败,请稍后重试", style: TextStyle(color: Color(0xFF333333))),
        //       ],
        //     )
        //   )
        // );
      },
    );
  }

  Widget _buildRefresh({
    EasyRefreshController? controller,
    Widget? child,
  }) {
    return EasyRefresh(
      controller: controller,
      onRefresh: () async {
        _page = widget.pageInitial;
        _items.value = await widget.onRequest(true, _page, widget.pageSize, null);
        _indicatorResult = _items.value.length < widget.pageSize ? IndicatorResult.noMore : IndicatorResult.success;
        controller?.finishRefresh();
      },
      onLoad: widget.disableOnLoad || _indicatorResult == IndicatorResult.noMore
          ? null
          : () async {
        if (!mounted) {
          return;
        }
        if (_indicatorResult == IndicatorResult.noMore) {
          return;
        }
        _page += 1;
        final models = await widget.onRequest(false, _page, widget.pageSize, _items.value.last);
        _items.value = [..._items.value, ...models];

        _indicatorResult = models.length < widget.pageSize ? IndicatorResult.noMore : IndicatorResult.success;
        controller?.finishLoad(_indicatorResult);
      },
      child: child,
    );
  }

  Widget _buildListView({
    ScrollController? controller,
    bool needRemovePadding = false,
    required List<T> items,
  }) {
    Widget child = Scrollbar(
      controller: controller,
      child: ListView.separated(
        controller: controller,
        itemCount: items.length,
        itemBuilder: (context, index) => widget.itemBuilder(context, index, items[index]),
        separatorBuilder: widget.separatorBuilder ?? (context, index) {
          return const Divider(color: Color(0xffe4e4e4), height: 1,);
        },
      ),
    );
    if (needRemovePadding) {
      child = MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: child,
      );
    }
    return child;
  }
}




