//
//  TracelessLoadDemo.dart
//  flutter_templet_project
//
//  NTracelessLoadMixin / NTracelessEasyRefreshLoadMixin 使用示例
//

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_easy_refresh_mixin.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_traceless_load_mixin.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 无痕加载更多 Demo：下拉刷新 + 近底自动加载（无 footer）
class TracelessLoadDemo extends StatefulWidget {
  const TracelessLoadDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TracelessLoadDemo> createState() => _TracelessLoadDemoState();
}

class _TracelessLoadDemoState extends State<TracelessLoadDemo>
    with
        NListRefreshMixin<String>,
        NListRefreshStateMixin<TracelessLoadDemo, String>,
        NTracelessEasyRefreshLoadMixin<TracelessLoadDemo, String> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  late final _scrollController = ScrollController();

  @override
  void initState() {
    onRequest = _onRequest;
    pageSize = 20;
    // 外部注入；dispose 由本 State 负责
    scrollController = _scrollController;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  /// 模拟分页；page > 5 返回空表示没有更多
  Future<List<String>> _onRequest(
    bool isRefresh,
    int page,
    int pageSize,
    List<String> pres,
  ) async {
    DLog.d("page=$page, pageSize=$pageSize, pres=${pres.length}");
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (page > 5) {
      return <String>[];
    }
    final start = (page - 1) * pageSize;
    return List.generate(pageSize, (i) => 'Item ${start + i + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              '下拉刷新；滑到距底部 ${triggerDistance.toInt()}px 内自动加载下一页（无 footer）。'
              '当前 ${items.length} 条，${hasNextPage ? "还有更多" : "已全部加载"}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        Expanded(
          child: EasyRefresh(
            controller: refreshController,
            onRefresh: onRefresh,
            // 无痕加载：不挂 footer onLoad，由 NTracelessEasyRefreshLoadMixin 触发
            onLoad: null,
            child: items.isEmpty
                ? ListView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('下拉刷新加载数据')),
                    ],
                  )
                : ListView.separated(
                    controller: scrollController,
                    itemCount: items.length + (isLoading && hasNextPage ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index >= items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      final e = items[index];
                      return ListTile(
                        dense: true,
                        title: Text(e),
                        subtitle: Text('index=$index  page=$page'),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
