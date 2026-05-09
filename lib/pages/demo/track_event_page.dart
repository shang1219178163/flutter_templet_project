//
//  TrackEventPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/9 10:33.
//  Copyright © 2026/5/9 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/service/track_data_manager.dart';
import 'package:get/get.dart';

/// 事件追踪测试
class TrackEventPage extends StatefulWidget {
  const TrackEventPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TrackEventPage> createState() => _TrackEventPageState();
}

class _TrackEventPageState extends State<TrackEventPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("全局日志埋点"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final items = <(String, VoidCallback)>[
      ("点击", onTap),
      ("购买", onBuy),
      ("收藏", onCollect),
    ];

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              buildWrap<(String, VoidCallback)>(
                items: items,
                itemBuilder: (e) {
                  return TrackWidget(
                    params: {
                      "event": e.$1,
                      "goodsId": 1001,
                    },
                    child: ElevatedButton(
                      onPressed: e.$2,
                      child: Text(e.$1),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWrap<T>({
    required List items,
    required Widget Function(T e) itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 18.0;
        final runSpacing = 8.0;
        final rowCount = 4.0;
        final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...items.map(
              (e) {
                final i = items.indexOf(e);
                return Container(
                  width: itemWidth.truncateToDouble(),
                  height: itemWidth * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    // border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: itemBuilder(e),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void onTap() {
    DLog.d("1");
  }

  void onBuy() {
    DLog.d("2");
  }

  void onCollect() {
    DLog.d("3");
  }
}
