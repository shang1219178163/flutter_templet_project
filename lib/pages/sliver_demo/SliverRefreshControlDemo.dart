import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/placehorlder/activity_indicator_placehorlder.dart';
import 'package:flutter_templet_project/basicWidget/placehorlder/list_footer_no_more_placehorlder.dart';
import 'package:flutter_templet_project/basicWidget/refresh_control/NLoadMoreControl.dart';
import 'package:flutter_templet_project/basicWidget/refresh_control/NRefreshControl.dart';
import 'package:flutter_templet_project/basicWidget/refresh_control/cupertino_sliver_refresh_control_ext.dart';

class SliverRefreshControlDemo extends StatefulWidget {
  const SliverRefreshControlDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SliverRefreshControlDemo> createState() => _SliverRefreshControlDemoState();
}

class _SliverRefreshControlDemoState extends State<SliverRefreshControlDemo> {
  final scrollController = ScrollController();

  var list = List.generate(10, (i) => "item_$i");

  final loadController = NLoadMoreController();

  @override
  void didUpdateWidget(covariant SliverRefreshControlDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      // controller: scrollController,
      slivers: [
        ...buildRefreshListView(
          list: list,
          onRefresh: onRefresh,
          onLoad: onLoad,
          loadController: loadController,
        ),
      ],
    );
  }

  List<Widget> buildRefreshListView({
    required List<String> list,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onLoad,
    required NLoadMoreController loadController,
  }) {
    return [
      // CupertinoSliverRefreshControl(
      //   // builder: buildRefreshIndicator,
      //   builder: CupertinoSliverRefreshControlExt.customRefreshIndicator,
      //   onRefresh: onRefresh,
      // ),
      /// 下拉刷新
      SliverToBoxAdapter(
        child: NRefreshControl(
          onRefresh: onRefresh,
          builder: (_, isLoading) {
            return isLoading ? const ActivityIndicatorPlacehorlder(message: "刷新中") : const SizedBox.shrink();
          },
        ),
      ),

      /// 列表
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final e = list[index];
            return SizedBox(
              height: 45,
              child: ListTile(
                leading: const Icon(Icons.place),
                title: Text(e),
              ),
            );
          },
          childCount: list.length,
        ),
      ),

      /// 上拉加载更多
      SliverToBoxAdapter(
        child: NLoadMoreControl(
          controller: loadController,
          onLoad: onLoad,
          builder: (_, hasMore, isLoading) {
            if (!hasMore) {
              return const ListFooterNoMorePlacehorlder();
            }
            return isLoading ? const ActivityIndicatorPlacehorlder() : const SizedBox.shrink();
          },
        ),
      ),
    ];
  }

  Future<void> onRefresh() async {
    await fetchPage(isRefresh: true);
  }

  Future<void> onLoad() async {
    await fetchPage(isRefresh: false);
  }

  Future<void> fetchPage({required bool isRefresh}) async {
    await Future.delayed(Duration(milliseconds: 1500));
    if (isRefresh) {
      list = List.generate(20, (i) => "item_${i}");
      loadController.resetState(noMore: false);
    } else {
      var items = List.generate(20, (i) => "item_${list.length + i}");
      list.addAll(items);
      var noMore = items.length < 20;
      noMore = list.length > 59;
      debugPrint([items.length, list.length, noMore].join("_"));
      loadController.resetState(noMore: noMore);
    }
    setState(() {});
  }
}
