// //
// //  EasyRefreshMixin.dart
// //  projects
// //
// //  Created by shang on 2026/1/28 14:37.
// //  Copyright © 2026/1/28 shang. All rights reserved.
// //
//
// import 'package:easy_refresh/easy_refresh.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_templet_project/basicWidget/refresh/easy_refresh_mixin.dart';
//
// mixin NRefreshable<T> {
//   // /// 请求方式
//   // late RequestListCallback<T> _onRequest;
//   // RequestListCallback<T> get onRequest => _onRequest;
//   // set onRequest(RequestListCallback<T> value) {
//   //   _onRequest = value;
//   // }
//
//   // 数据列表
//   List<T> _items = [];
//   List<T> get items => _items;
//   set items(List<T> value) {
//     _items = value;
//   }
//
//   int get page;
//   set page(int value);
//
//   int get pageSize;
//   set pageSize(int value);
//
//   IndicatorResult get indicator;
//   set indicator(IndicatorResult value);
//
//   Future<void> onRefresh();
//
//   Future<void> onLoad();
//
//   /// 更新数据源
//   void updateItems(List<T> list);
//
//   /// 更新UI
//   void updateUI();
// }
//
// /// EasyRefresh刷新 mixin
// mixin NEasyRefreshMixin<W extends StatefulWidget, T> on State<W> implements NRefreshable<T> {
//   late final refreshController = EasyRefreshController(
//     controlFinishRefresh: true,
//     controlFinishLoad: true,
//   );
//
//   // late RequestListCallback<T> onRequest = throw UnimplementedError('onRequest Unimplemented');
//
//   // late List<T> items = throw UnimplementedError('items Unimplemented');
//
//   /// 请求方式
//   late RequestListCallback<T> _onRequest;
//   RequestListCallback<T> get onRequest => _onRequest;
//   set onRequest(RequestListCallback<T> value) {
//     _onRequest = value;
//   }
//
//   // 数据列表
//   @override
//   List<T> items = [];
//
//   @override
//   int page = 1;
//
//   @override
//   final int pageSize = 20;
//
//   @override
//   var indicator = IndicatorResult.success;
//
//   @override
//   void dispose() {
//     refreshController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // DLog.d([widget.title, widget.key, hashCode]);
//       if (items.isEmpty) {
//         onRefresh();
//       }
//     });
//   }
//
//   @override
//   Future<void> onRefresh() async {
//     try {
//       page = 1;
//       final list = await onRequest(true, page, pageSize, <T>[]);
//       items.replaceRange(0, items.length, list);
//       page++;
//
//       final noMore = list.length < pageSize;
//       if (noMore) {
//         indicator = IndicatorResult.noMore;
//       }
//       refreshController.finishRefresh();
//       refreshController.resetFooter();
//     } catch (e) {
//       refreshController.finishRefresh(IndicatorResult.fail);
//     }
//     setState(() {});
//   }
//
//   @override
//   Future<void> onLoad() async {
//     if (indicator == IndicatorResult.noMore) {
//       refreshController.finishLoad();
//       return;
//     }
//
//     try {
//       final start = (items.length - pageSize).clamp(0, pageSize);
//       final prePages = items.sublist(start);
//       final list = await onRequest(false, page, pageSize, prePages);
//       items.addAll(list);
//       page++;
//
//       final noMore = list.length < pageSize;
//       if (noMore) {
//         indicator = IndicatorResult.noMore;
//       }
//       refreshController.finishLoad(indicator);
//     } catch (e) {
//       refreshController.finishLoad(IndicatorResult.fail);
//     }
//     setState(() {});
//   }
//
//   @override
//   void updateItems(List<T> list) {
//     items.replaceRange(0, items.length, list);
//     setState(() {});
//   }
//
//   @override
//   void updateUI() {
//     setState(() {});
//   }
// }
//
// class NRefreshController<T> {
//   NRefreshable<T>? _anchor;
//
//   void _attach(NRefreshable<T> anchor) {
//     _anchor = anchor;
//   }
//
//   void _detach(NRefreshable<T> anchor) {
//     if (_anchor == anchor) {
//       _anchor = null;
//     }
//   }
//
//   List<T> get items {
//     assert(_anchor != null);
//     return _anchor!.items;
//   }
//
//   void onRefresh() {
//     assert(_anchor != null);
//     _anchor!.onRefresh();
//   }
//
//   /// 页码减一
//   void turnPrePage() {
//     assert(_anchor != null);
//     _anchor!.page--;
//   }
//
//   /// 页码加一
//   void turnNextPage() {
//     assert(_anchor != null);
//     _anchor!.page++;
//   }
//
//   void updateItems(List<T> list) {
//     assert(_anchor != null);
//     _anchor!.updateItems(list);
//   }
//
//   void updateUI() {
//     assert(_anchor != null);
//     _anchor!.updateUI();
//   }
// }
