import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';

class PinnedHeaderSliverDemo extends StatelessWidget {
  const PinnedHeaderSliverDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 使用 SliverPersistentHeader 实现固定标题
          NSliverPersistentHeaderBuilder(
            pinned: true, // 确保标题在顶部固定
            min: 60.0,
            max: 120.0,
            builder: (BuildContext context, double shrinkOffset,
                bool overlapsContent) {
              return Container(
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text(
                  "Pinned Header ${{
                    "shrinkOffset": shrinkOffset.toStringAsFixed(2),
                  }} ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            },
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
