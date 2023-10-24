

import 'package:flutter/material.dart';

class HitTestBehaviorDemo extends StatefulWidget {

  HitTestBehaviorDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  State<HitTestBehaviorDemo> createState() => _HitTestBehaviorDemoState();
}

class _HitTestBehaviorDemoState extends State<HitTestBehaviorDemo> {

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
            buildSection(),
          ],
        ),
      ),
    );
  }

  buildSection() {
    // deferToChild	事件是否消费完全取决于他的儿子
    // opaque	position在自己的范围内，子类的HitTestSlef只要不被重写，自身就会消费事件
    // translucent	position在自己的范围内，都会消费事件

    // 默认情况下，Row的空白处不响应点击事件，有两个方法
    // 1. 设置behavior为HitTestBehavior.opaque或者translucent
    // 2. Container设置背景色,任意背景色都可以
    return GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        child: Container(
          height: 50,
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 5, right: 5),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "left text",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "right text",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        onTap: () {
          debugPrint("${DateTime.now().toString().split(".").first} click");
        },
      );
  }
  
}