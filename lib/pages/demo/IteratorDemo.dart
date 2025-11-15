//
//  IteratorDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/12/2 15:05.
//  Copyright © 2024/12/2 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_button.dart';

import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 生成器测试
class IteratorDemo extends StatefulWidget {
  const IteratorDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<IteratorDemo> createState() => _IteratorDemoState();
}

class _IteratorDemoState extends State<IteratorDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final message = """
1. yield 和 yield* 就像 return，但它们不会结束函数；
2. yield 和 yield* 只能在 async* 或 sync* 生成器函数中使用；
3. yield 和 yield* 在 async* 中使用时，返回 Stream；
4. yield 和 yield* 在 sync* 中使用时，返回 Iterable；
5. yield 用于生成值，而 yield* 用于把当前生成器函数的流程委托给另一个生成器函数。
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("生成器测试"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Text(message),
              NButton(
                onPressed: () {
                  final stream = fetchEmojis(5);
                  stream.listen(DLog.d);
                },
                child: Text("async* 配合 yield 生成 Stream"),
              ),
              NButton(
                onPressed: () {
                  final items = fetchEmojisNew(5);
                  DLog.d(items);
                },
                child: Text("sync* 配合 yield 生成 Iterable"),
              ),
            ]
                .map((e) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Stream<String> fetchEmojis(int count) async* {
    for (var i = 0; i < count; i++) {
      yield await fetchEmoji(i);
    }
  }

  Future<String> fetchEmoji(int count) async {
    var first = Runes('\u{1f47f}');
    DLog.d('加载开始--${DateTime.now().toIso8601String()}');
    await Future.delayed(Duration(milliseconds: 500)); //模拟耗时
    DLog.d('加载结束--${DateTime.now().toIso8601String()}');
    return String.fromCharCodes(first.map((e) => e + count));
  }

  Iterable<String> fetchEmojisNew(int count) sync* {
    var first = Runes('\u{1f47f}');
    for (var i = 0; i < count; i++) {
      yield String.fromCharCodes(first.map((e) => e + i));
    }
  }
}
