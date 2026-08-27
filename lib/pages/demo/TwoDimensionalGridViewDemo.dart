import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// 滚动物理
enum _PhysicsKind { platform, bouncing, clamping, never }

/// 二维视图
class TwoDimensionalGridViewDemo extends StatefulWidget {
  TwoDimensionalGridViewDemo({super.key, this.title});

  final String? title;

  @override
  State<TwoDimensionalGridViewDemo> createState() => _TwoDimensionalGridViewDemoState();
}

class _TwoDimensionalGridViewDemoState extends State<TwoDimensionalGridViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  DiagonalDragBehavior diagonalDragBehavior = DiagonalDragBehavior.free;
  Axis mainAxis = Axis.vertical;
  DragStartBehavior dragStartBehavior = DragStartBehavior.start;
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual;
  Clip clipBehavior = Clip.hardEdge;
  HitTestBehavior hitTestBehavior = HitTestBehavior.opaque;
  _PhysicsKind physicsKind = _PhysicsKind.platform;
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
  ChildVicinity? lastVicinity;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
    final scheme = Theme.of(context).colorScheme;
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
                              NLangEnum.en:
                                  'Tune item size, cacheExtent, clip, physics, reverse, and delegate indices.',
                              NLangEnum.zh: '可调节格子尺寸、cacheExtent、裁剪、滚动物理、反向与行列上限。',
                            },
                            {
                              NLangEnum.en: 'Tap a cell to see ChildVicinity; original checkerboard colors are kept.',
                              NLangEnum.zh: '点击格子查看 ChildVicinity；保留原 Demo 的棋盘配色。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildSizeCard(),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final vicinity = lastVicinity;
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
                physics: buildPhysics(),
              ),
              horizontalDetails: ScrollableDetails.horizontal(
                reverse: horizontalReverse,
                physics: buildPhysics(),
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
              vicinity == null
                  ? 'diagonalDragBehavior: ${diagonalDragBehavior.name}'
                  : 'onTap Row ${vicinity.yIndex}: Column ${vicinity.xIndex}',
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

  ScrollPhysics? buildPhysics() {
    switch (physicsKind) {
      case _PhysicsKind.platform:
        return null;
      case _PhysicsKind.bouncing:
        return const BouncingScrollPhysics();
      case _PhysicsKind.clamping:
        return const ClampingScrollPhysics();
      case _PhysicsKind.never:
        return const NeverScrollableScrollPhysics();
    }
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'mainAxis · primary · diagonalDragBehavior',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildField(
            label: 'mainAxis',
            child: buildChoiceChips(
              values: Axis.values,
              isSelected: (e) => mainAxis == e,
              labelOf: (e) => e.name,
              onChanged: onMainAxis,
            ),
          ),
          buildField(
            label: 'primary',
            showTopGap: true,
            child: buildChoiceChips(
              values: const [null, true, false],
              isSelected: (e) => primary == e,
              labelOf: (e) => e == null ? 'null' : '$e',
              onChanged: onPrimary,
            ),
          ),
          buildField(
            label: 'diagonalDragBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: DiagonalDragBehavior.values,
              isSelected: (e) => diagonalDragBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onDiagonalDragBehavior,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSizeCard() {
    return NDecorationCard(
      icon: const Icon(Icons.straighten_rounded),
      title: '尺寸',
      subtitle: 'itemWidth · itemHeight · cacheExtent · maxIndex',
      child: Column(
        children: [
          buildSlider(label: 'itemWidth', value: itemWidth, min: 60, max: 240, onChanged: onItemWidth),
          buildSlider(label: 'itemHeight', value: itemHeight, min: 32, max: 160, onChanged: onItemHeight),
          buildSlider(label: 'maxXIndex', value: maxXIndex.toDouble(), min: 0, max: 19, onChanged: onMaxXIndex),
          buildSlider(label: 'maxYIndex', value: maxYIndex.toDouble(), min: 0, max: 19, onChanged: onMaxYIndex),
          if (useCacheExtent)
            buildSlider(label: 'cacheExtent', value: cacheExtent, min: 0, max: 500, onChanged: onCacheExtent),
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
          buildField(
            label: 'physics',
            child: buildChoiceChips(
              values: _PhysicsKind.values,
              isSelected: (e) => physicsKind == e,
              labelOf: (e) => e.name,
              onChanged: onPhysicsKind,
            ),
          ),
          buildField(
            label: 'clipBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: const [Clip.none, Clip.hardEdge, Clip.antiAlias, Clip.antiAliasWithSaveLayer],
              isSelected: (e) => clipBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onClipBehavior,
            ),
          ),
          buildField(
            label: 'dragStartBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: DragStartBehavior.values,
              isSelected: (e) => dragStartBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onDragStartBehavior,
            ),
          ),
          buildField(
            label: 'keyboardDismissBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: ScrollViewKeyboardDismissBehavior.values,
              isSelected: (e) => keyboardDismissBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onKeyboardDismissBehavior,
            ),
          ),
          buildField(
            label: 'hitTestBehavior',
            showTopGap: true,
            child: buildChoiceChips(
              values: HitTestBehavior.values,
              isSelected: (e) => hitTestBehavior == e,
              labelOf: (e) => e.name,
              onChanged: onHitTestBehavior,
            ),
          ),
          buildSwitch(title: 'verticalDetails.reverse', value: verticalReverse, onChanged: onVerticalReverse),
          buildSwitch(title: 'horizontalDetails.reverse', value: horizontalReverse, onChanged: onHorizontalReverse),
          buildSwitch(title: 'cacheExtent 传入数值', value: useCacheExtent, onChanged: onUseCacheExtent),
          buildSwitch(title: 'addRepaintBoundaries', value: addRepaintBoundaries, onChanged: onAddRepaintBoundaries),
          buildSwitch(
            title: 'addAutomaticKeepAlives',
            value: addAutomaticKeepAlives,
            onChanged: onAddAutomaticKeepAlives,
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required String label,
    required Widget child,
    bool showTopGap = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopGap) const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              fontSize: 12.5,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget buildChoiceChips<T>({
    required List<T> values,
    required bool Function(T value) isSelected,
    required String Function(T value) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((e) {
        final selected = isSelected(e);
        return ChoiceChip(
          label: Text(labelOf(e)),
          selected: selected,
          showCheckmark: false,
          selectedColor: scheme.primaryContainer,
          labelStyle: TextStyle(
            color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'monospace',
            fontSize: 12.5,
          ),
          side: BorderSide(
            color: selected ? scheme.primary.withValues(alpha: 0.35) : scheme.outlineVariant.withValues(alpha: 0.65),
          ),
          onSelected: (on) {
            if (on) {
              onChanged(e);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return NSlider(
      leading: SizedBox(
        width: 108,
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurface,
            fontFamily: 'monospace',
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      min: min,
      max: max,
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
      inactiveColor: Colors.black12,
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
          fontSize: 13.5,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  void onMainAxis(Axis value) {
    mainAxis = value;
    setState(() {});
  }

  void onPrimary(bool? value) {
    primary = value;
    setState(() {});
  }

  void onDiagonalDragBehavior(DiagonalDragBehavior value) {
    diagonalDragBehavior = value;
    setState(() {});
  }

  void onItemWidth(double value) {
    itemWidth = value;
    setState(() {});
  }

  void onItemHeight(double value) {
    itemHeight = value;
    setState(() {});
  }

  void onMaxXIndex(double value) {
    maxXIndex = value.round().clamp(0, 19);
    setState(() {});
  }

  void onMaxYIndex(double value) {
    maxYIndex = value.round().clamp(0, 19);
    setState(() {});
  }

  void onCacheExtent(double value) {
    cacheExtent = value;
    setState(() {});
  }

  void onPhysicsKind(_PhysicsKind value) {
    physicsKind = value;
    setState(() {});
  }

  void onClipBehavior(Clip value) {
    clipBehavior = value;
    setState(() {});
  }

  void onDragStartBehavior(DragStartBehavior value) {
    dragStartBehavior = value;
    setState(() {});
  }

  void onKeyboardDismissBehavior(ScrollViewKeyboardDismissBehavior value) {
    keyboardDismissBehavior = value;
    setState(() {});
  }

  void onHitTestBehavior(HitTestBehavior value) {
    hitTestBehavior = value;
    setState(() {});
  }

  void onVerticalReverse(bool value) {
    verticalReverse = value;
    setState(() {});
  }

  void onHorizontalReverse(bool value) {
    horizontalReverse = value;
    setState(() {});
  }

  void onUseCacheExtent(bool value) {
    useCacheExtent = value;
    setState(() {});
  }

  void onAddRepaintBoundaries(bool value) {
    addRepaintBoundaries = value;
    setState(() {});
  }

  void onAddAutomaticKeepAlives(bool value) {
    addAutomaticKeepAlives = value;
    setState(() {});
  }

  void onCellTap(ChildVicinity vicinity) {
    lastVicinity = vicinity;
    setState(() {});
    DLog.d('onTap Row ${vicinity.yIndex}: Column ${vicinity.xIndex}');
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Row ${vicinity.yIndex}: Column ${vicinity.xIndex}'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void onReset() {
    diagonalDragBehavior = DiagonalDragBehavior.free;
    mainAxis = Axis.vertical;
    dragStartBehavior = DragStartBehavior.start;
    keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual;
    clipBehavior = Clip.hardEdge;
    hitTestBehavior = HitTestBehavior.opaque;
    physicsKind = _PhysicsKind.platform;
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
    lastVicinity = null;
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
