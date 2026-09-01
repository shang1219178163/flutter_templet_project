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
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';

/// CarouselView 构造方式
enum _CarouselKind {
  uncontained(label: 'CarouselView'),
  weighted(label: 'CarouselView.weighted');
  const _CarouselKind({required this.label});
  final String label;
}

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

  late final theme = Theme.of(context);

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
  int currentIndex = 0;
  String lastEvent = '—';

  Color? backgroundColor;
  Color? overlayColor;
  ShapeKind shapeKind = ShapeKind.rounded;
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

  @override
  void initState() {
    super.initState();
    carouselController.addListener(onCarouselScroll);
  }

  @override
  void dispose() {
    carouselController.removeListener(onCarouselScroll);
    carouselController.dispose();
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
              title: Text("$widget"),
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
      child: Column(
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
                    const NDescriptionCard(
                      initialLang: NLangEnum.zh,
                      title: {
                        NLangEnum.en: 'Description',
                        NLangEnum.zh: '说明',
                      },
                      subtitle: {
                        NLangEnum.en: 'Widget CarouselView',
                        NLangEnum.zh: '组件 CarouselView',
                      },
                      items: [
                        {
                          NLangEnum.en: 'Pin a live preview while you tune every constructor argument below.',
                          NLangEnum.zh: '上方固定预览，下方调节全部构造参数并即时生效。',
                        },
                        {
                          NLangEnum.en: 'Switch between CarouselView and CarouselView.weighted, including flexWeights.',
                          NLangEnum.zh: '可切换 CarouselView 与 CarouselView.weighted，并配置 flexWeights。',
                        },
                      ],
                    ),
                    buildConstructCard(),
                    buildSurfaceCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPreview() {
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
            height: viewportExtent,
            width: double.infinity,
            child: buildCarousel(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'item: $currentIndex · $lastEvent',
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

  Widget buildCarousel() {
    final shape = shapeKind.shape(roundedRadius: borderRadius)!;
    if (kind == _CarouselKind.weighted) {
      return CarouselView.weighted(
        key: ValueKey('weighted-$scrollDirection-$reverse-$initialItem'),
        controller: carouselController,
        flexWeights: flexWeights,
        consumeMaxWeight: consumeMaxWeight,
        padding: EdgeInsets.all(padding),
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        overlayColor: buildOverlayColor(),
        itemSnapping: itemSnapping,
        shrinkExtent: shrinkExtent,
        scrollDirection: scrollDirection,
        reverse: reverse,
        enableSplash: enableSplash,
        onTap: onItemTap,
        children: buildItems(),
      );
    }
    return CarouselView(
      key: ValueKey('uncontained-$scrollDirection-$reverse-$initialItem'),
      controller: carouselController,
      itemExtent: itemExtent,
      padding: EdgeInsets.all(padding),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      overlayColor: buildOverlayColor(),
      itemSnapping: itemSnapping,
      shrinkExtent: shrinkExtent,
      scrollDirection: scrollDirection,
      reverse: reverse,
      enableSplash: enableSplash,
      onTap: onItemTap,
      children: buildItems(),
    );
  }

  List<Widget> buildItems() {
    return List<Widget>.generate(itemCount, (index) {
      return ColoredBox(
        color: Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.5),
        child: Center(
          child: Text(
            'Item $index',
            style: const TextStyle(color: Colors.white, fontSize: 20),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      );
    });
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

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造与尺寸',
      subtitle: 'constructor · itemExtent · shrinkExtent · initialItem',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem(
            title: const Text('构造方式'),
            values: _CarouselKind.values,
            value: kind,
            labelOf: (e) => e.label,
            onChanged: onKind,
          ),
          if (kind == _CarouselKind.weighted) ...[
            const SizedBox(height: 8),
            NChoiceChipListItem(
              title: const Text('flexWeights'),
              values: flexWeightPresets,
              onEqual: (e) => listEquals(flexWeights, e),
              labelOf: (e) => '$e',
              onChanged: (e) => onMark('flexWeights $e', () => flexWeights = e),
            ),
          ],
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('scrollDirection'),
            values: Axis.values,
            value: scrollDirection,
            labelOf: (e) => e.name,
            onChanged: onScrollDirection,
          ),
          if (kind == _CarouselKind.uncontained)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('itemExtent'),
              min: 80,
              max: 400,
              value: itemExtent.clamp(80, 400),
              onChanged: (v) => onMark('itemExtent ${v.round()}', () => itemExtent = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('shrinkExtent'),
            min: 0,
            max: 200,
            value: shrinkExtent.clamp(0, 200),
            onChanged: (v) => onMark('shrinkExtent ${v.round()}', () => shrinkExtent = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('padding'),
            min: 0,
            max: 24,
            value: padding.clamp(0, 24),
            onChanged: (v) => onMark('padding ${v.round()}', () => padding = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('viewport 高度'),
            min: 120,
            max: 480,
            value: viewportExtent.clamp(120, 480),
            onChanged: (v) => onMark('viewport ${v.round()}', () => viewportExtent = v),
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('itemCount'),
            min: 3,
            max: 20,
            value: itemCount.toDouble().clamp(3, 20),
            onChanged: onItemCount,
            activeColor: theme.colorScheme.primary,
          ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('initialItem'),
            min: 0,
            max: math.max(itemCount - 1, 1).toDouble(),
            value: initialItem.toDouble().clamp(0, math.max(itemCount - 1, 1).toDouble()),
            onChanged: onInitialItem,
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget buildSurfaceCard() {
    return NDecorationCard(
      icon: const Icon(Icons.palette_outlined),
      title: '表面与行为',
      subtitle: 'shape · backgroundColor · itemSnapping · reverse',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem(
            title: const Text('shape'),
            values: const [ShapeKind.rounded, ShapeKind.stadium],
            value: shapeKind,
            labelOf: (e) => e == ShapeKind.rounded ? 'RoundedRectangleBorder' : 'StadiumBorder',
            onChanged: (e) => onMark('shape ${e.name}', () => shapeKind = e),
          ),
          if (shapeKind == ShapeKind.rounded)
            NSliderListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('borderRadius'),
              min: 0,
              max: 48,
              value: borderRadius.clamp(0, 48),
              onChanged: (v) => onMark('borderRadius ${v.round()}', () => borderRadius = v),
              activeColor: theme.colorScheme.primary,
            ),
          NSliderListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('elevation'),
            min: 0,
            max: 16,
            value: elevation.clamp(0, 16),
            onChanged: (v) => onMark('elevation ${v.round()}', () => elevation = v),
            activeColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('backgroundColor'),
            value: backgroundColor,
            onChanged: (e) => onMark('backgroundColor $e', () => backgroundColor = e),
          ),
          const SizedBox(height: 8),
          NChoiceColorListItem(
            title: const Text('overlayColor'),
            value: overlayColor,
            onChanged: (e) => onMark('overlayColor $e', () => overlayColor = e),
          ),
          NSwitchListTile(
            title: const Text('itemSnapping 吸附'),
            value: itemSnapping,
            onChanged: (v) => onMark('itemSnapping $v', () => itemSnapping = v),
          ),
          NSwitchListTile(title: const Text('reverse 反向滚动'), value: reverse, onChanged: onReverse),
          NSwitchListTile(
            title: const Text('enableSplash 水波纹'),
            value: enableSplash,
            onChanged: (v) => onMark('enableSplash $v', () => enableSplash = v),
          ),
          if (kind == _CarouselKind.weighted)
            NSwitchListTile(
              title: const Text('consumeMaxWeight 可撑满最大权重'),
              value: consumeMaxWeight,
              onChanged: (v) => onMark('consumeMaxWeight $v', () => consumeMaxWeight = v),
            ),
        ],
      ),
    );
  }


  void onResetCarouselController() {
    carouselController.removeListener(onCarouselScroll);
    carouselController.dispose();
    carouselController = CarouselController(initialItem: initialItem);
    currentIndex = initialItem;
    carouselController.addListener(onCarouselScroll);
  }

  int currentItemIndex() {
    if (!carouselController.hasClients) {
      return currentIndex;
    }
    final viewport = carouselController.position.viewportDimension;
    if (viewport <= 0) {
      return currentIndex;
    }
    final fraction = kind == _CarouselKind.weighted
        ? flexWeights.first / flexWeights.reduce((a, b) => a + b)
        : itemExtent / viewport;
    if (fraction <= 0) {
      return currentIndex;
    }
    final actual = math.max(0.0, carouselController.offset) / (viewport * fraction);
    return actual.round().clamp(0, math.max(itemCount - 1, 0));
  }

  void onCarouselScroll() {
    if (!mounted || !carouselController.hasClients) {
      return;
    }
    final next = currentItemIndex();
    if (next == currentIndex) {
      return;
    }
    currentIndex = next;
    setState(() {});
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
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
    shapeKind = ShapeKind.rounded;
    flexWeights = const [1, 7, 1];
    lastEvent = '—';
    onResetCarouselController();
    setState(() {});
  }

  void onKind(_CarouselKind value) {
    onMark('kind ${value.name}', () {
      kind = value;
      onResetCarouselController();
    });
  }

  void onScrollDirection(Axis value) {
    onMark('scrollDirection ${value.name}', () {
      scrollDirection = value;
      if (value == Axis.vertical && viewportExtent < 320) {
        viewportExtent = 360;
      }
      onResetCarouselController();
    });
  }

  void onItemCount(double value) {
    onMark('itemCount ${value.round()}', () {
      itemCount = value.round().clamp(3, 20);
      if (initialItem >= itemCount) {
        initialItem = itemCount - 1;
        onResetCarouselController();
      }
    });
  }

  void onInitialItem(double value) {
    onMark('initialItem ${value.round()}', () {
      initialItem = value.round().clamp(0, itemCount - 1);
      onResetCarouselController();
    });
  }

  void onReverse(bool value) {
    onMark('reverse $value', () {
      reverse = value;
      onResetCarouselController();
    });
  }

  void onItemTap(int index) {
    currentIndex = index;
    lastEvent = 'onTap $index';
    setState(() {});
    DLog.d('CarouselView onTap: $index');
    SnackUtil.show('onTap Item $index');
  }
}
