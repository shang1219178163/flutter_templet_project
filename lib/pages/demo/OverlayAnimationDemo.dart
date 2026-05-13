import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_floating_draggable.dart';
import 'package:flutter_templet_project/basicWidget/n_popup_adaptive_container.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_dialog.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:tuple/tuple.dart';

///  Overlay 动画
class OverlayAnimationDemo extends StatefulWidget {
  const OverlayAnimationDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<OverlayAnimationDemo> createState() => _OverlayAnimationDemoState();
}

class _OverlayAnimationDemoState extends State<OverlayAnimationDemo> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var initialIndex = 0;

  late var items = <Tuple2<Tab, Widget>>[];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    items = <Tuple2<Tab, Widget>>[
      Tuple2(Tab(text: "NOverlayDialog"), buildPage()),
      Tuple2(Tab(text: "选项2"), buildPage1()),
      Tuple2(Tab(text: "选项2"), buildPage2()),
    ];

    return DefaultTabController(
      initialIndex: initialIndex,
      length: items.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: items.map((e) => e.item1).toList(),
          ),
          title: Text('$widget'),
        ),
        body: TabBarView(
          children: items.map((e) => e.item2).toList(),
        ),
      ),
    );
  }

  Widget buildPage() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildWrap(
                  onChanged: (v) {
                    NOverlayDialog.show(
                      context,
                      from: v,
                      barrierColor: Colors.black12,
                      // barrierDismissible: false,
                      onBarrier: () {
                        DLog.d('NOverlayDialog onBarrier');
                      },
                      child: GestureDetector(
                        onTap: () {
                          NOverlayDialog.dismiss();
                          DLog.d('NOverlayDialog onBarrier');
                        },
                        child: Container(
                          width: 300,
                          height: 300,
                          child: buildContent(
                            title: v.toString(),
                            onTap: () {
                              NOverlayDialog.dismiss();
                              DLog.d('NOverlayDialog onBarrier');
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            NOverlayDialog.sheet(
                              context,
                              child: NPopupAdaptiveContainer(
                                backgroundColor: Colors.transparent,
                                child: buildContent(
                                  // height: 400,
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  onTap: () {
                                    NOverlayDialog.dismiss();
                                  },
                                ),
                              ),
                            );
                          },
                          child: Text("NOverlayDialog.sheet"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            NOverlayDialog.drawer(
                              context,
                              child: buildContent(
                                title: "NOverlayManager.drawer",
                                radius: 0,
                                onTap: () {
                                  NOverlayDialog.dismiss();
                                },
                              ),
                            );
                          },
                          child: Text("NOverlayManager.drawer"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            NOverlayDialog.toast(
                              context,
                              hideBarrier: true,
                              from: Alignment.center,
                              message: "This is a Toast!",
                            );
                          },
                          child: Text("NOverlayDialog.toast"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            NOverlayDialog.loading(
                              context,
                              indicator: CupertinoActivityIndicator(radius: 16, color: Colors.white),
                              child: Container(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ElevatedButton(
                                  onPressed: NOverlayDialog.dismiss,
                                  child: Text('dismiss'),
                                ),
                              ),
                            );
                          },
                          child: Text("NOverlayDialog.loading"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            NOverlayDialog.show(
                              context,
                              hideBarrier: true, // 悬浮一般不需要遮罩
                              child: NFloatingDraggable(
                                margin: EdgeInsets.symmetric(horizontal: -30, vertical: 100),
                                child: buildFloatingWidget(),
                              ),
                            );
                          },
                          child: const Text('显示悬浮组件'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ]
            .map(
              (e) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                  child: e,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildWrap({required ValueChanged<Alignment> onChanged}) {
    final list = AlignmentExt.allCases;
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 8.0;
        final rowCount = 3.0;
        final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...list.map(
              (e) {
                final i = list.indexOf(e);
                final btnTitle = [e.toString().split(".").last, "(${e.x}, ${e.y})"].join("\n");
                return GestureDetector(
                  onTap: () => onChanged(e),
                  child: Container(
                    width: itemWidth.truncateToDouble(),
                    height: itemWidth * 0.618,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(btnTitle),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildPage1() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                color: ColorExt.random,
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  Widget buildPage2() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                color: ColorExt.random,
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  Widget buildContent({
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    double? radius,
    String? title,
    VoidCallback? onTap,
  }) {
    final btnTitle = title ?? "buildContent";
    return Container(
      width: width,
      height: height,
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorExt.random,
        // color: Colors.yellow,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 16)),
      ),
      child: ElevatedButton(
        onPressed: () {
          debugPrint(btnTitle);
          onTap?.call();
        },
        child: Text(btnTitle),
      ),
    );
  }

  Widget buildFloatingWidget() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            debugPrint('点击悬浮球');
          },
          child: const Center(
            child: Text(
              '拖我',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
