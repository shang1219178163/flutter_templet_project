//
//  AnimatedListDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/18/23 3:26 PM.
//  Copyright © 1/18/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class AnimatedListDemo extends StatefulWidget {
  const AnimatedListDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AnimatedListDemoState createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  var data = List.generate(9, (index) => "$index").toList();
  int counter = 5;

  final globalKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: () => debugPrint(e.toString()),
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildAnimatedList(),
    );
  }

  Widget buildAnimatedList() {
    return Stack(
      children: [
        AnimatedList(
          key: globalKey,
          initialItemCount: data.length,
          itemBuilder: (context, index, animation) {
            return FadeTransition(
              opacity: animation,
              child: buildItem(data[index], index: index),
            );
          },
        ),
        if (data.isEmpty)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.all_inclusive),
                Text("暂无数据"),
              ],
            ),
          ),
        buildAddBtn(),
      ],
    );
  }

  // 创建一个 “+” 按钮，点击后会向列表中插入一项
  Widget buildAddBtn() {
    return Positioned(
      bottom: 30,
      // left: 0,
      right: 0,
      child: FloatingActionButton(
        onPressed: () {
          // 添加一个列表项
          data.add('${++counter}');
          // 告诉列表项有新添加的列表项
          globalKey.currentState!.insertItem(data.length - 1);
          debugPrint('添加 $counter');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildItem(String char, {int? index}) {
    return ListTile(
      key: ValueKey(char),
      title: Text(char),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: index == null ? null : () => onDelete(index),
      ),
    );
  }

  void onDelete(int index) {
    final char = data.removeAt(index);
    debugPrint('删除 $char');
    globalKey.currentState!.removeItem(
      index,
      (context, animation) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0.5, 1.0),
          ),
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0.0,
            child: buildItem(char),
          ),
        );
      },
      duration: const Duration(milliseconds: 200),
    );
    setState(() {});
  }
}
