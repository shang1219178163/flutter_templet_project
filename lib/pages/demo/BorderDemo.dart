//
//  ButtonBorderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 5:28 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/basicWidget/n_slider.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

/// 原 Demo 各节对应的边框构造
enum _Kind {
  borderSide,
  beveled,
  circle,
  continuous,
  linear,
  rounded,
  stadium,
  star,
  starPolygon,
  boxTop,
  boxCircle,
  shapeAll,
  shapeSides,
  shapeRounded,
  shapeBeveled,
  shapeUnderline,
  underlineTab,
  outlineInput,
  underlineInput,
}

class BorderDemo extends StatefulWidget {
  const BorderDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<BorderDemo> createState() => _BorderDemoState();
}

class _BorderDemoState extends State<BorderDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  _Kind kind = _Kind.borderSide;
  Color? sideColor = Colors.red;
  double sideWidth = 1;
  BorderStyle sideStyle = BorderStyle.solid;
  double strokeAlign = BorderSide.strokeAlignInside;
  double radius = 0;
  double eccentricity = 0;
  bool linearStart = false;
  bool linearEnd = false;
  bool linearTop = false;
  bool linearBottom = true;
  double linearSize = 1;
  double linearAlign = 0;
  double points = 5;
  double innerRadiusRatio = 0.4;
  double pointRounding = 0;
  double valleyRounding = 0;
  double rotation = 0;
  double squash = 0;
  Color? topColor = Colors.red;
  Color? rightColor = Colors.blue;
  Color? bottomColor = Colors.yellow;
  Color? leftColor = Colors.green;
  double insetL = 0;
  double insetT = 0;
  double insetR = 0;
  double insetB = 10;
  bool useTabRadius = false;
  double tabRadius = 4;
  double gapPadding = 4;
  String lastEvent = '—';

  static const _strokeAligns = <(String, double)>[
    ('inside', BorderSide.strokeAlignInside),
    ('center', BorderSide.strokeAlignCenter),
    ('outside', BorderSide.strokeAlignOutside),
  ];

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
          final previewHeight = (constraints.maxHeight * 0.36).clamp(220.0, 340.0);
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
                            NLangEnum.en: 'Widget Border / ShapeBorder',
                            NLangEnum.zh: '组件 Border / ShapeBorder',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Each chip is one original section. TextButton, BoxDecoration, and ShapeDecoration keep the same children.',
                              NLangEnum.zh: '每种 Chip 对应原 Demo 一节。TextButton、BoxDecoration、ShapeDecoration 的 child 不变。',
                            },
                            {
                              NLangEnum.en:
                                  'BorderSide color/width/style/strokeAlign apply to the selected shape. Switch kind to load that section’s original defaults.',
                              NLangEnum.zh: 'BorderSide 的颜色、宽度、style、strokeAlign 作用在当前形状上。切换种类会套用该节原来的默认值。',
                            },
                            {
                              NLangEnum.en: 'StarBorder.polygon is the second constructor of StarBorder.',
                              NLangEnum.zh: 'starPolygon 是 StarBorder.polygon 第二个构造。',
                            },
                          ],
                        ),
                        buildConstructCard(),
                        buildSideCard(),
                        buildExtraCard(),
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

  Widget buildPreview(double previewHeight) {
    final theme = Theme.of(context);
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
            height: previewHeight,
            width: double.infinity,
            child: ClipRect(
              child: ColoredBox(
                color: scheme.surface,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: buildSample(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              lastEvent,
              textAlign: TextAlign.center,
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

  Widget buildSample() {
    switch (kind) {
      case _Kind.borderSide:
        return TextButton(
          style: TextButton.styleFrom(side: sideOf()),
          onPressed: onPressed,
          child: const Text('BorderSide'),
        );
      case _Kind.beveled:
        return TextButton(
          style: TextButton.styleFrom(shape: beveledOf()),
          onPressed: onPressed,
          child: Text('BeveledRectangleBorder - radius: ${radius.round()}'),
        );
      case _Kind.circle:
        return TextButton(
          style: TextButton.styleFrom(
            shape: CircleBorder(side: sideOf(), eccentricity: eccentricity),
            minimumSize: const Size(100, 100),
          ),
          onPressed: onPressed,
          child: const Text('CircleBorder'),
        );
      case _Kind.continuous:
        return TextButton(
          style: TextButton.styleFrom(shape: continuousOf()),
          onPressed: onPressed,
          child: const Text('ContinuousRectangleBorder'),
        );
      case _Kind.linear:
        return TextButton(
          style: TextButton.styleFrom(shape: linearOf()),
          onPressed: onPressed,
          child: const Text('LinearBorder'),
        );
      case _Kind.rounded:
        return TextButton(
          style: TextButton.styleFrom(shape: roundedOf()),
          onPressed: onPressed,
          child: const Text('RoundedRectangleBorder'),
        );
      case _Kind.stadium:
        return TextButton(
          style: TextButton.styleFrom(shape: StadiumBorder(side: sideOf())),
          onPressed: onPressed,
          child: const Text('StadiumBorder'),
        );
      case _Kind.star:
      case _Kind.starPolygon:
        return TextButton(
          style: TextButton.styleFrom(shape: starOf()),
          onPressed: onPressed,
          child: Text(kind == _Kind.star ? 'StarBorder' : 'StarBorder.polygon'),
        );
      case _Kind.boxTop:
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border(top: sideOf()),
          ),
          child: const Icon(Icons.pool, size: 32, color: Colors.white),
        );
      case _Kind.boxCircle:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: sideColor ?? const Color(0xFF000000),
              width: sideWidth,
              style: sideStyle,
              strokeAlign: strokeAlign,
            ),
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: 24,
            icon: const Icon(Icons.check),
            onPressed: onPressed,
          ),
        );
      case _Kind.shapeAll:
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            shape: Border.all(
              color: sideColor ?? const Color(0xFF000000),
              width: sideWidth,
              style: sideStyle,
              strokeAlign: strokeAlign,
            ),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: const Text('ShapeDecoration - Border.all'),
          ),
        );
      case _Kind.shapeSides:
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: ShapeDecoration(shape: borderSidesOf()),
          child: TextButton(
            onPressed: onPressed,
            child: const Text('ShapeDecoration - Border.top,bottom,right,left'),
          ),
        );
      case _Kind.shapeRounded:
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: Colors.yellowAccent,
            shape: roundedOf(),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: const Text('ShapeDecoration - RoundedRectangleBorder'),
          ),
        );
      case _Kind.shapeBeveled:
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: Colors.yellowAccent,
            shape: beveledOf(),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: const Text('ShapeDecoration - BeveledRectangleBorder'),
          ),
        );
      case _Kind.shapeUnderline:
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              colors: [Colors.yellow, Colors.green],
            ),
            shape: UnderlineInputBorder(
              borderSide: sideOf(),
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: const Text('ShapeDecoration - UnderlineInputBorder'),
          ),
        );
      case _Kind.underlineTab:
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: UnderlineTabIndicator(
            borderRadius: useTabRadius ? BorderRadius.circular(tabRadius) : null,
            borderSide: sideOf(),
            insets: EdgeInsets.fromLTRB(insetL, insetT, insetR, insetB),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: const Text('Decoration - UnderlineTabIndicator'),
          ),
        );
      case _Kind.outlineInput:
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            shape: OutlineInputBorder(
              borderSide: sideOf(),
              borderRadius: BorderRadius.circular(radius),
              gapPadding: gapPadding,
            ),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: const Text('ShapeDecoration - OutlineInputBorder'),
          ),
        );
      case _Kind.underlineInput:
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            shape: UnderlineInputBorder(
              borderSide: sideOf(),
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: const Text('ShapeDecoration - UnderlineInputBorder'),
          ),
        );
    }
  }

  BorderSide sideOf({Color? color}) {
    return BorderSide(
      color: color ?? sideColor ?? const Color(0xFF000000),
      width: sideWidth,
      style: sideStyle,
      strokeAlign: strokeAlign,
    );
  }

  BeveledRectangleBorder beveledOf() {
    return BeveledRectangleBorder(
      side: sideOf(),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  ContinuousRectangleBorder continuousOf() {
    return ContinuousRectangleBorder(
      side: sideOf(),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  RoundedRectangleBorder roundedOf() {
    return RoundedRectangleBorder(
      side: sideOf(),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  LinearBorder linearOf() {
    LinearBorderEdge? edge() {
      return LinearBorderEdge(size: linearSize, alignment: linearAlign);
    }
    return LinearBorder(
      side: sideOf(),
      start: linearStart ? edge() : null,
      end: linearEnd ? edge() : null,
      top: linearTop ? edge() : null,
      bottom: linearBottom ? edge() : null,
    );
  }

  StarBorder starOf() {
    if (kind == _Kind.starPolygon) {
      return StarBorder.polygon(
        side: sideOf(),
        sides: points,
        pointRounding: pointRounding,
        rotation: rotation,
        squash: squash,
      );
    }
    return StarBorder(
      side: sideOf(),
      points: points,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      rotation: rotation,
      squash: squash,
    );
  }

  Border borderSidesOf() {
    return Border(
      top: sideOf(color: topColor),
      right: sideOf(color: rightColor),
      bottom: sideOf(color: bottomColor),
      left: sideOf(color: leftColor),
    );
  }

  Widget buildConstructCard() {
    return NDecorationCard(
      icon: const Icon(Icons.account_tree_rounded),
      title: '构造',
      subtitle: 'Border · OutlinedBorder · BoxBorder',
      child: buildChoiceChips(
        values: _Kind.values,
        isSelected: (e) => kind == e,
        labelOf: (e) => e.name,
        onChanged: onKind,
      ),
    );
  }

  Widget buildSideCard() {
    return NDecorationCard(
      icon: const Icon(Icons.border_color_rounded),
      title: 'BorderSide',
      subtitle: 'color · width · style · strokeAlign',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (kind == _Kind.shapeSides) ...[
            buildField(
              label: 'top.color',
              child: buildColorDots(value: topColor, onChanged: onTopColor),
            ),
            buildField(
              label: 'right.color',
              showTopGap: true,
              child: buildColorDots(value: rightColor, onChanged: onRightColor),
            ),
            buildField(
              label: 'bottom.color',
              showTopGap: true,
              child: buildColorDots(value: bottomColor, onChanged: onBottomColor),
            ),
            buildField(
              label: 'left.color',
              showTopGap: true,
              child: buildColorDots(value: leftColor, onChanged: onLeftColor),
            ),
          ] else
            buildField(
              label: 'color',
              child: buildColorDots(value: sideColor, onChanged: onSideColor),
            ),
          buildSlider(
            label: 'width',
            value: sideWidth,
            min: 0,
            max: 12,
            onChanged: onSideWidth,
            fractionDigits: 1,
          ),
          buildField(
            label: 'style',
            showTopGap: true,
            child: buildChoiceChips(
              values: BorderStyle.values,
              isSelected: (e) => sideStyle == e,
              labelOf: (e) => e.name,
              onChanged: onSideStyle,
            ),
          ),
          buildField(
            label: 'strokeAlign',
            showTopGap: true,
            child: buildChoiceChips(
              values: _strokeAligns,
              isSelected: (e) => strokeAlign == e.$2,
              labelOf: (e) => e.$1,
              onChanged: onStrokeAlign,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExtraCard() {
    final children = <Widget>[];
    if (usesRadius) {
      children.add(
        buildSlider(
          label: 'borderRadius',
          value: radius,
          min: 0,
          max: 100,
          onChanged: onRadius,
        ),
      );
    }
    if (kind == _Kind.circle) {
      children.add(
        buildSlider(
          label: 'eccentricity',
          value: eccentricity,
          min: 0,
          max: 1,
          onChanged: onEccentricity,
          fractionDigits: 2,
        ),
      );
    }
    if (kind == _Kind.linear) {
      children.addAll([
        buildSwitch(title: 'start', value: linearStart, onChanged: onLinearStart),
        buildSwitch(title: 'end', value: linearEnd, onChanged: onLinearEnd),
        buildSwitch(title: 'top', value: linearTop, onChanged: onLinearTop),
        buildSwitch(title: 'bottom', value: linearBottom, onChanged: onLinearBottom),
        buildSlider(
          label: 'edge.size',
          value: linearSize,
          min: 0,
          max: 1,
          onChanged: onLinearSize,
          fractionDigits: 2,
        ),
        buildSlider(
          label: 'edge.alignment',
          value: linearAlign,
          min: -1,
          max: 1,
          onChanged: onLinearAlign,
          fractionDigits: 2,
        ),
      ]);
    }
    if (kind == _Kind.star || kind == _Kind.starPolygon) {
      children.add(
        buildSlider(
          label: kind == _Kind.starPolygon ? 'sides' : 'points',
          value: points,
          min: 2,
          max: 12,
          onChanged: onPoints,
          fractionDigits: 1,
        ),
      );
      if (kind == _Kind.star) {
        children.add(
          buildSlider(
            label: 'innerRadiusRatio',
            value: innerRadiusRatio,
            min: 0,
            max: 1,
            onChanged: onInnerRadiusRatio,
            fractionDigits: 2,
          ),
        );
      }
      children.add(
        buildSlider(
          label: 'pointRounding',
          value: pointRounding,
          min: 0,
          max: 1,
          onChanged: onPointRounding,
          fractionDigits: 2,
        ),
      );
      if (kind == _Kind.star) {
        children.add(
          buildSlider(
            label: 'valleyRounding',
            value: valleyRounding,
            min: 0,
            max: 1,
            onChanged: onValleyRounding,
            fractionDigits: 2,
          ),
        );
      }
      children.add(
        buildSlider(
          label: 'rotation',
          value: rotation,
          min: 0,
          max: 360,
          onChanged: onRotation,
        ),
      );
      children.add(
        buildSlider(
          label: 'squash',
          value: squash,
          min: 0,
          max: 1,
          onChanged: onSquash,
          fractionDigits: 2,
        ),
      );
    }
    if (kind == _Kind.underlineTab) {
      children.addAll([
        buildSlider(label: 'insets.left', value: insetL, min: 0, max: 24, onChanged: onInsetL),
        buildSlider(label: 'insets.top', value: insetT, min: 0, max: 24, onChanged: onInsetT),
        buildSlider(label: 'insets.right', value: insetR, min: 0, max: 24, onChanged: onInsetR),
        buildSlider(label: 'insets.bottom', value: insetB, min: 0, max: 24, onChanged: onInsetB),
        buildSwitch(title: 'borderRadius', value: useTabRadius, onChanged: onUseTabRadius),
      ]);
      if (useTabRadius) {
        children.add(
          buildSlider(label: 'borderRadius', value: tabRadius, min: 0, max: 24, onChanged: onTabRadius),
        );
      }
    }
    if (kind == _Kind.outlineInput) {
      children.add(
        buildSlider(
          label: 'gapPadding',
          value: gapPadding,
          min: 0,
          max: 24,
          onChanged: onGapPadding,
          fractionDigits: 1,
        ),
      );
    }
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return NDecorationCard(
      icon: const Icon(Icons.tune_rounded),
      title: '形状',
      subtitle: kind.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  bool get usesRadius {
    switch (kind) {
      case _Kind.beveled:
      case _Kind.continuous:
      case _Kind.rounded:
      case _Kind.shapeRounded:
      case _Kind.shapeBeveled:
      case _Kind.shapeUnderline:
      case _Kind.outlineInput:
      case _Kind.underlineInput:
        return true;
      default:
        return false;
    }
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

  Widget buildColorDots({
    required Color? value,
    required ValueChanged<Color?> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
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
    int fractionDigits = 0,
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
      value: value,
      onChanged: onChanged,
      activeColor: scheme.primary,
      trailingBuilder: fractionDigits > 0
          ? (context, v) {
              return Text(
                v.toStringAsFixed(fractionDigits),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            }
          : null,
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

  void applyKindDefaults(_Kind value) {
    kind = value;
    sideStyle = BorderStyle.solid;
    strokeAlign = BorderSide.strokeAlignInside;
    eccentricity = 0;
    linearStart = false;
    linearEnd = false;
    linearTop = false;
    linearBottom = true;
    linearSize = 1;
    linearAlign = 0;
    points = 5;
    innerRadiusRatio = 0.4;
    pointRounding = 0;
    valleyRounding = 0;
    rotation = 0;
    squash = 0;
    topColor = Colors.red;
    rightColor = Colors.blue;
    bottomColor = Colors.yellow;
    leftColor = Colors.green;
    insetL = 0;
    insetT = 0;
    insetR = 0;
    insetB = 10;
    useTabRadius = false;
    tabRadius = 4;
    gapPadding = 4;
    switch (value) {
      case _Kind.borderSide:
        sideColor = Colors.red;
        sideWidth = 1;
        radius = 0;
      case _Kind.beveled:
        sideColor = Colors.red;
        sideWidth = 1;
        radius = 0;
      case _Kind.circle:
        sideColor = Colors.red;
        sideWidth = 1;
      case _Kind.continuous:
        sideColor = Colors.red;
        sideWidth = 1;
        radius = 20;
      case _Kind.linear:
        sideColor = Colors.green;
        sideWidth = 1;
      case _Kind.rounded:
        sideColor = Colors.red;
        sideWidth = 1;
        radius = 8;
      case _Kind.stadium:
        sideColor = Colors.red;
        sideWidth = 1;
      case _Kind.star:
        sideColor = Colors.blue;
        sideWidth = 1;
      case _Kind.starPolygon:
        sideColor = Colors.blue;
        sideWidth = 1;
      case _Kind.boxTop:
        sideColor = Colors.red;
        sideWidth = 3;
      case _Kind.boxCircle:
        sideColor = Colors.blue;
        sideWidth = 4;
      case _Kind.shapeAll:
        sideColor = Colors.green;
        sideWidth = 2;
      case _Kind.shapeSides:
        sideWidth = 5;
      case _Kind.shapeRounded:
        sideColor = Colors.red;
        sideWidth = 2;
        radius = 10;
      case _Kind.shapeBeveled:
        sideColor = Colors.red;
        sideWidth = 2;
        radius = 10;
      case _Kind.shapeUnderline:
        sideColor = Colors.red;
        sideWidth = 2;
        radius = 10;
      case _Kind.underlineTab:
        sideColor = Colors.red;
        sideWidth = 2;
      case _Kind.outlineInput:
        sideColor = Colors.red;
        sideWidth = 1;
        radius = 10;
      case _Kind.underlineInput:
        sideColor = Colors.red;
        sideWidth = 1;
        radius = 10;
    }
  }

  void onKind(_Kind value) {
    applyKindDefaults(value);
    setState(() {});
  }

  void onSideColor(Color? value) {
    sideColor = value;
    setState(() {});
  }

  void onTopColor(Color? value) {
    topColor = value;
    setState(() {});
  }

  void onRightColor(Color? value) {
    rightColor = value;
    setState(() {});
  }

  void onBottomColor(Color? value) {
    bottomColor = value;
    setState(() {});
  }

  void onLeftColor(Color? value) {
    leftColor = value;
    setState(() {});
  }

  void onSideWidth(double value) {
    sideWidth = value;
    setState(() {});
  }

  void onSideStyle(BorderStyle value) {
    sideStyle = value;
    setState(() {});
  }

  void onStrokeAlign((String, double) value) {
    strokeAlign = value.$2;
    setState(() {});
  }

  void onRadius(double value) {
    radius = value;
    setState(() {});
  }

  void onEccentricity(double value) {
    eccentricity = value;
    setState(() {});
  }

  void onLinearStart(bool value) {
    linearStart = value;
    setState(() {});
  }

  void onLinearEnd(bool value) {
    linearEnd = value;
    setState(() {});
  }

  void onLinearTop(bool value) {
    linearTop = value;
    setState(() {});
  }

  void onLinearBottom(bool value) {
    linearBottom = value;
    setState(() {});
  }

  void onLinearSize(double value) {
    linearSize = value;
    setState(() {});
  }

  void onLinearAlign(double value) {
    linearAlign = value;
    setState(() {});
  }

  void onPoints(double value) {
    points = value;
    setState(() {});
  }

  void onInnerRadiusRatio(double value) {
    innerRadiusRatio = value;
    setState(() {});
  }

  void onPointRounding(double value) {
    pointRounding = value;
    if (pointRounding + valleyRounding > 1) {
      valleyRounding = 1 - pointRounding;
    }
    setState(() {});
  }

  void onValleyRounding(double value) {
    valleyRounding = value;
    if (pointRounding + valleyRounding > 1) {
      pointRounding = 1 - valleyRounding;
    }
    setState(() {});
  }

  void onRotation(double value) {
    rotation = value;
    setState(() {});
  }

  void onSquash(double value) {
    squash = value;
    setState(() {});
  }

  void onInsetL(double value) {
    insetL = value;
    setState(() {});
  }

  void onInsetT(double value) {
    insetT = value;
    setState(() {});
  }

  void onInsetR(double value) {
    insetR = value;
    setState(() {});
  }

  void onInsetB(double value) {
    insetB = value;
    setState(() {});
  }

  void onUseTabRadius(bool value) {
    useTabRadius = value;
    setState(() {});
  }

  void onTabRadius(double value) {
    tabRadius = value;
    setState(() {});
  }

  void onGapPadding(double value) {
    gapPadding = value;
    setState(() {});
  }

  void onPressed() {
    lastEvent = 'onPressed ${kind.name}';
    DLog.d(lastEvent);
    setState(() {});
  }

  void onReset() {
    lastEvent = '—';
    applyKindDefaults(_Kind.borderSide);
    setState(() {});
  }
}
