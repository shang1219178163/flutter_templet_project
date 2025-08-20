//
//  StreamBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 9:41 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class StreamBuilderDemo extends StatefulWidget {
  final String? title;

  const StreamBuilderDemo({Key? key, this.title}) : super(key: key);

  @override
  _StreamBuilderDemoState createState() => _StreamBuilderDemoState();
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Text(message),
        StreamBuilder<int>(
          stream: counter(), //
          //initialData: ,// a Stream<int> or null
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
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
      ],
    );
  }
}
