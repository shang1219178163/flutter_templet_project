//
//  ButtonBorderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 5:28 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_chip_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_choice_color_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_slider_list_item.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
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
  late final theme = Theme.of(context);

  final scrollController = ScrollController();

  /// 边框种类
  _Kind kind = _Kind.borderSide;
  /// 边颜色
  Color? sideColor = Colors.red;
  /// 边宽度
  double sideWidth = 1;
  /// 边样式
  BorderStyle sideStyle = BorderStyle.solid;
  /// 描边对齐
  double strokeAlign = BorderSide.strokeAlignInside;
  /// 圆角
  double radius = 0;
  /// 椭圆离心率
  double eccentricity = 0;
  /// Linear 起点边
  bool linearStart = false;
  /// Linear 终点边
  bool linearEnd = false;
  /// Linear 顶边
  bool linearTop = false;
  /// Linear 底边
  bool linearBottom = true;
  /// Linear 边长比例
  double linearSize = 1;
  /// Linear 边对齐
  double linearAlign = 0;
  /// 星形点数 / 多边形边数
  double points = 5;
  /// 星形内径比
  double innerRadiusRatio = 0.4;
  /// 尖角圆度
  double pointRounding = 0;
  /// 谷底圆度
  double valleyRounding = 0;
  /// 旋转角度
  double rotation = 0;
  /// 压扁
  double squash = 0;
  /// 上边颜色
  Color? topColor = Colors.red;
  /// 右边颜色
  Color? rightColor = Colors.blue;
  /// 下边颜色
  Color? bottomColor = Colors.yellow;
  /// 左边颜色
  Color? leftColor = Colors.green;
  /// Tab 指示器 insets
  double insetL = 0;
  double insetT = 0;
  double insetR = 0;
  double insetB = 10;
  /// 是否使用 Tab 圆角
  bool useTabRadius = false;
  /// Tab 圆角
  double tabRadius = 4;
  /// Outline 缺口 padding
  double gapPadding = 4;
  /// 最近事件
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
                                  'Each chip is one original section. BorderSide applies to the selected shape; switching kind loads that section’s defaults. starPolygon is StarBorder.polygon.',
                              NLangEnum.zh: '每种 Chip 对应原 Demo 一节。BorderSide 作用在当前形状上；切换种类会套用该节默认值。starPolygon 是 StarBorder.polygon。',
                            },
                          ],
                        ),
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
    final edge = LinearBorderEdge(size: linearSize, alignment: linearAlign);
    return LinearBorder(
      side: sideOf(),
      start: linearStart ? edge : null,
      end: linearEnd ? edge : null,
      top: linearTop ? edge : null,
      bottom: linearBottom ? edge : null,
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

  Widget buildSideCard() {
    return NDecorationCard(
      icon: const Icon(Icons.border_color_rounded),
      title: '边框',
      subtitle: 'kind · BorderSide',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NChoiceChipListItem(
            title: const Text('kind'),
            values: _Kind.values,
            value: kind,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('kind ${e.name}', () => applyKindDefaults(e)),
          ),
          if (kind == _Kind.shapeSides) ...[
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('top.color'),
              value: topColor,
              onChanged: (e) => onMark('top.color', () => topColor = e),
            ),
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('right.color'),
              value: rightColor,
              onChanged: (e) => onMark('right.color', () => rightColor = e),
            ),
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('bottom.color'),
              value: bottomColor,
              onChanged: (e) => onMark('bottom.color', () => bottomColor = e),
            ),
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('left.color'),
              value: leftColor,
              onChanged: (e) => onMark('left.color', () => leftColor = e),
            ),
          ] else ...[
            const SizedBox(height: 8),
            NChoiceColorListItem(
              title: const Text('color'),
              value: sideColor,
              onChanged: (e) => onMark('color', () => sideColor = e),
            ),
          ],
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('width'),
            min: 0,
            max: 12,
            value: sideWidth.clamp(0, 12),
            onChanged: (v) => onMark('width ${v.toStringAsFixed(1)}', () => sideWidth = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('style'),
            values: BorderStyle.values,
            value: sideStyle,
            labelOf: (e) => e.name,
            onChanged: (e) => onMark('style ${e.name}', () => sideStyle = e),
          ),
          const SizedBox(height: 8),
          NChoiceChipListItem(
            title: const Text('strokeAlign'),
            values: _strokeAligns,
            onEqual: (e) => strokeAlign == e.$2,
            labelOf: (e) => e.$1,
            onChanged: (e) => onMark('strokeAlign ${e.$1}', () => strokeAlign = e.$2),
          ),
        ],
      ),
    );
  }

  Widget buildExtraCard() {
    final children = <Widget>[];
    if (usesRadius) {
      children.add(
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('borderRadius'),
          min: 0,
          max: 100,
          value: radius.clamp(0, 100),
          onChanged: (v) => onMark('borderRadius ${v.round()}', () => radius = v),
          activeColor: theme.colorScheme.primary,
        ),
      );
    }
    if (kind == _Kind.circle) {
      children.add(
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('eccentricity'),
          min: 0,
          max: 1,
          value: eccentricity.clamp(0, 1),
          onChanged: (v) => onMark('eccentricity ${v.toStringAsFixed(2)}', () => eccentricity = v),
          activeColor: theme.colorScheme.primary,
          valueBuilder: (context, v) {
            return Text(
              v.toStringAsFixed(2),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
            );
          },
        ),
      );
    }
    if (kind == _Kind.linear) {
      children.addAll([
        NSwitchListItem(title: const Text('start'), value: linearStart, onChanged: (v) => onMark('start $v', () => linearStart = v)),
        NSwitchListItem(title: const Text('end'), value: linearEnd, onChanged: (v) => onMark('end $v', () => linearEnd = v)),
        NSwitchListItem(title: const Text('top'), value: linearTop, onChanged: (v) => onMark('top $v', () => linearTop = v)),
        NSwitchListItem(
          title: const Text('bottom'),
          value: linearBottom,
          onChanged: (v) => onMark('bottom $v', () => linearBottom = v),
        ),
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('edge.size'),
          min: 0,
          max: 1,
          value: linearSize.clamp(0, 1),
          onChanged: (v) => onMark('edge.size ${v.toStringAsFixed(2)}', () => linearSize = v),
          activeColor: theme.colorScheme.primary,
          valueBuilder: (context, v) {
            return Text(
              v.toStringAsFixed(2),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
            );
          },
        ),
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('edge.alignment'),
          min: -1,
          max: 1,
          value: linearAlign.clamp(-1, 1),
          onChanged: (v) => onMark('edge.alignment ${v.toStringAsFixed(2)}', () => linearAlign = v),
          activeColor: theme.colorScheme.primary,
          valueBuilder: (context, v) {
            return Text(
              v.toStringAsFixed(2),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
            );
          },
        ),
      ]);
    }
    if (kind == _Kind.star || kind == _Kind.starPolygon) {
      children.add(
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(kind == _Kind.starPolygon ? 'sides' : 'points'),
          min: 2,
          max: 12,
          value: points.clamp(2, 12),
          onChanged: (v) {
            final name = kind == _Kind.starPolygon ? 'sides' : 'points';
            onMark('$name ${v.toStringAsFixed(1)}', () => points = v);
          },
          activeColor: theme.colorScheme.primary,
          valueBuilder: (context, v) {
            return Text(
              v.toStringAsFixed(1),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
            );
          },
        ),
      );
      if (kind == _Kind.star) {
        children.add(
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('innerRadiusRatio'),
            min: 0,
            max: 1,
            value: innerRadiusRatio.clamp(0, 1),
            onChanged: (v) => onMark('innerRadiusRatio ${v.toStringAsFixed(2)}', () => innerRadiusRatio = v),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(2),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
        );
      }
      children.add(
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('pointRounding'),
          min: 0,
          max: 1,
          value: pointRounding.clamp(0, 1),
          onChanged: (v) => onMark('pointRounding ${v.toStringAsFixed(2)}', () {
            pointRounding = v;
            if (pointRounding + valleyRounding > 1) {
              valleyRounding = 1 - pointRounding;
            }
          }),
          activeColor: theme.colorScheme.primary,
          valueBuilder: (context, v) {
            return Text(
              v.toStringAsFixed(2),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
            );
          },
        ),
      );
      if (kind == _Kind.star) {
        children.add(
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('valleyRounding'),
            min: 0,
            max: 1,
            value: valleyRounding.clamp(0, 1),
            onChanged: (v) => onMark('valleyRounding ${v.toStringAsFixed(2)}', () {
              valleyRounding = v;
              if (pointRounding + valleyRounding > 1) {
                pointRounding = 1 - valleyRounding;
              }
            }),
            activeColor: theme.colorScheme.primary,
            valueBuilder: (context, v) {
              return Text(
                v.toStringAsFixed(2),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
        );
      }
      children.add(
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('rotation'),
          min: 0,
          max: 360,
          value: rotation.clamp(0, 360),
          onChanged: (v) => onMark('rotation ${v.round()}', () => rotation = v),
          activeColor: theme.colorScheme.primary,
        ),
      );
      children.add(
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('squash'),
          min: 0,
          max: 1,
          value: squash.clamp(0, 1),
          onChanged: (v) => onMark('squash ${v.toStringAsFixed(2)}', () => squash = v),
          activeColor: theme.colorScheme.primary,
          valueBuilder: (context, v) {
            return Text(
              v.toStringAsFixed(2),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
            );
          },
        ),
      );
    }
    if (kind == _Kind.underlineTab) {
      children.addAll([
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('insets.left'),
          min: 0,
          max: 24,
          value: insetL.clamp(0, 24),
          onChanged: (v) => onMark('insets.left ${v.round()}', () => insetL = v),
          activeColor: theme.colorScheme.primary,
        ),
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('insets.top'),
          min: 0,
          max: 24,
          value: insetT.clamp(0, 24),
          onChanged: (v) => onMark('insets.top ${v.round()}', () => insetT = v),
          activeColor: theme.colorScheme.primary,
        ),
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('insets.right'),
          min: 0,
          max: 24,
          value: insetR.clamp(0, 24),
          onChanged: (v) => onMark('insets.right ${v.round()}', () => insetR = v),
          activeColor: theme.colorScheme.primary,
        ),
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('insets.bottom'),
          min: 0,
          max: 24,
          value: insetB.clamp(0, 24),
          onChanged: (v) => onMark('insets.bottom ${v.round()}', () => insetB = v),
          activeColor: theme.colorScheme.primary,
        ),
        NSwitchListItem(
          title: const Text('borderRadius'),
          value: useTabRadius,
          onChanged: (v) => onMark('borderRadius $v', () => useTabRadius = v),
        ),
      ]);
      if (useTabRadius) {
        children.add(
          NSliderListItem(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('borderRadius'),
            min: 0,
            max: 24,
            value: tabRadius.clamp(0, 24),
            onChanged: (v) => onMark('tabRadius ${v.round()}', () => tabRadius = v),
            activeColor: theme.colorScheme.primary,
          ),
        );
      }
    }
    if (kind == _Kind.outlineInput) {
      children.add(
        NSliderListItem(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('gapPadding'),
          min: 0,
          max: 24,
          value: gapPadding.clamp(0, 24),
          onChanged: (v) => onMark('gapPadding ${v.toStringAsFixed(1)}', () => gapPadding = v),
          activeColor: theme.colorScheme.primary,
          valueBuilder: (context, v) {
            return Text(
              v.toStringAsFixed(1),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
            );
          },
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

  bool get usesRadius => switch (kind) {
        _Kind.beveled ||
        _Kind.continuous ||
        _Kind.rounded ||
        _Kind.shapeRounded ||
        _Kind.shapeBeveled ||
        _Kind.shapeUnderline ||
        _Kind.outlineInput ||
        _Kind.underlineInput =>
          true,
        _ => false,
      };


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

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    DLog.d(event);
    setState(() {});
  }

  void onPressed() {
    onMark('onPressed ${kind.name}');
  }

  void onReset() {
    lastEvent = '—';
    applyKindDefaults(_Kind.borderSide);
    setState(() {});
  }
}
