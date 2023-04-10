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
import 'package:flutter_templet_project/basicWidget/NNet/NNetContainer.dart';


typedef ValueIndexedWidgetBuilder<T> = Widget Function(BuildContext context, int index, T? data);

class NNetContainerListView<T> extends StatefulWidget {

  NNetContainerListView({
    Key? key,
    this.title,
    required this.onRequest,
    required this.onRequestError,
    this.pageSize = 30,
    this.pageInitial = 1,
    required this.itemBuilder,
    this.separatorBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.cachedChild,
  }) : super(key: key);


  String? title;
  /// 子视图
  Widget? child;
  /// 刷新页面不变的部分,
  Widget? cachedChild;
  /// 每页数量
  int pageSize;
  /// 页面初始索引
  int pageInitial;

  /// 请求方法
  Future<List<T>> Function(bool isRefesh, int page, int pageSize, T? last,) onRequest;
  /// 请求错误方法
  Function(Object error, StackTrace stack) onRequestError;

  TransitionBuilder? emptyBuilder;

  TransitionBuilder? errorBuilder;

  ValueIndexedWidgetBuilder itemBuilder;

  IndexedWidgetBuilder? separatorBuilder;

  @override
  NNetContainerListViewState createState() => NNetContainerListViewState<T>();
}

class NNetContainerListViewState<T> extends State<NNetContainerListView<T>> {
  EasyRefreshController? _controller;

  EasyRefreshController get easyRefreshController => _controller!;


  ScrollController? _scrollController;

  var page = 0;
  // var _items = <T>[];
  final _items = ValueNotifier(<T>[]);

  @override
  void initState() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    _scrollController = ScrollController();

    page = widget.pageInitial;

    widget.onRequest(true, page, widget.pageSize, null).then((value) {
      _items.value = value;
      // setState(() {});
    }).catchError((error, stackTrace) {
      // although `throw SecondError()` has the same effect.
      widget.onRequestError;
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

        return _buildRefresh(
          child: widget.child ?? _buildListView(items: value),
        );
      },
      errorBuilder: (context,  child) {
        return widget.errorBuilder?.call(context, widget.cachedChild) ?? SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: TextButton(
            onPressed: () => _controller?.callRefresh(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(height: 8,),
                Text("网络连接失败,请稍后重试", style: TextStyle(color: Color(0xFF333333))),
              ],
            )
          )
        );
      },
    );
  }

  _buildRefresh({Widget? child}) {
    return EasyRefresh(
      controller: _controller,
      onRefresh: () async {
        _items.value = await widget.onRequest(true, page, widget.pageSize, null);
        // setState(() {});
        _controller?.finishRefresh();
      },
      onLoad: () async {
        if (!mounted) {
          return;
        }
        page += 1;
        final models = await widget.onRequest(false, page, widget.pageSize, _items.value.last);
        _items.value = [..._items.value, ...models];
        // setState(() {});

        final result = models.length >= widget.pageSize ? IndicatorResult.noMore : IndicatorResult.success;
        _controller?.finishLoad(result);
      },
      child: child,
    );
  }

  _buildListView({required List<T> items}) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) => widget.itemBuilder(context, index, items[index]),
      separatorBuilder: widget.separatorBuilder ?? (context, index) {
        return Divider(color: Colors.red,);
      },
    );
  }
}




