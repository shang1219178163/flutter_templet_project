import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/util/R.dart';
import 'package:get/get.dart';

class SliverPersistentHeaderTwo extends StatefulWidget {
  const SliverPersistentHeaderTwo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SliverPersistentHeaderTwo> createState() =>
      _SliverPersistentHeaderTwoState();
}

class _SliverPersistentHeaderTwoState extends State<SliverPersistentHeaderTwo> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant SliverPersistentHeaderTwo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          NSliverPersistentHeaderBuilder(
            pinned: true,
            min: 80.0,
            max: 250.0,
            builder: (BuildContext context, double shrinkOffset,
                bool overlapsContent) {
              // 根据 shrinkOffset 动态调整标题内容大小
              double sizeFactor = 1 - (shrinkOffset / (250 - 80));
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
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
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
