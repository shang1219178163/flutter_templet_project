import 'package:flutter/cupertino.dart';

/// sliver 族 Container
class NSliverContainer extends StatelessWidget {
  const NSliverContainer({
    super.key,
    required this.sliver,
    this.padding,
    this.margin,
    this.decoration,
    this.foregroundDecoration,
    this.opacity,
    this.ignoring,
    this.offstage,
  });

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;

  final double? opacity;
  final bool? ignoring;
  final bool? offstage;

  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    Widget child = sliver;

    /// padding
    if (padding != null) {
      child = SliverPadding(
        padding: padding!,
        sliver: child,
      );
    }

    if (foregroundDecoration != null) {
      child = DecoratedSliver(
        decoration: foregroundDecoration!,
        position: DecorationPosition.foreground,
        sliver: child,
      );
    }

    /// decoration
    if (decoration != null) {
      child = DecoratedSliver(
        decoration: decoration!,
        sliver: child,
      );
    }

    /// margin（最外层）
    if (margin != null) {
      child = SliverPadding(
        padding: margin!,
        sliver: child,
      );
    }

    if (opacity != null) {
      child = SliverOpacity(
        opacity: opacity!,
        sliver: child,
      );
    }

    if (ignoring != null) {
      child = SliverIgnorePointer(
        ignoring: ignoring!,
        sliver: child,
      );
    }

    if (offstage != null) {
      child = SliverOffstage(
        offstage: offstage!,
        sliver: child,
      );
    }

    return child;
  }
}
