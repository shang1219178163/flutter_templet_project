import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_overlay.dart';
import 'package:flutter_templet_project/basicWidget/n_overlay_dialog.dart';
import 'package:flutter_templet_project/basicWidget/tween/NShakeTween.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class TweenSequenceDemo extends StatefulWidget {
  const TweenSequenceDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TweenSequenceDemo> createState() => _TweenSequenceDemoState();
}

class _TweenSequenceDemoState extends State<TweenSequenceDemo>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  var initialIndex = 0;

  late var items = <({Tab tab, Widget child})>[
    (tab: Tab(text: "点赞动画"), child: buildScaleAnim()),
    (tab: Tab(text: "位移动画"), child: buildOffsetAnim()),
    (tab: Tab(text: "移动抖动动画"), child: buildOffsetAndShakAnim()),
    (tab: Tab(text: "FlippedTweenSequence"), child: buildFlippedTweenSequence()),
  ];

  final message = """
  复杂动画实现:
  1.用一个 Controller + 多个 TweenSequence实现复合动画;
  2.权重（weight）本质: 占总动画时间比例;
  
  """;

  final tweenTypes = [
    "ColorTween",
    "SizeTween",
    "RectTween",
    "MaterialRectArcTween",
    "IntTween",
    "StepTween",
    "CurveTween",
    "AlignmentTween",
    "AlignmentGeometryTween",
    "BorderRadiusTween",
    "BoxConstraintsTween",
    "DecorationTween",
    "EdgeInsetsTween",
    "EdgeInsetsGeometryTween",
    "FractionalOffsetTween",
    "Matrix4Tween",
    "OffsetTween",
    "PositionedTween",
    "RelativeRectTween",
    "ShadowTween",
    "ShapeBorderTween",
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      initialIndex: initialIndex,
      length: items.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$widget'),
          actions: [
            IconButton(
              onPressed: () {
                NOverlayDialog.drawer(
                  context,
                  child: buildDrawer(
                    onChanged: (v) {
                      NOverlayDialog.dismiss();
                      DLog.d(v);
                    },
                  ),
                );
              },
              icon: Icon(Icons.more_horiz),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: items.map((e) => e.tab).toList(),
          ),
        ),
        body: TabBarView(
          children: items.map((e) => e.child).toList(),
        ),
      ),
    );
  }

  Widget buildDrawer({required ValueChanged<String> onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue),
      ),
      child: ListView.separated(
        itemBuilder: (_, i) {
          final e = tweenTypes[i];
          return ListTile(
            onTap: () {
              onChanged(e);
            },
            title: Text(e),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          );
        },
        separatorBuilder: (_, i) {
          return Divider();
        },
        itemCount: tweenTypes.length,
      ),
    );
  }

  Animation<T> buildSequence<T>(
    AnimationController controller,
    List<TweenSequenceItem<T>> items,
  ) {
    return TweenSequence<T>(items).animate(controller);
  }

  Widget buildPage({
    required AnimationController animController,
    required TransitionBuilder builder,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(color: Colors.black54),
          ),
          AnimatedBuilder(
            animation: animController,
            builder: builder,
            child: GestureDetector(
              onTap: onTap ??
                  () {
                    animController.toggle();
                  },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.blue),
                ),
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScaleAnim() {
    late final animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    final scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.5).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.5, end: 0.9).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(animController);

    final opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1, end: 0.5),
        weight: 20,
      ),
    ]).animate(animController);

    return buildPage(
      animController: animController,
      builder: (_, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.scale(
            scale: scaleAnim.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget buildOffsetAnim() {
    late final animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    final anim = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset(0, 0), end: Offset(0, 100)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset(0, 100), end: Offset(100, 100)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset(100, 100), end: Offset(100, 0)),
        weight: 30,
      ),
    ]).animate(animController);

    final scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.5).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.5, end: 0.9).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(animController);

    return buildPage(
      animController: animController,
      builder: (_, child) {
        return Transform.scale(
          scale: scaleAnim.value,
          child: Transform.translate(
            offset: anim.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget buildOffsetAndShakAnim() {
    late final animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    const end = Offset(0, 200);
    final position = TweenSequence<Offset>([
      // 移动
      TweenSequenceItem(
        tween: Tween(begin: Offset(0, 0), end: end),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ConstantTween(end),
        weight: 10,
      ),
      // 抖动
      TweenSequenceItem(
        tween: NShakeTween(center: end, amplitude: 12),
        weight: 20,
      ),
      // ✅ 保持位置（旋转阶段不再移动）
      TweenSequenceItem(
        tween: ConstantTween(end),
        weight: 20,
      ),
    ]).animate(animController);

    final rotation = TweenSequence<double>([
      // 前面阶段不旋转
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 80, // 移动+抖动
      ),

      // ✅ 旋转 360°
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 2 * pi).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(animController);

    return buildPage(
      animController: animController,
      builder: (_, child) {
        return Transform.translate(
          offset: position.value,
          child: Transform.rotate(
            angle: rotation.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget buildFlippedTweenSequence() {
    late final animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    final items = <TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 100),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: ConstantTween(100),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 100, end: 0),
        weight: 40,
      ),
    ];
    final forward = TweenSequence<double>(items);
    final backward = FlippedTweenSequence(items);

    final animation = TweenSequence<double>([
      TweenSequenceItem(tween: forward, weight: 50),
      TweenSequenceItem(tween: backward, weight: 50),
    ]).animate(animController);

    return buildPage(
      animController: animController,
      onTap: () {
        animController.forward(from: 0);
      },
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(animation.value, 0),
          child: child,
        );
      },
    );
  }
}
