//
//  SliverPersistentHeaderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/13/21 8:57 AM.
//  Copyright © 10/13/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';

class SliverPersistentHeaderDemoOne extends StatelessWidget {
  SliverPersistentHeaderDemoOne({Key? key}) : super(key: key);

  // 色彩数据
  // final List<Color> data = List.generate(24, (i) => Color(0xFFFF00FF - 24*i));
  final List<Color> data = Colors.primaries.sublist(5, 10);
  final List<Color> data1 = Colors.primaries.take(1).toList();
  final List<Color> data2 = Colors.accents.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$this"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverList(list: data),
          _buildPersistentHeader("section0"), //<-- 在列表上方创建PersistentHeader
          _buildSliverList(list: data1),
          _buildPersistentHeader("section1"),
          _buildSliverList(list: data2),
        ],
      ),
    );
  }

  // 构建颜色列表
  Widget _buildSliverList({required List<Color> list}) => SliverList(
        delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildColorItem(list[index], index),
            childCount: list.length),
      );

  // 构建颜色列表item
  Widget _buildColorItem(Color color, int index) => Card(
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 60,
          color: color,
          child: Text(
            index == 0 ? colorString(color) : colorString1(color),
            style: const TextStyle(color: Colors.white, shadows: [
              Shadow(color: Colors.black, offset: Offset(.5, .5), blurRadius: 2)
            ]),
          ),
        ),
      );

  // 颜色转换为文字
  String colorString(Color color) =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
  String colorString1(Color color) =>
      "#${color.value.toRadixString(16).toUpperCase()}";

  Widget _buildPersistentHeader(String title) => SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: NSliverPersistentHeaderDelegate(
          builder: (ctx, offset, overlapsContent) => Container(
                alignment: Alignment.center,
                color: Colors.orangeAccent,
                child: Text(
                  "$title shrinkOffset:${offset.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )));
}
