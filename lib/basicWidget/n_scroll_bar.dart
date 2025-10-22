import 'package:flutter/material.dart';

class NScrollBar extends StatelessWidget {
  const NScrollBar({
    super.key,
    required this.controller,
    this.scrollDirection = Axis.vertical,
    this.scrollStopHide = false,
    this.length,
    this.indicatorLength = 46,
    this.thickness = 5,
    this.indicator,
    this.indicatorBg,
    required this.child,
  });

  final ScrollController controller;
  final Axis scrollDirection;
  final bool scrollStopHide;

  /// 指示器背景长度
  final double? length;

  /// 指示器长度
  final double indicatorLength;

  final Decoration? indicator;
  final Decoration? indicatorBg;

  /// 线条粗细
  final double thickness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isVertical = scrollDirection == Axis.vertical;

    var bgColor = Colors.black.withOpacity(0.12);
    // bgColor = Colors.green.withOpacity(0.8);

    final indicatorBgNew = indicatorBg ??
        BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(thickness * 0.5),
        );

    final indicatorNew = indicator ??
        BoxDecoration(
          color: theme.tabBarTheme.indicatorColor ?? Colors.red,
          borderRadius: BorderRadius.circular(thickness * 0.5),
        );

    if (isVertical) {
      return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        final lengthNew = (length ?? constraints.maxHeight).truncateToDouble();

        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            child,
            Positioned(
              right: 0,
              child: Stack(
                children: [
                  Container(
                    width: thickness,
                    height: lengthNew,
                    decoration: indicatorBgNew,
                  ),
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, child) {
                      final position = controller.position;
                      if (!position.hasContentDimensions) {
                        return SizedBox();
                      }

                      if (scrollStopHide && !controller.position.isScrollingNotifier.value) {
                        return SizedBox();
                      }

                      final maxScroll = position.maxScrollExtent;
                      final offset = position.pixels;
                      final progress = (offset / maxScroll).clamp(0.0, 1.0);

                      return Positioned(
                        top: progress * (lengthNew - indicatorLength),
                        child: Container(
                          width: thickness,
                          height: indicatorLength,
                          decoration: indicatorNew,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      });
    }
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final lengthNew = length ?? constraints.maxWidth;

      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          child,
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                Container(
                  width: lengthNew,
                  height: thickness,
                  alignment: Alignment.center,
                  decoration: indicatorBgNew,
                ),
                ListenableBuilder(
                  listenable: controller,
                  builder: (context, child) {
                    final position = controller.position;
                    if (!position.hasContentDimensions) {
                      return SizedBox();
                    }

                    if (scrollStopHide && !controller.position.isScrollingNotifier.value) {
                      return SizedBox();
                    }

                    final maxScroll = position.maxScrollExtent;
                    final offset = position.pixels;
                    final progress = (offset / maxScroll).clamp(0.0, 1.0);
                    final left = progress * (lengthNew - indicatorLength);

                    // final desc = [
                    //   progress,
                    //   left + thickness,
                    //   lengthNew,
                    // ].map((e) => e.toStringAsFixed(1)).join("\n");
                    return Positioned(
                      left: left,
                      child: Container(
                        width: indicatorLength,
                        height: thickness,
                        decoration: indicatorNew,
                        // child: Text(desc.toString()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
