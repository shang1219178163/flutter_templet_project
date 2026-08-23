//
//  CarouselViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/20 11:13.
//  Copyright © 2025/3/20 shang. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:get/get.dart';

/// CarouselView 构造方式
enum _CarouselKind { uncontained, weighted }

/// 卡片外形
enum _ShapeKind { rounded, stadium }

class CarouselViewDemo extends StatefulWidget {
  const CarouselViewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CarouselViewDemo> createState() => _CarouselViewDemoState();
}

class _CarouselViewDemoState extends State<CarouselViewDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  late CarouselController carouselController = CarouselController(initialItem: initialItem);

  _CarouselKind kind = _CarouselKind.uncontained;
  Axis scrollDirection = Axis.horizontal;
  bool reverse = false;
  bool itemSnapping = true;
  bool enableSplash = true;
  bool consumeMaxWeight = true;

  double viewportExtent = 200;
  double itemExtent = 300;
  double shrinkExtent = 50;
  double padding = 4;
  double elevation = 0;
  double borderRadius = 28;
  int itemCount = 12;
  int initialItem = 0;

  Color? backgroundColor;
  Color? overlayColor;
  _ShapeKind shapeKind = _ShapeKind.rounded;
  List<int> flexWeights = const [1, 7, 1];

  final flexWeightPresets = const <List<int>>[
    [1],
    [1, 1],
    [7, 1],
    [1, 7, 1],
    [1, 2, 1],
    [3, 2, 1],
    [1, 7, 1, 1],
    [1, 2, 3, 2, 1],
  ];

  final colorOptions = <Color?>[
    null,
    Colors.white,
    Colors.blue.shade100,
    Colors.teal,
    Colors.orange,
    Colors.deepPurple,
    Colors.blueGrey,
  ];

  @override
  void dispose() {
    carouselController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                TextButton(
                  onPressed: onReset,
                  child: const Text('重置', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildPreview(),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  buildKindSection(),
                  if (kind == _CarouselKind.weighted) buildFlexWeightsSection(),
                  buildAxisSection(),
                  buildShapeSection(),
                  buildColorSection(title: 'backgroundColor 背景色', value: backgroundColor, onChanged: onBackgroundColor),
                  buildColorSection(title: 'overlayColor 水波纹', value: overlayColor, onChanged: onOverlayColor),
                  if (kind == _CarouselKind.uncontained)
                    buildSlider(label: 'itemExtent', value: itemExtent, min: 80, max: 400, onChanged: onItemExtent),
                  buildSlider(label: 'shrinkExtent', value: shrinkExtent, min: 0, max: 200, onChanged: onShrinkExtent),
                  buildSlider(label: 'padding', value: padding, min: 0, max: 24, onChanged: onPadding),
                  buildSlider(label: 'elevation', value: elevation, min: 0, max: 16, onChanged: onElevation),
                  if (shapeKind == _ShapeKind.rounded)
                    buildSlider(label: 'borderRadius', value: borderRadius, min: 0, max: 48, onChanged: onBorderRadius),
                  buildSlider(
                      label: 'viewport 高度', value: viewportExtent, min: 120, max: 480, onChanged: onViewportExtent),
                  buildSlider(
                    label: 'itemCount',
                    value: itemCount.toDouble(),
                    min: 3,
                    max: 20,
                    onChanged: onItemCount,
                  ),
                  buildSlider(
                    label: 'initialItem',
                    value: initialItem.toDouble(),
                    min: 0,
                    max: math.max(itemCount - 1, 1).toDouble(),
                    onChanged: onInitialItem,
                  ),
                  buildSwitch(title: 'itemSnapping 吸附', value: itemSnapping, onChanged: onItemSnapping),
                  buildSwitch(title: 'reverse 反向滚动', value: reverse, onChanged: onReverse),
                  buildSwitch(title: 'enableSplash 水波纹', value: enableSplash, onChanged: onEnableSplash),
                  if (kind == _CarouselKind.weighted)
                    buildSwitch(
                        title: 'consumeMaxWeight 可撑满最大权重', value: consumeMaxWeight, onChanged: onConsumeMaxWeight),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPreview() {
    return Container(
      height: viewportExtent,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        border: Border(bottom: BorderSide(color: Colors.blue.withValues(alpha: 0.25))),
      ),
      child: kind == _CarouselKind.weighted
          ? CarouselView.weighted(
              key: ValueKey('weighted-$scrollDirection-$reverse-$initialItem'),
              controller: carouselController,
              flexWeights: flexWeights,
              consumeMaxWeight: consumeMaxWeight,
              padding: EdgeInsets.all(padding),
              backgroundColor: backgroundColor,
              elevation: elevation,
              shape: buildShape(),
              overlayColor: buildOverlayColor(),
              itemSnapping: itemSnapping,
              shrinkExtent: shrinkExtent,
              scrollDirection: scrollDirection,
              reverse: reverse,
              enableSplash: enableSplash,
              onTap: onItemTap,
              children: buildItems(),
            )
          : CarouselView(
              key: ValueKey('uncontained-$scrollDirection-$reverse-$initialItem'),
              controller: carouselController,
              itemExtent: itemExtent,
              padding: EdgeInsets.all(padding),
              backgroundColor: backgroundColor,
              elevation: elevation,
              shape: buildShape(),
              overlayColor: buildOverlayColor(),
              itemSnapping: itemSnapping,
              shrinkExtent: shrinkExtent,
              scrollDirection: scrollDirection,
              reverse: reverse,
              enableSplash: enableSplash,
              onTap: onItemTap,
              children: buildItems(),
            ),
    );
  }

  List<Widget> buildItems() {
    return List<Widget>.generate(itemCount, (index) {
      return UncontainedLayoutCard(index: index, label: 'Item $index');
    });
  }

  ShapeBorder buildShape() {
    if (shapeKind == _ShapeKind.stadium) {
      return const StadiumBorder();
    }
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));
  }

  WidgetStateProperty<Color?>? buildOverlayColor() {
    final color = overlayColor;
    if (color == null) {
      return null;
    }
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return color.withValues(alpha: 0.24);
      }
      if (states.contains(WidgetState.hovered)) {
        return color.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.focused)) {
        return color.withValues(alpha: 0.16);
      }
      return color.withValues(alpha: 0.08);
    });
  }

  Widget buildKindSection() {
    return NSectionBox(
      title: '构造方式',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _CarouselKind.values.map((e) {
          return ChoiceChip(
            label: Text(e == _CarouselKind.uncontained ? 'CarouselView' : 'CarouselView.weighted'),
            selected: kind == e,
            onSelected: (selected) {
              if (selected) {
                onKind(e);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildFlexWeightsSection() {
    return NSectionBox(
      title: 'flexWeights 可见项权重',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: flexWeightPresets.map((e) {
          return ChoiceChip(
            label: Text('$e'),
            selected: listEquals(flexWeights, e),
            onSelected: (selected) {
              if (selected) {
                onFlexWeights(e);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildAxisSection() {
    return NSectionBox(
      title: 'scrollDirection 滚动方向',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: Axis.values.map((e) {
          return ChoiceChip(
            label: Text(e.name),
            selected: scrollDirection == e,
            onSelected: (selected) {
              if (selected) {
                onScrollDirection(e);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildShapeSection() {
    return NSectionBox(
      title: 'shape 外形',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _ShapeKind.values.map((e) {
          return ChoiceChip(
            label: Text(e == _ShapeKind.rounded ? 'RoundedRectangleBorder' : 'StadiumBorder'),
            selected: shapeKind == e,
            onSelected: (selected) {
              if (selected) {
                onShapeKind(e);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildColorSection({
    required String title,
    required Color? value,
    required ValueChanged<Color?> onChanged,
  }) {
    return NSectionBox(
      title: title,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: colorOptions.map((e) {
          final selected = value == e;
          return GestureDetector(
            onTap: () => onChanged(e),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: e ?? Colors.transparent,
                border: Border.all(color: selected ? Colors.blue : Colors.grey, width: selected ? 2 : 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: e == null ? const Text('默', style: TextStyle(fontSize: 10)) : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: NSlider(
        leading: SizedBox(width: 108, child: Text(label)),
        min: min,
        max: max,
        value: value,
        onChanged: onChanged,
        inactiveColor: Colors.black12,
      ),
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      dense: true,
      title: Text(title),
      value: value,
      onChanged: onChanged,
      inactiveTrackColor: Colors.black12,
    );
  }

  void onResetCarouselController() {
    carouselController.dispose();
    carouselController = CarouselController(initialItem: initialItem);
  }

  void onReset() {
    kind = _CarouselKind.uncontained;
    scrollDirection = Axis.horizontal;
    reverse = false;
    itemSnapping = true;
    enableSplash = true;
    consumeMaxWeight = true;
    viewportExtent = 200;
    itemExtent = 300;
    shrinkExtent = 50;
    padding = 4;
    elevation = 0;
    borderRadius = 28;
    itemCount = 12;
    initialItem = 0;
    backgroundColor = null;
    overlayColor = null;
    shapeKind = _ShapeKind.rounded;
    flexWeights = const [1, 7, 1];
    onResetCarouselController();
    setState(() {});
  }

  void onKind(_CarouselKind value) {
    kind = value;
    onResetCarouselController();
    setState(() {});
  }

  void onFlexWeights(List<int> value) {
    flexWeights = value;
    setState(() {});
  }

  void onScrollDirection(Axis value) {
    scrollDirection = value;
    if (value == Axis.vertical && viewportExtent < 320) {
      viewportExtent = 360;
    }
    onResetCarouselController();
    setState(() {});
  }

  void onShapeKind(_ShapeKind value) {
    shapeKind = value;
    setState(() {});
  }

  void onBackgroundColor(Color? value) {
    backgroundColor = value;
    setState(() {});
  }

  void onOverlayColor(Color? value) {
    overlayColor = value;
    setState(() {});
  }

  void onItemExtent(double value) {
    itemExtent = value;
    setState(() {});
  }

  void onShrinkExtent(double value) {
    shrinkExtent = value;
    setState(() {});
  }

  void onPadding(double value) {
    padding = value;
    setState(() {});
  }

  void onElevation(double value) {
    elevation = value;
    setState(() {});
  }

  void onBorderRadius(double value) {
    borderRadius = value;
    setState(() {});
  }

  void onViewportExtent(double value) {
    viewportExtent = value;
    setState(() {});
  }

  void onItemCount(double value) {
    itemCount = value.round().clamp(3, 20);
    if (initialItem >= itemCount) {
      initialItem = itemCount - 1;
      onResetCarouselController();
    }
    setState(() {});
  }

  void onInitialItem(double value) {
    initialItem = value.round().clamp(0, itemCount - 1);
    onResetCarouselController();
    setState(() {});
  }

  void onItemSnapping(bool value) {
    itemSnapping = value;
    setState(() {});
  }

  void onReverse(bool value) {
    reverse = value;
    onResetCarouselController();
    setState(() {});
  }

  void onEnableSplash(bool value) {
    enableSplash = value;
    setState(() {});
  }

  void onConsumeMaxWeight(bool value) {
    consumeMaxWeight = value;
    setState(() {});
  }

  void onItemTap(int index) {
    DLog.d('CarouselView onTap: $index');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('onTap Item $index'), duration: const Duration(milliseconds: 800)),
    );
  }
}

class UncontainedLayoutCard extends StatelessWidget {
  const UncontainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
  });

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.5),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
      ),
    );
  }
}
