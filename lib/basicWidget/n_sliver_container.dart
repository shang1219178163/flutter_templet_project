import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// sliver 族 Container
class NSliverContainer extends StatelessWidget {
  const NSliverContainer({
    super.key,
    required this.sliver,
    this.margin,
    this.padding,
    this.decoration,
    this.foregroundPadding,
    this.foregroundDecoration,
    this.opacity,
    this.ignoring,
    this.offstage,
  });

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 背景装饰器
  final Decoration? decoration;

  /// 前景装饰器内间距
  final EdgeInsetsGeometry? foregroundPadding;

  /// 前景装饰器
  final Decoration? foregroundDecoration;

  /// 透明度
  final double? opacity;

  /// 是否忽略事件
  final bool? ignoring;

  /// 是否 offstage
  final bool? offstage;

  /// 子组件
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    var current = sliver;

    /// padding
    if (padding != null) {
      current = SliverPadding(
        padding: padding!,
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

    if (foregroundPadding != null) {
      current = SliverPadding(
        padding: foregroundPadding!,
        sliver: current,
      );
    }

    /// decoration
    if (decoration != null) {
      current = DecoratedSliver(
        decoration: decoration!,
        sliver: current,
      );
    }

    /// margin（最外层）
    if (margin != null) {
      current = SliverPadding(
        padding: margin!,
        sliver: current,
      );
    }

    if (opacity != null) {
      current = SliverOpacity(
        opacity: opacity!,
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

    return current;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty<Decoration>('bg', decoration, defaultValue: null));
    properties.add(DiagnosticsProperty<Decoration>('fg', foregroundDecoration, defaultValue: null));
    properties.add(DiagnosticsProperty<double>('opacity', opacity, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('ignoring', ignoring, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('offstage', offstage, defaultValue: null));
  }
}
