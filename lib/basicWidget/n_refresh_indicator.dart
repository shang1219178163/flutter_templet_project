import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/scroll/EndBounceScrollPhysics.dart';

class NRefreshIndicator extends StatefulWidget {
  const NRefreshIndicator({
    super.key,
    this.controller,
    this.offsetY,
    this.builder,
    required this.onRefresh,
    this.slivers = const <Widget>[],
    this.child,
  });

  final IndicatorController? controller;
  final double? offsetY;

  final AsyncCallback onRefresh;

  final IndicatorBuilder? builder;

  final List<Widget> slivers;

  final Widget? child;

  @override
  State<NRefreshIndicator> createState() => _NRefreshIndicatorState();
}

class _NRefreshIndicatorState extends State<NRefreshIndicator> {
  @override
  void didUpdateWidget(covariant NRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.offsetY != widget.offsetY ||
        oldWidget.builder != widget.builder ||
        oldWidget.onRefresh != widget.onRefresh ||
        oldWidget.child != widget.child ||
        oldWidget.slivers.map((e) => e.hashCode).join(",") != widget.slivers.map((e) => e.hashCode).join(",")) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // final titleColor = isDark ? Colors.white : Colors.black;
    final titleColor = Colors.black;

    return CustomRefreshIndicator(
      onRefresh: widget.onRefresh,
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        final state = controller.state;
        final progress = controller.value; // 0~1
        const double tabHeight = 44.0;
        const displacement = 44.0; //触发刷新阈值
        final childOffset = widget.offsetY ?? progress * displacement;
        final refreshHeadOffset = progress * displacement;
        var showRefreshHead = refreshHeadOffset > tabHeight || state == IndicatorState.loading;
        showRefreshHead = state == IndicatorState.loading;

        return Stack(
          children: [
            Transform.translate(
              offset: Offset(0, childOffset),
              child: child,
            ),
            if (showRefreshHead)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                // 高度跟随进度，可选
                height: tabHeight,
                child: Transform.translate(
                  offset: Offset(0, childOffset),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/loading_more.gif',
                          width: 20,
                          height: 20,
                          color: titleColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          state == IndicatorState.loading ? "加载中..." : "释放刷新",
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        );
      },
      child: widget.child ??
          CustomScrollView(
            physics: const EndBounceScrollPhysics(),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              ...widget.slivers,
            ],
          ),
    );
  }
}
