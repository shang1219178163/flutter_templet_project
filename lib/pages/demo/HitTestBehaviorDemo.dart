import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class HitTestBehaviorDemo extends StatefulWidget {
  HitTestBehaviorDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<HitTestBehaviorDemo> createState() => _HitTestBehaviorDemoState();
}

class _HitTestBehaviorDemoState extends State<HitTestBehaviorDemo> {
  final _scrollController = ScrollController();

  final message = """
  //在命中测试过程中 Listener 组件如何表现。
enum HitTestBehavior {
  // 组件是否通过命中测试取决于子组件是否通过命中测试
  deferToChild,
  // 组件必然会通过命中测试，同时其 hitTest 返回值始终为 true
  opaque,
  // 组件必然会通过命中测试，但其 hitTest 返回值可能为 true 也可能为 false
  translucent,
}
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(message),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...HitTestBehavior.values.map((e) => buildBehaviorItem(behavior: e)),
              ],
            )
          ]
              .map((e) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: e,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget buildBehaviorItem({required HitTestBehavior behavior}) {
    // deferToChild	事件是否消费完全取决于他的儿子
    // opaque	position在自己的范围内，子类的HitTestSlef只要不被重写，自身就会消费事件
    // translucent	position在自己的范围内，都会消费事件

    // 默认情况下，Row的空白处不响应点击事件，有两个方法
    // 1. 设置behavior为HitTestBehavior.opaque或者translucent
    // 2. Container设置背景色,任意背景色都可以
    return GestureDetector(
      behavior: behavior,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          behavior.name,
          style: TextStyle(fontSize: 16),
        ),
      ),
      onTap: () {
        DLog.d("$widget ${behavior.name}");
      },
    );
  }
}
