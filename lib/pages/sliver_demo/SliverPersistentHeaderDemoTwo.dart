import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_resize_switch.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:get/get.dart';

class SliverPersistentHeaderDemoTwo extends StatefulWidget {
  const SliverPersistentHeaderDemoTwo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SliverPersistentHeaderDemoTwo> createState() => _SliverPersistentHeaderDemoTwoState();
}

class _SliverPersistentHeaderDemoTwoState extends State<SliverPersistentHeaderDemoTwo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  bool pinned = true;
  bool floating = true;

  @override
  void didUpdateWidget(covariant SliverPersistentHeaderDemoTwo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.toString()),
      ),
      body: EasyRefresh(
        onRefresh: () {
          DLog.d("onRefresh");
        },
        onLoad: () {
          DLog.d("onLoad");
        },
        child: CustomScrollView(
          slivers: [
            buildHeader(),
            buildListView(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    var min = context.paddingTop;
    var max = 250.0;
    return NSliverPersistentHeaderBuilder(
      pinned: pinned,
      floating: floating,
      min: min,
      max: max,
      builder: (BuildContext context, double shrinkOffset, bool overlapsContent) {
        // 根据 shrinkOffset 动态调整标题内容大小
        var sizeFactor = 1 - (shrinkOffset / (max - min));
        var titleSize = 30 * sizeFactor; // 标题文字的动态大小

        var leaveOffset = (max - shrinkOffset);
        // double progress = shrinkOffset / (max - min);
        var progress = shrinkOffset / (max - 0);

        final isExpanded = progress < 1.0;

        var opacity = (1.0 - progress).clamp(0.0, 1.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片
            Image.network(
              AppRes.image.urls[5],
              fit: BoxFit.cover,
            ),
            // 带有渐变的遮罩层
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            if (progress >= 0.5)
              AnimatedOpacity(
                opacity: 1.0 - opacity,
                duration: Duration(milliseconds: 100),
                child: Text(
                  "Resizable Header ${{
                    "shrinkOffset": shrinkOffset.toStringAsFixed(2),
                    "leaveOffset": leaveOffset.toStringAsFixed(2),
                    "progress": progress.toStringAsFixed(2),
                  }} ",
                  style: TextStyle(
                    color: Colors.white,
                    // fontSize: titleSize,
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.yellow, width: 1),
              ),
              child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(milliseconds: 100),
                child: OverflowBox(
                  maxWidth: context.width,
                  maxHeight: max,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Resizable Header ${{
                          "shrinkOffset": shrinkOffset.toStringAsFixed(2),
                          "leaveOffset": leaveOffset.toStringAsFixed(2),
                          "progress": progress.toStringAsFixed(2),
                        }} ",
                        style: TextStyle(
                          color: Colors.white,
                          // fontSize: titleSize,
                        ),
                      ),
                      buildSwitch(
                        name: "pinned",
                        value: pinned,
                        onChanged: (val) {
                          pinned = val;
                          setState(() {});
                        },
                      ),
                      buildSwitch(
                        name: "floating",
                        value: floating,
                        onChanged: (val) {
                          floating = val;
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Column(
                          children: List.generate(
                              5,
                              (index) => Container(
                                    child: Text(
                                      "项目$index",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          title: Text('Item #$index'),
        ),
        childCount: 20,
      ),
    );
  }

  Widget buildSwitch({
    required String name,
    required bool value,
    ValueChanged<bool>? onChanged,
  }) {
    return NPair(
      icon: NText(
        name,
      ),
      child: NResizeSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
