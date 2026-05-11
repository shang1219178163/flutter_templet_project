//
//  StreamBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 9:41 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/mixin/search_controller_mixin.dart';
import 'package:flutter_templet_project/util/debounce_text_controller.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

class StreamBuilderDemo extends StatefulWidget {
  final String? title;

  const StreamBuilderDemo({Key? key, this.title}) : super(key: key);

  @override
  _StreamBuilderDemoState createState() => _StreamBuilderDemoState();
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> with SearchControllerMixin {
  // final textController = TextEditingController();
  // late final debounceTextController = DebounceTextController(
  //   controller: textController,
  //   onChanged: (String v) {
  //     searchVN.value = v;
  //   },
  // );

  late final textController = TextEditingController().debounce(
    onChanged: (String v) {
      searchVN.value = v;
    },
  );

  final searchVN = ValueNotifier("");

  final message = """
⚡ 与 Future 的关系
Future 表示 一次异步结果。
Stream 表示 一系列异步结果。
可以通过 stream.first、stream.last、stream.toList() 转换。

⚡ Flutter 常见使用场景
UI 事件：onPressed, TextField.onChanged → 都是 Stream。
网络数据：WebSocket、SSE。
状态管理：BLoC（Business Logic Component）核心就是用 Stream。
动画：Ticker、AnimationController 也是基于 Stream 思想。

⚡ 总结口诀
👉 Future 一次性，Stream 多次性
👉 Iterable 是同步集合，Stream 是异步集合
👉 Single-subscription 一次用，Broadcast 多人听
  """;

  Stream<int> counter() {
    return Stream.periodic(Duration(seconds: 1), (i) {
      return i;
    });
  }

  @override
  void dispose() {
    // debounceTextController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColorF9F9F9,
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Container(
            child: CupertinoSearchTextField(
              controller: textController,
            ),
          ),
          Text(message),
          Divider(),
          StreamBuilder<int>(
            stream: counter(), //
            //initialData: ,// a Stream<int> or null
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('没有Stream');
                case ConnectionState.waiting:
                  return Text('等待数据...');
                case ConnectionState.active:
                  return Text('active: ${snapshot.data}');
                case ConnectionState.done:
                  return Text('Stream 已关闭');
              }
              return Text('0'); // unreachable
            },
          ),
          Divider(),
          ValueListenableBuilder(
            valueListenable: searchVN,
            builder: (context, value, child) {
              return Text(value);
            },
          ),
        ],
      ),
    );
  }

  @override
  TextEditingController get searchController => textController;

  @override
  void onSearchChanged(String v) {
    DLog.d(v);
    searchVN.value = v;
  }
}

class _StateController {
  final _controller = StreamController<int>();
  Stream<int> get counterStream => _controller.stream;

  int _count = 0;

  void increment() {
    _count++;
    _controller.add(_count);
  }
}
