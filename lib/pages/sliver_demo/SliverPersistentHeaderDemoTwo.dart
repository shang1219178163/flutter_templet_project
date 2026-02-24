import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_resize_switch.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/refresh/n_custom_scrollView.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
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
  final _scrollController = ScrollController();

  late final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  bool pinned = false;
  bool floating = false;

  @override
  void didUpdateWidget(covariant SliverPersistentHeaderDemoTwo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColorF9F9F9,
      appBar: AppBar(
        title: Text(widget.toString()),
      ),
      body: buildBodyNew(),
    );
  }

  Widget buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, bool innerBoxIsScrolled) {
        return [
          buildPersistentHeader(bgUrl: AppRes.image.urls[6]),
        ];
      },
      body: EasyRefresh.builder(
        controller: refreshController,
        onRefresh: onRefresh,
        onLoad: onLoad,
        childBuilder: (_, physics) {
          return CustomScrollView(
            physics: physics,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 40,
                  color: Colors.green,
                ),
              ),
              buildListView(),
            ],
          );
        },
      ),
    );
  }

  Widget buildBodyNew() {
    return NestedScrollView(
      headerSliverBuilder: (context, bool innerBoxIsScrolled) {
        return [
          buildPersistentHeader(bgUrl: AppRes.image.urls[5]),
        ];
      },
      body: NCustomScrollView<String>(
        onRequest: (bool isRefresh, int page, int pageSize, pres) async {
          final length = isRefresh ? 0 : pres.length;
          final list = List<String>.generate(pageSize, (i) => "item${length + i}");
          return list;
        },
        headerBuilder: buildListViewHeader,
        itemBuilder: (_, i, e) {
          return ListTile(
            title: Text('Item $i'),
          );
        },
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.finishRefresh();
    refreshController.resetFooter();
    DLog.d("onRefresh");
  }

  Future<void> onLoad() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.finishLoad();
    DLog.d("onLoad");
  }

  Widget buildPersistentHeader({required String bgUrl}) {
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

        return DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片
              NNetworkImage(
                url: bgUrl,
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
                              (index) {
                                return Container(
                                  child: Text(
                                    "项目$index",
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildListViewHeader(int count) {
    return [
      SliverToBoxAdapter(
        child: Container(
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          child: Text("共 $count 数据"),
        ),
      ),
    ];
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
    Color? textColor,
    required bool value,
    ValueChanged<bool>? onChanged,
  }) {
    return NPair(
      icon: NText(
        name,
        style: TextStyle(
          color: textColor,
        ),
      ),
      child: NResizeSwitch(
        height: 30,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
