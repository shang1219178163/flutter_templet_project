import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';


/// 二维视图
class TwoDimensionalGridViewDemo extends StatefulWidget {
  TwoDimensionalGridViewDemo({super.key, this.title});

  final String? title;

  @override
  State<TwoDimensionalGridViewDemo> createState() => _TwoDimensionalGridViewDemoState();
}

class _TwoDimensionalGridViewDemoState extends State<TwoDimensionalGridViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  DiagonalDragBehavior diagonalDragBehavior = DiagonalDragBehavior.free;
  Axis mainAxis = Axis.vertical;
  DragStartBehavior dragStartBehavior = DragStartBehavior.start;
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual;
  Clip clipBehavior = Clip.hardEdge;
  HitTestBehavior hitTestBehavior = HitTestBehavior.opaque;
  PhysicsKind physicsKind = PhysicsKind.platform;
  bool? primary;
  bool verticalReverse = false;
  bool horizontalReverse = false;
  bool useCacheExtent = false;
  bool addRepaintBoundaries = true;
  bool addAutomaticKeepAlives = true;

  double itemWidth = 140;
  double itemHeight = 50;
  double cacheExtent = 250;
  int maxXIndex = 9;
  int maxYIndex = 9;
  String lastEvent = '—';

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
              actions: [
                TextButton(
                  onPressed: onReset,
                  child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final previewHeight = (constraints.maxHeight * 0.42).clamp(220.0, 380.0);
          return Column(
            children: [
              buildPreview(previewHeight),
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const NDescriptionCard(
                          initialLang: NLangEnum.zh,
                          title: {
                            NLangEnum.en: 'Description',
                            NLangEnum.zh: '说明',
                          },
                          subtitle: {
                            NLangEnum.en: 'Widget TwoDimensionalGridView',
                            NLangEnum.zh: '组件 TwoDimensionalGridView',
                          },
                          items: [
                            {
                              NLangEnum.en: 'A two-axis GridView. Drag diagonally according to DiagonalDragBehavior.',
                              NLangEnum.zh: '二维 GridView，可按 DiagonalDragBehavior 斜向拖动。',
                            },
                            {
                              NLangEnum.en: 'Tap a cell to see ChildVicinity; original checkerboard colors are kept.',
                              NLangEnum.zh: '点击格子查看 ChildVicinity；保留原 Demo 的棋盘配色。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildBehaviorCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPreview(double height) {
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height,
            width: double.infinity,
            child: TwoDimensionalGridView(
              key: ValueKey('$mainAxis-$verticalReverse-$horizontalReverse-$primary'),
              primary: primary,
              mainAxis: mainAxis,
              itemWidth: itemWidth,
              itemHeight: itemHeight,
              cacheExtent: useCacheExtent ? cacheExtent : null,
              diagonalDragBehavior: diagonalDragBehavior,
              dragStartBehavior: dragStartBehavior,
              keyboardDismissBehavior: keyboardDismissBehavior,
              clipBehavior: clipBehavior,
              hitTestBehavior: hitTestBehavior,
              verticalDetails: ScrollableDetails.vertical(
                reverse: verticalReverse,
                physics: physicsKind.physics,
              ),
              horizontalDetails: ScrollableDetails.horizontal(
                reverse: horizontalReverse,
                physics: physicsKind.physics,
              ),
              delegate: TwoDimensionalChildBuilderDelegate(
                maxXIndex: maxXIndex,
                maxYIndex: maxYIndex,
                addRepaintBoundaries: addRepaintBoundaries,
                addAutomaticKeepAlives: addAutomaticKeepAlives,
                builder: (context, vicinity) {
                  return buildCell(vicinity);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              lastEvent,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCell(ChildVicinity vicinity) {
    final xyEven = vicinity.xIndex.isEven && vicinity.yIndex.isEven;
    final xyOdd = vicinity.xIndex.isOdd && vicinity.yIndex.isOdd;
    final color = xyEven ? Colors.amber[50] : (xyOdd ? Colors.purple[50] : null);
    return GestureDetector(
      onTap: () => onCellTap(vicinity),
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
          child: Text('Row ${vicinity.yIndex}: Column ${vicinity.xIndex}'),
        ),
      ),
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'mainAxis · primary · diagonalDragBehavior · itemSize · maxIndex',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<Axis>(
            title: const Text('mainAxis'),
            values: Axis.values,
            value: mainAxis,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('mainAxis ${e.name}', () => mainAxis = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<bool?>(
            title: const Text('primary'),
            values: const [null, true, false],
            value: primary,
            labelOf: (e) => e == null ? 'null' : '$e',
            onChanged: (e) => onMark('primary $e', () => primary = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<DiagonalDragBehavior>(
            title: const Text('diagonalDragBehavior'),
            values: DiagonalDragBehavior.values,
            value: diagonalDragBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('diagonalDragBehavior ${e.name}', () => diagonalDragBehavior = e),
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('itemWidth'),
            min: 60,
            max: 240,
            value: itemWidth.clamp(60, 240),
            onChanged: (v) => onMark('itemWidth ${v.round()}', () => itemWidth = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('itemHeight'),
            min: 32,
            max: 160,
            value: itemHeight.clamp(32, 160),
            onChanged: (v) => onMark('itemHeight ${v.round()}', () => itemHeight = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('maxXIndex'),
            min: 0,
            max: 19,
            value: maxXIndex.toDouble().clamp(0, 19),
            onChanged: (v) => onMark('maxXIndex ${v.round()}', () => maxXIndex = v.round().clamp(0, 19)),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('maxYIndex'),
            min: 0,
            max: 19,
            value: maxYIndex.toDouble().clamp(0, 19),
            onChanged: (v) => onMark('maxYIndex ${v.round()}', () => maxYIndex = v.round().clamp(0, 19)),
            activeColor: theme.colorScheme.primary,
          ),
          if (useCacheExtent)
            NSliderListItem(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('cacheExtent'),
              min: 0,
              max: 500,
              value: cacheExtent.clamp(0, 500),
              onChanged: (v) => onMark('cacheExtent ${v.round()}', () => cacheExtent = v),
              activeColor: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget buildBehaviorCard() {
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '行为',
      subtitle: 'physics · reverse · clip · drag · keyboard · hitTest',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem<PhysicsKind>(
            title: const Text('physics'),
            values: PhysicsKind.values,
            value: physicsKind,
            labelOf: (e) => e.label,
            onChanged: (e) => onMark('physics ${e.label}', () => physicsKind = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<Clip>(
            title: const Text('clipBehavior'),
            values: const [Clip.none, Clip.hardEdge, Clip.antiAlias, Clip.antiAliasWithSaveLayer],
            value: clipBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('clipBehavior ${e.name}', () => clipBehavior = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<DragStartBehavior>(
            title: const Text('dragStartBehavior'),
            values: DragStartBehavior.values,
            value: dragStartBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('dragStartBehavior ${e.name}', () => dragStartBehavior = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<ScrollViewKeyboardDismissBehavior>(
            title: const Text('keyboardDismissBehavior'),
            values: ScrollViewKeyboardDismissBehavior.values,
            value: keyboardDismissBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('keyboardDismissBehavior ${e.name}', () => keyboardDismissBehavior = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem<HitTestBehavior>(
            title: const Text('hitTestBehavior'),
            values: HitTestBehavior.values,
            value: hitTestBehavior,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('hitTestBehavior ${e.name}', () => hitTestBehavior = e),
          ),
          NSwitchListItem(
            title: const Text('verticalDetails.reverse'),
            value: verticalReverse,
            onChanged: (v) => onMark('verticalReverse $v', () => verticalReverse = v),
          ),
          NSwitchListItem(
            title: const Text('horizontalDetails.reverse'),
            value: horizontalReverse,
            onChanged: (v) => onMark('horizontalReverse $v', () => horizontalReverse = v),
          ),
          NSwitchListItem(
            title: const Text('cacheExtent 传入数值'),
            value: useCacheExtent,
            onChanged: (v) => onMark('useCacheExtent $v', () => useCacheExtent = v),
          ),
          NSwitchListItem(
            title: const Text('addRepaintBoundaries'),
            value: addRepaintBoundaries,
            onChanged: (v) => onMark('addRepaintBoundaries $v', () => addRepaintBoundaries = v),
          ),
          NSwitchListItem(
            title: const Text('addAutomaticKeepAlives'),
            value: addAutomaticKeepAlives,
            onChanged: (v) => onMark('addAutomaticKeepAlives $v', () => addAutomaticKeepAlives = v),
          ),
        ],
      ),
    );
  }


  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onCellTap(ChildVicinity vicinity) {
    onMark('onTap Row ${vicinity.yIndex}: Column ${vicinity.xIndex}');
    SnackUtil.show('Row ${vicinity.yIndex}: Column ${vicinity.xIndex}');
  }

  void onReset() {
    diagonalDragBehavior = DiagonalDragBehavior.free;
    mainAxis = Axis.vertical;
    dragStartBehavior = DragStartBehavior.start;
    keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual;
    clipBehavior = Clip.hardEdge;
    hitTestBehavior = HitTestBehavior.opaque;
    physicsKind = PhysicsKind.platform;
    primary = null;
    verticalReverse = false;
    horizontalReverse = false;
    useCacheExtent = false;
    addRepaintBoundaries = true;
    addAutomaticKeepAlives = true;
    itemWidth = 140;
    itemHeight = 50;
    cacheExtent = 250;
    maxXIndex = 9;
    maxYIndex = 9;
    lastEvent = '—';
    setState(() {});
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
    required this.itemWidth,
    required this.itemHeight,
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
    super.hitTestBehavior = HitTestBehavior.opaque,
  }) : super(delegate: delegate);

  final double itemWidth;
  final double itemHeight;

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
      itemWidth: itemWidth,
      itemHeight: itemHeight,
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
    required this.itemWidth,
    required this.itemHeight,
  });

  final double itemWidth;
  final double itemHeight;

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
      itemWidth: itemWidth,
      itemHeight: itemHeight,
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
      ..clipBehavior = clipBehavior
      ..itemWidth = itemWidth
      ..itemHeight = itemHeight;
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
    required double itemWidth,
    required double itemHeight,
  })  : _itemWidth = itemWidth,
        _itemHeight = itemHeight,
        super(delegate: delegate);

  double _itemWidth;
  double get itemWidth => _itemWidth;
  set itemWidth(double value) {
    if (_itemWidth == value) {
      return;
    }
    _itemWidth = value;
    markNeedsLayout(); // 👈 关键
  }

  double _itemHeight;
  double get itemHeight => _itemHeight;
  set itemHeight(double value) {
    if (_itemHeight == value) {
      return;
    }
    _itemHeight = value;
    markNeedsLayout();
  }

  @override
  void layoutChildSequence() {
    final horizontalPixels = horizontalOffset.pixels;
    final verticalPixels = verticalOffset.pixels;
    final viewportWidth = viewportDimension.width + cacheExtent;
    final viewportHeight = viewportDimension.height + cacheExtent;
    final builderDelegate = delegate as TwoDimensionalChildBuilderDelegate;

    final maxRowIndex = builderDelegate.maxYIndex!;
    final maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn = math.max((horizontalPixels / itemWidth).floor(), 0);
    final int leadingRow = math.max((verticalPixels / itemHeight).floor(), 0);
    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / itemWidth).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / itemHeight).ceil(),
      maxRowIndex,
    );

    var xLayoutOffset = (leadingColumn * itemWidth) - horizontalOffset.pixels;
    for (var column = leadingColumn; column <= trailingColumn; column++) {
      var yLayoutOffset = (leadingRow * itemHeight) - verticalOffset.pixels;
      for (var row = leadingRow; row <= trailingRow; row++) {
        final vicinity = ChildVicinity(xIndex: column, yIndex: row);
        final child = buildOrObtainChildFor(vicinity)!;
        //  核心：约束尺寸
        // child.layout(constraints.loosen());
        child.layout(
          BoxConstraints.tightFor(width: itemWidth, height: itemHeight),
        );

        // Subclasses only need to set the normalized layout offset. The super
        // class adjusts for reversed axes.
        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += itemHeight;
      }
      xLayoutOffset += itemWidth;
    }

    // Set the min and max scroll extents for each axis.
    final verticalExtent = itemHeight * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0.0,
      clampDouble(verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );
    final horizontalExtent = itemWidth * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0.0,
      clampDouble(horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
    // Super class handles garbage collection too!
  }
}
