import 'package:flutter/material.dart';

class SliverFloatingHeaderDemo extends StatelessWidget {
  const SliverFloatingHeaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 使用 SliverPersistentHeader 实现浮动标题
          SliverPersistentHeader(
            pinned: true, // 保证标题在顶部浮动
            floating: true,
            delegate: FloatingHeaderDelegate(
              minHeight: 60.0,
              maxHeight: 120.0,
            ),
          ),
          // 用 SliverList 填充内容
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('Item #$index'),
              ),
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// 自定义 SliverPersistentHeaderDelegate 用于创建浮动标题
class FloatingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  FloatingHeaderDelegate({required this.minHeight, required this.maxHeight});

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(
        "Floating Header ${{
          "shrinkOffset": shrinkOffset.toStringAsFixed(2),
        }} ",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant FloatingHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}
