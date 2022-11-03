import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:flutter_templet_project/basicWidget/SliverPersistentHeaderBuilder.dart';

class SliverPersistentHeaderDemo extends StatelessWidget {

  final list = Colors.primaries.take(4).toList();


  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverPersistentHeaderBuilder(
        min: 60.0,
        max: 60.0,
        builder: (ctx, offset) => SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Text(headerText),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverPersistentHeader'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          makeHeader('Header Section 1'),
          SliverGrid.count(
            crossAxisCount: 4,
              children: list.map((e) => Container(color: e)).toList(),
            // children: Colors.accents.map((e) => Container(color: e)).toList(),
          ),
          makeHeader('Header Section 2'),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: Text('grid item $index'),
                );
              },
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });
  final double minHeight;
  final double maxHeight;
  final Widget Function(BuildContext context, double offset) builder;

  @override
  double get minExtent => minHeight; // 最小高度，即闭合时的高度
  @override
  double get maxExtent => math.max(maxHeight, minHeight); // 最大高度，即展开时的高度

  // 绘制header
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset);
  }

  /// 是否需要重新绘制
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }
}


