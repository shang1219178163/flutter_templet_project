import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';

/// 二维视图
class TwoDimensionalGridViewDemo extends StatefulWidget {
  TwoDimensionalGridViewDemo({super.key, this.title});

  final String? title;

  @override
  State<TwoDimensionalGridViewDemo> createState() =>
      _TwoDimensionalGridViewDemoState();
}

class _TwoDimensionalGridViewDemoState
    extends State<TwoDimensionalGridViewDemo> {
  var diagonalDragBehavior = DiagonalDragBehavior.free;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NMenuAnchor(
          values: DiagonalDragBehavior.values,
          initialItem: diagonalDragBehavior,
          onChanged: (val) {
            diagonalDragBehavior = val;
            setState(() {});
          },
          cbName: (e) => "DiagonalDragBehavior.${e?.name}",
          equal: (a, b) => a == b,
        ),
        Expanded(
          child: TwoDimensionalGridView(
            diagonalDragBehavior: diagonalDragBehavior,
            delegate: TwoDimensionalChildBuilderDelegate(
              maxXIndex: 9,
              maxYIndex: 9,
              builder: (BuildContext context, ChildVicinity vicinity) {
                final xyEven = vicinity.xIndex.isEven && vicinity.yIndex.isEven;
                final xyOdd = vicinity.xIndex.isOdd && vicinity.yIndex.isOdd;

                return Container(
                  width: 200,
                  height: 200,
                  color: xyEven
                      ? Colors.amber[50]
                      : (xyOdd ? Colors.purple[50] : null),
                  child: Center(
                    child: Text(
                        'Row ${vicinity.yIndex}: Column ${vicinity.xIndex}'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// 二维 GridView
class TwoDimensionalGridView extends TwoDimensionalScrollView {
  const TwoDimensionalGridView({
    super.key,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails = const ScrollableDetails.vertical(),
    super.horizontalDetails = const ScrollableDetails.horizontal(),
    required TwoDimensionalChildBuilderDelegate delegate,
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return TwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }
}

class TwoDimensionalGridViewport extends TwoDimensionalViewport {
  const TwoDimensionalGridViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  });

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderTwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      childManager: context as TwoDimensionalChildManager,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTwoDimensionalGridViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

class RenderTwoDimensionalGridViewport extends RenderTwoDimensionalViewport {
  RenderTwoDimensionalGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  void layoutChildSequence() {
    final horizontalPixels = horizontalOffset.pixels;
    final verticalPixels = verticalOffset.pixels;
    final viewportWidth = viewportDimension.width + cacheExtent;
    final viewportHeight = viewportDimension.height + cacheExtent;
    final builderDelegate =
        delegate as TwoDimensionalChildBuilderDelegate;

    final maxRowIndex = builderDelegate.maxYIndex!;
    final maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn = math.max((horizontalPixels / 200).floor(), 0);
    final int leadingRow = math.max((verticalPixels / 200).floor(), 0);
    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / 200).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / 200).ceil(),
      maxRowIndex,
    );

    var xLayoutOffset = (leadingColumn * 200) - horizontalOffset.pixels;
    for (var column = leadingColumn; column <= trailingColumn; column++) {
      var yLayoutOffset = (leadingRow * 200) - verticalOffset.pixels;
      for (var row = leadingRow; row <= trailingRow; row++) {
        final vicinity =
            ChildVicinity(xIndex: column, yIndex: row);
        final child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        // Subclasses only need to set the normalized layout offset. The super
        // class adjusts for reversed axes.
        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += 200;
      }
      xLayoutOffset += 200;
    }

    // Set the min and max scroll extents for each axis.
    final verticalExtent = 200 * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );
    final horizontalExtent = 200 * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
    // Super class handles garbage collection too!
  }
}
