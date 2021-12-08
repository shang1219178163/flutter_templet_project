//
//  SliverPersistentHeaderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/13/21 8:57 AM.
//  Copyright © 10/13/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverPersistentHeaderDemo extends StatelessWidget {
  // 色彩数据
  // final List<Color> data = List.generate(24, (i) => Color(0xFFFF00FF - 24*i));
  final List<Color> data = Colors.primaries.take(4).toList();
  final List<Color> data1 = Colors.primaries.take(1).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$this"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _buildPersistentHeader("section0"), //<-- 在列表上方创建PersistentHeader
          _buildSliverList(list: data1),
          _buildPersistentHeader("section1"),
          _buildSliverList(list: data),

        ],
      ),
    );
  }

  // 构建颜色列表
  Widget _buildSliverList({required List<Color> list}) =>
      SliverList(
        delegate: SliverChildBuilderDelegate((_, int index)
        => _buildColorItem(list[index], index),
            childCount: list.length),
      );

  // 构建颜色列表item
  Widget _buildColorItem(Color color, int index) =>
      Card(
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 60,
          color: color,
          child: Text(
            index == 0 ? colorString(color) : colorString1(color),
            style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black,
                      offset: Offset(.5, .5),
                      blurRadius: 2)
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
      delegate: PersistentHeaderBuilder(builder: (ctx, offset) => Container(
        alignment: Alignment.center,
        color: Colors.orangeAccent,
        child: Text(
          "$title shrinkOffset:${offset.toStringAsFixed(1)}",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      )));

}


class PersistentHeaderBuilder extends SliverPersistentHeaderDelegate {
  final double max;
  final double min;
  final Widget Function(BuildContext context, double offset) builder;

  PersistentHeaderBuilder({
    this.max = 120,
    this.min = 80,
    required this.builder})
      : assert(max >= min);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset);
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant PersistentHeaderBuilder oldDelegate) =>
      max != oldDelegate.max ||
          min != oldDelegate.min ||
          builder != oldDelegate.builder;
}
