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
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// CarouselView 构造方式
enum _CarouselKind { uncontained, weighted }

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
    if (kind == _CarouselKind.weighted) {
      return CarouselView.weighted(
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
      );
    }
    return CarouselView(
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

  ShapeBorder buildShape() {
    return switch (shapeKind) {
      ShapeKind.stadium => const StadiumBorder(),
      ShapeKind.none || ShapeKind.rounded => RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
    };
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
          buildField(
            label: '构造方式',
            child: buildChoiceChips(
              values: _CarouselKind.values,
              isSelected: (e) => kind == e,
              labelOf: (e) => e == _CarouselKind.uncontained ? 'CarouselView' : 'CarouselView.weighted',
              onChanged: onKind,
            ),
          ),
          if (kind == _CarouselKind.weighted)
            buildField(
              label: 'flexWeights',
              showTopGap: true,
              child: buildChoiceChips(
                values: flexWeightPresets,
                isSelected: (e) => listEquals(flexWeights, e),
                labelOf: (e) => '$e',
                onChanged: (e) => onMark('flexWeights $e', () => flexWeights = e),
              ),
            ),
          buildField(
            label: 'scrollDirection',
            showTopGap: true,
            child: buildChoiceChips(
              values: Axis.values,
              isSelected: (e) => scrollDirection == e,
              labelOf: (e) => e.name,
              onChanged: onScrollDirection,
            ),
          ),
          if (kind == _CarouselKind.uncontained)
            buildSlider(
              label: 'itemExtent',
              value: itemExtent,
              min: 80,
              max: 400,
              onChanged: (v) => onMark('itemExtent ${v.round()}', () => itemExtent = v),
            ),
          buildSlider(
            label: 'shrinkExtent',
            value: shrinkExtent,
            min: 0,
            max: 200,
            onChanged: (v) => onMark('shrinkExtent ${v.round()}', () => shrinkExtent = v),
          ),
          buildSlider(
            label: 'padding',
            value: padding,
            min: 0,
            max: 24,
            onChanged: (v) => onMark('padding ${v.round()}', () => padding = v),
          ),
          buildSlider(
            label: 'viewport 高度',
            value: viewportExtent,
            min: 120,
            max: 480,
            onChanged: (v) => onMark('viewport ${v.round()}', () => viewportExtent = v),
          ),
          buildSlider(label: 'itemCount', value: itemCount.toDouble(), min: 3, max: 20, onChanged: onItemCount),
          buildSlider(
            label: 'initialItem',
            value: initialItem.toDouble(),
            min: 0,
            max: math.max(itemCount - 1, 1).toDouble(),
            onChanged: onInitialItem,
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
          buildField(
            label: 'shape',
            child: buildChoiceChips(
              values: const [ShapeKind.rounded, ShapeKind.stadium],
              isSelected: (e) => shapeKind == e,
              labelOf: (e) => e == ShapeKind.rounded ? 'RoundedRectangleBorder' : 'StadiumBorder',
              onChanged: (e) => onMark('shape ${e.name}', () => shapeKind = e),
            ),
          ),
          if (shapeKind == ShapeKind.rounded)
            buildSlider(
              label: 'borderRadius',
              value: borderRadius,
              min: 0,
              max: 48,
              onChanged: (v) => onMark('borderRadius ${v.round()}', () => borderRadius = v),
            ),
          buildSlider(
            label: 'elevation',
            value: elevation,
            min: 0,
            max: 16,
            onChanged: (v) => onMark('elevation ${v.round()}', () => elevation = v),
          ),
          buildField(
            label: 'backgroundColor',
            showTopGap: true,
            child: buildColorDots(
              value: backgroundColor,
              onChanged: (e) => onMark('backgroundColor $e', () => backgroundColor = e),
            ),
          ),
          buildField(
            label: 'overlayColor',
            showTopGap: true,
            child: buildColorDots(
              value: overlayColor,
              onChanged: (e) => onMark('overlayColor $e', () => overlayColor = e),
            ),
          ),
          buildSwitch(
            title: 'itemSnapping 吸附',
            value: itemSnapping,
            onChanged: (v) => onMark('itemSnapping $v', () => itemSnapping = v),
          ),
          buildSwitch(title: 'reverse 反向滚动', value: reverse, onChanged: onReverse),
          buildSwitch(
            title: 'enableSplash 水波纹',
            value: enableSplash,
            onChanged: (v) => onMark('enableSplash $v', () => enableSplash = v),
          ),
          if (kind == _CarouselKind.weighted)
            buildSwitch(
              title: 'consumeMaxWeight 可撑满最大权重',
              value: consumeMaxWeight,
              onChanged: (v) => onMark('consumeMaxWeight $v', () => consumeMaxWeight = v),
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
    final scheme = theme.colorScheme;
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

  Widget buildColorDots({
    required Color? value,
    required ValueChanged<Color?> onChanged,
  }) {
    final scheme = theme.colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppColor.colorOptions.map((e) {
        final selected = value == e;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChanged(e),
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: e ?? scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.65),
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.28),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: e == null
                  ? Text(
                      '默',
                      style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    )
                  : selected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: ThemeData.estimateBrightnessForColor(e) == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        )
                      : null,
            ),
          ),
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
    final scheme = theme.colorScheme;
    return NSliderListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      min: min,
      max: max,
      value: value.clamp(min, max),
      onChanged: onChanged,
      activeColor: scheme.primary,
    );
  }

  Widget buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
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
    final scheme = theme.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('onTap Item $index'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
