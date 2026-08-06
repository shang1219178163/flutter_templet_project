//
//  NSliverContainer.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/28.
//  Copyright © 2026 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Sliver 族的 [Container] 组合组件。
///
/// 对齐 [Container] 的常用绘制 / 间距属性，并按相近的包裹顺序组装。
///
/// ## 与 [Container] 的对应关系
///
/// | Container | NSliverContainer |
/// | --- | --- |
/// | [Container.padding] | [padding]（并入 [Decoration.padding]） |
/// | [Container.decoration] | [decoration] |
/// | [Container.foregroundDecoration] | [foregroundDecoration] |
/// | [Container.margin] | [margin] |
/// | [Container.child] | [sliver]（必须是 Sliver） |
/// | [Container.clipBehavior] | 仅保留 API；3.27 无官方 Sliver Clip，仅支持 [Clip.none] |
/// | color / constraints / alignment / transform | 无对应或不提供；纯色请用 [BoxDecoration.color] |
///
/// ## 额外可组装属性
///
/// - [foregroundPadding]：背景装饰与前景装饰之间的间距
/// - [opacity] → [SliverOpacity]
/// - [ignoring] → [SliverIgnorePointer]
/// - [offstage] → [SliverOffstage]
/// - [safeArea] → [SliverSafeArea]
class NSliverContainer extends StatelessWidget {
  /// 创建 Sliver 容器。
  ///
  /// 纯色背景请使用 `decoration: BoxDecoration(color: ...)`。
  NSliverContainer({
    super.key,
    this.padding,
    this.decoration,
    this.foregroundDecoration,
    this.margin,
    this.clipBehavior = Clip.none,
    required this.sliver,
    this.foregroundPadding,
    this.opacity,
    this.alwaysIncludeSemantics = false,
    this.ignoring,
    this.offstage,
    this.safeArea = false,
    this.safeAreaLeft = true,
    this.safeAreaTop = true,
    this.safeAreaRight = true,
    this.safeAreaBottom = true,
    this.safeAreaMinimum = EdgeInsets.zero,
  })  : assert(margin == null || margin!.isNonNegative),
        assert(padding == null || padding!.isNonNegative),
        assert(foregroundPadding == null || foregroundPadding!.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(
          clipBehavior == Clip.none,
          'NSliverContainer: Flutter 3.27 无官方对应的 Sliver ClipPath，'
          'clipBehavior 仅支持 Clip.none。',
        ),
        assert(opacity == null || (opacity >= 0.0 && opacity <= 1.0));

  /// 内边距，位于装饰内侧。
  ///
  /// 会与 [decoration] 自带的 [Decoration.padding] 合并，行为对齐 [Container]。
  final EdgeInsetsGeometry? padding;

  /// 背景装饰，对应 [Container.decoration]。
  final Decoration? decoration;

  /// 前景装饰，对应 [Container.foregroundDecoration]。
  final Decoration? foregroundDecoration;

  /// 外边距，对应 [Container.margin]。
  final EdgeInsetsGeometry? margin;

  /// 裁剪行为。
  ///
  /// Flutter 3.27 无官方 Sliver 级 [ClipPath]，目前仅允许 [Clip.none]。
  final Clip clipBehavior;

  /// 子 Sliver，对应 [Container.child]。
  final Widget sliver;

  /// 背景装饰与前景装饰之间的间距（[Container] 无此属性）。
  final EdgeInsetsGeometry? foregroundPadding;

  /// 透明度，映射为 [SliverOpacity]。
  final double? opacity;

  /// 传给 [SliverOpacity.alwaysIncludeSemantics]。
  final bool alwaysIncludeSemantics;

  /// 是否忽略指针事件，映射为 [SliverIgnorePointer]。
  final bool? ignoring;

  /// 是否离屏，映射为 [SliverOffstage]。
  final bool? offstage;

  /// 是否包裹 [SliverSafeArea]。
  final bool safeArea;

  /// [SliverSafeArea.left]
  final bool safeAreaLeft;

  /// [SliverSafeArea.top]
  final bool safeAreaTop;

  /// [SliverSafeArea.right]
  final bool safeAreaRight;

  /// [SliverSafeArea.bottom]
  final bool safeAreaBottom;

  /// [SliverSafeArea.minimum]
  final EdgeInsets safeAreaMinimum;

  /// 合并 [padding] 与 [Decoration.padding]，对齐 [Container]。
  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    return switch ((padding, decoration?.padding)) {
      (null, final EdgeInsetsGeometry? decorationPadding) => decorationPadding,
      (final EdgeInsetsGeometry? contentPadding, null) => contentPadding,
      (final EdgeInsetsGeometry contentPadding, final EdgeInsetsGeometry decorationPadding) =>
        contentPadding.add(decorationPadding),
    };
  }

  @override
  Widget build(BuildContext context) {
    // 组装顺序对齐 Container：内 → 外
    // padding → background → foregroundPadding → foreground → margin → extras
    var current = sliver;
    final effectivePadding = _paddingIncludingDecoration;
    if (effectivePadding != null) {
      current = SliverPadding(
        padding: effectivePadding,
        sliver: current,
      );
    }
    if (decoration != null) {
      current = DecoratedSliver(
        decoration: decoration!,
        sliver: current,
      );
    }
    if (foregroundPadding != null) {
      current = SliverPadding(
        padding: foregroundPadding!,
        sliver: current,
      );
    }
    if (foregroundDecoration != null) {
      current = DecoratedSliver(
        decoration: foregroundDecoration!,
        position: DecorationPosition.foreground,
        sliver: current,
      );
    }
    if (margin != null) {
      current = SliverPadding(
        padding: margin!,
        sliver: current,
      );
    }
    if (opacity != null) {
      current = SliverOpacity(
        opacity: opacity!,
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        sliver: current,
      );
    }
    if (ignoring != null) {
      current = SliverIgnorePointer(
        ignoring: ignoring!,
        sliver: current,
      );
    }
    if (offstage != null) {
      current = SliverOffstage(
        offstage: offstage!,
        sliver: current,
      );
    }
    if (safeArea) {
      current = SliverSafeArea(
        left: safeAreaLeft,
        top: safeAreaTop,
        right: safeAreaRight,
        bottom: safeAreaBottom,
        minimum: safeAreaMinimum,
        sliver: current,
      );
    }
    return current;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty<Decoration>('decoration', decoration, defaultValue: null));
    properties.add(
      DiagnosticsProperty<Decoration>('foregroundDecoration', foregroundDecoration, defaultValue: null),
    );
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin, defaultValue: null));
    properties.add(EnumProperty<Clip>('clipBehavior', clipBehavior, defaultValue: Clip.none));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>('foregroundPadding', foregroundPadding, defaultValue: null),
    );
    properties.add(DoubleProperty('opacity', opacity, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('ignoring', ignoring, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('offstage', offstage, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('safeArea', safeArea, defaultValue: false));
  }
}
