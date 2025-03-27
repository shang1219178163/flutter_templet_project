//
//  NTreeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2023/4/1 07:38.
//  Copyright © 2023/4/1 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NTree/NTree.dart';

class NTreeDemo extends StatefulWidget {
  NTreeDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NTreeDemoState createState() => _NTreeDemoState();
}

class _NTreeDemoState extends State<NTreeDemo> {
  final _list = [
    NTreeNodeModel(
        name: '1 一级菜单',
        isExpand: true, //是否展开子项
        enabled: false, //是否可以响应事件
        items: [
          NTreeNodeModel(name: '1.1 二级菜单', isExpand: true, items: [
            NTreeNodeModel(name: '1.1.1 三级菜单', isExpand: true, items: [
              NTreeNodeModel(
                name: '1.1.1.1 四级菜单',
                isExpand: true,
              ),
            ]),
          ]),
          NTreeNodeModel(
            name: '1.2 二级菜单',
            isExpand: true,
          ),
        ]),
    NTreeNodeModel(
        name: '2 一级菜单',
        // isExpand: true,
        items: [
          NTreeNodeModel(
            name: '2.1 二级菜单',
            // isExpand: true,
          ),
          NTreeNodeModel(name: '2.2 二级菜单', isExpand: false, items: [
            NTreeNodeModel(
              name: '2.2.1 三级菜单',
              // isExpand: true,
            ),
          ]),
        ]),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return CustomScrollView(
      slivers: [
        Text(arguments.toString()),
        NTree(
          list: _list,
        ),
      ]
          .map((e) => SliverToBoxAdapter(
                child: e,
              ))
          .toList(),
    );
  }

  onPressed() {}
}
