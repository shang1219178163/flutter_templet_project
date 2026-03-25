import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_animation_controller_builder.dart';
import 'package:flutter_templet_project/basicWidget/n_flip_card.dart';
import 'package:flutter_templet_project/generated/assets.dart';

/// 后缀为 Transition 的组件实例
class SuffixTransitionDemo extends StatefulWidget {
  const SuffixTransitionDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SuffixTransitionDemo> createState() => _SuffixTransitionDemoState();
}

class _SuffixTransitionDemoState extends State<SuffixTransitionDemo> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var initialIndex = 0;

  late var items = <({Tab tab, Widget child})>[
    (tab: Tab(text: "FlipCard\n（左右翻转）"), child: buildFlipCard()),
    (tab: Tab(text: "SlideTransition\n（位移）"), child: buildPageSlideTransition()),
    (tab: Tab(text: "ScaleTransition\n（缩放）"), child: buildPageScaleTransition()),
    (tab: Tab(text: "RotationTransition\n（旋转）"), child: buildPageRotationTransition()),
    (tab: Tab(text: "SizeTransition\n（尺寸变化）"), child: buildPageSizeTransition()),
    (tab: Tab(text: "FadeTransition\n（透明度）"), child: buildPageFadeTransition()),
    (tab: Tab(text: "AlignTransition\n（对齐变化）"), child: buildPageAlignTransition()),
    (tab: Tab(text: "PositionedTransition\n（定位变化）"), child: buildPagePositionedTransition()),
    (tab: Tab(text: "RelativePositionedTransition\n（相对定位）"), child: buildPageRelativePositionedTransition()),
    (tab: Tab(text: "DecoratedBoxTransition\n（装饰变化）"), child: buildPageDecoratedBoxTransition()),
    (tab: Tab(text: "DefaultTextStyleTransition\n（文本样式）"), child: buildPageDefaultTextStyleTransition()),
    (tab: Tab(text: "MatrixTransition\n（矩阵变换）"), child: buildPageMatrixTransition()),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      initialIndex: initialIndex,
      length: items.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: items.map((e) => e.tab).toList(),
          ),
          title: Text('$widget'),
        ),
        body: TabBarView(
          children: items.map((e) => e.child).toList(),
        ),
      ),
    );
  }

  Widget buildPageSlideTransition() {
    final tween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    );
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final animation = tween.animate(animController);

        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: animation,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlutterLogo(size: 150.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPageScaleTransition() {
    final tween = Tween<double>(
      begin: 0.5,
      end: 1,
    );
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final animation = tween.animate(animController);

        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: animation,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlutterLogo(size: 150.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPageRotationTransition() {
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final animation = CurvedAnimation(
          parent: animController,
          curve: Curves.elasticOut,
        );
        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotationTransition(
                  turns: animation,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlutterLogo(size: 150.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPageSizeTransition() {
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final animation = CurvedAnimation(
          parent: animController,
          curve: Curves.fastOutSlowIn,
        );
        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  axisAlignment: -1,
                  child: FlutterLogo(size: 150),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPageFadeTransition() {
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final animation = CurvedAnimation(
          parent: animController,
          curve: Curves.easeIn,
        );
        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: animation,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: FlutterLogo(size: 150),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPageAlignTransition() {
    final tween = Tween<AlignmentGeometry>(
      begin: Alignment.bottomLeft,
      end: Alignment.center,
    );
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final animation = tween.animate(animController);

        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AlignTransition(
                  alignment: animation,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlutterLogo(size: 150.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPagePositionedTransition() {
    const double smallLogo = 100;
    const double bigLogo = 200;
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size biggest = constraints.biggest;

        final tween = RelativeRectTween(
          begin: RelativeRect.fromSize(
            const Rect.fromLTWH(0, 0, smallLogo, smallLogo),
            biggest,
          ),
          end: RelativeRect.fromSize(
            Rect.fromLTWH(
              biggest.width - bigLogo,
              biggest.height - bigLogo,
              bigLogo,
              bigLogo,
            ),
            biggest,
          ),
        );
        return NAnimationControllerBuilder(
          duration: const Duration(milliseconds: 2000),
          builder: (_, child, animController) {
            final animation = tween.animate(animController);

            return GestureDetector(
              onTap: () {
                animController.toggle();
              },
              child: Stack(
                children: <Widget>[
                  PositionedTransition(
                    rect: animation,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: FlutterLogo(size: 150.0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildPageRelativePositionedTransition() {
    const double smallLogo = 100;
    const double bigLogo = 200;
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size biggest = constraints.biggest;

        final tween = RectTween(
          begin: const Rect.fromLTWH(0, 0, bigLogo, bigLogo),
          end: Rect.fromLTWH(
            biggest.width - smallLogo,
            biggest.height - smallLogo,
            smallLogo,
            smallLogo,
          ),
        );
        return NAnimationControllerBuilder(
          duration: const Duration(milliseconds: 2000),
          builder: (_, child, animController) {
            final animation = tween.animate(animController);

            return GestureDetector(
              onTap: () {
                animController.toggle();
              },
              child: Stack(
                children: <Widget>[
                  RelativePositionedTransition(
                    size: biggest,
                    rect: animation,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: FlutterLogo(size: 150.0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildPageDecoratedBoxTransition() {
    final tween = DecorationTween(
      begin: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(60)),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            color: Colors.blue,
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      end: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(60)),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            color: Colors.white,
            blurRadius: 15,
            spreadRadius: 6,
          )
        ],
      ),
    );
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final animation = tween.animate(animController);

        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBoxTransition(
                  decoration: animation,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const FlutterLogo(size: 150.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPageDefaultTextStyleTransition() {
    final tween = TextStyleTween(
      begin: const TextStyle(
        fontSize: 50,
        color: Colors.blue,
        fontWeight: FontWeight.w900,
      ),
      end: const TextStyle(
        fontSize: 50,
        color: Colors.red,
        fontWeight: FontWeight.w100,
      ),
    );
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final curvedAnimation = CurvedAnimation(
          parent: animController,
          curve: Curves.elasticInOut,
        );
        final animation = tween.animate(curvedAnimation);

        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyleTransition(
                  style: animation,
                  child: const Text('Flutter'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPageMatrixTransition() {
    return NAnimationControllerBuilder(
      duration: const Duration(milliseconds: 2000),
      builder: (_, child, animController) {
        final animation = CurvedAnimation(
          parent: animController,
          curve: Curves.easeIn,
        );
        return GestureDetector(
          onTap: () {
            animController.toggle();
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MatrixTransition(
                  animation: animation,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlutterLogo(size: 150.0),
                  ),
                  onTransform: (double value) {
                    return Matrix4.identity()
                      ..setEntry(3, 2, 0.004)
                      ..rotateY(pi * 2.0 * value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFlipCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NFlipCard(
            fontBuilder: (onToggle) {
              return GestureDetector(
                onTap: onToggle,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Image(
                    image: AssetImage(Assets.imagesBgMk11),
                    width: 300,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
            backBuilder: (onToggle) {
              return GestureDetector(
                onTap: onToggle,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Image(
                    image: AssetImage(Assets.imagesBgNfs),
                    width: 380,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
