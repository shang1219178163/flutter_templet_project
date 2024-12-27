import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/R.dart';

class SliverResizingHeaderDemo extends StatelessWidget {
  const SliverResizingHeaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 使用 SliverPersistentHeader 实现可调整大小的标题
          SliverPersistentHeader(
            pinned: true,
            delegate: ResizingHeaderDelegate(
              minHeight: 80.0,
              maxHeight: 250.0,
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

// 自定义 SliverPersistentHeaderDelegate 用于创建可调整大小的标题
class ResizingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  ResizingHeaderDelegate({required this.minHeight, required this.maxHeight});

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 根据 shrinkOffset 动态调整标题内容大小
    double sizeFactor = 1 - (shrinkOffset / (maxExtent - minExtent));
    double titleSize = 30 * sizeFactor; // 标题文字的动态大小

    return Stack(
      fit: StackFit.expand,
      children: [
        // 背景图片
        Image.network(
          R.image.urls[5],
          fit: BoxFit.cover,
        ),
        // 带有渐变的遮罩层
        // Container(
        //   color: Colors.black.withOpacity(0.3),
        // ),
        // 标题内容
        Center(
          child: Text(
            "Resizable Header ${{
              "shrinkOffset": shrinkOffset.toStringAsFixed(2),
            }} ",
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant ResizingHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}
