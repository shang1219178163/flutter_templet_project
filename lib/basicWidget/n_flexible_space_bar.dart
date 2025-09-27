// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';

/// The part of a Material Design [AppBar] that expands, collapses, and
/// stretches.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=mSc7qFzxHDw}
///
/// Most commonly used in the [SliverAppBar.flexibleSpace] field, a flexible
/// space bar expands and contracts as the app scrolls so that the [AppBar]
/// reaches from the top of the app to the top of the scrolling contents of the
/// app. When using [SliverAppBar.flexibleSpace], the [SliverAppBar.expandedHeight]
/// must be large enough to accommodate the [SliverAppBar.flexibleSpace] widget.
///
/// Furthermore is included functionality for stretch behavior. When
/// [SliverAppBar.stretch] is true, and your [ScrollPhysics] allow for
/// overscroll, this space will stretch with the overscroll.
///
/// The widget that sizes the [AppBar] must wrap it in the widget returned by
/// [NFlexibleSpaceBar.createSettings], to convey sizing information down to the
/// [NFlexibleSpaceBar].
///
/// {@tool dartpad}
/// This sample application demonstrates the different features of the
/// [NFlexibleSpaceBar] when used in a [SliverAppBar]. This app bar is configured
/// to stretch into the overscroll space, and uses the
/// [NFlexibleSpaceBar.stretchModes] to apply `fadeTitle`, `blurBackground` and
/// `zoomBackground`. The app bar also makes use of [CollapseMode.parallax] by
/// default.
///
/// ** See code in examples/api/lib/material/flexible_space_bar/flexible_space_bar.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [SliverAppBar], which implements the expanding and contracting.
///  * [AppBar], which is used by [SliverAppBar].
///  * <https://material.io/design/components/app-bars-top.html#behavior>

typedef FractionalBuilder = Widget Function(double t);

class NFlexibleSpaceBar extends StatefulWidget {
  /// Creates a flexible space bar.
  ///
  /// Most commonly used in the [AppBar.flexibleSpace] field.
  const NFlexibleSpaceBar({
    super.key,
    this.title,
    this.fixedSubtitle,
    this.titleIconBuilder,
    this.background,
    this.centerTitle,
    this.titlePadding,
    this.collapseMode = CollapseMode.parallax,
    this.stretchModes = const <StretchMode>[StretchMode.zoomBackground],
    this.expandedTitleScale = 1.5,
  })  : assert(expandedTitleScale >= 1);

  /// The primary contents of the flexible space bar when expanded.
  ///
  /// Typically a [Text] widget.
  final Widget? title;
  final Widget? fixedSubtitle;
  final FractionalBuilder? titleIconBuilder;

  /// Shown behind the [title] when expanded.
  ///
  /// Typically an [Image] widget with [Image.fit] set to [BoxFit.cover].
  final Widget? background;

  /// Whether the title should be centered.
  ///
  /// By default this property is true if the current target platform
  /// is [TargetPlatform.iOS] or [TargetPlatform.macOS], false otherwise.
  final bool? centerTitle;

  /// Collapse effect while scrolling.
  ///
  /// Defaults to [CollapseMode.parallax].
  final CollapseMode collapseMode;

  /// Stretch effect while over-scrolling.
  ///
  /// Defaults to include [StretchMode.zoomBackground].
  final List<StretchMode> stretchModes;

  /// Defines how far the [title] is inset from either the widget's
  /// bottom-left or its center.
  ///
  /// Typically this property is used to adjust how far the title is
  /// is inset from the bottom-left and it is specified along with
  /// [centerTitle] false.
  ///
  /// By default the value of this property is
  /// `EdgeInsetsDirectional.only(start: 72, bottom: 16)` if the title is
  /// not centered, `EdgeInsetsDirectional.only(start: 0, bottom: 16)` otherwise.
  final EdgeInsetsGeometry? titlePadding;

  /// Defines how much the title is scaled when the FlexibleSpaceBar is expanded
  /// due to the user scrolling downwards. The title is scaled uniformly on the
  /// x and y axes while maintaining its bottom-left position (bottom-center if
  /// [centerTitle] is true).
  ///
  /// Defaults to 1.5 and must be greater than 1.
  final double expandedTitleScale;

  @override
  State<NFlexibleSpaceBar> createState() => _NFlexibleSpaceBarState();
}

class _NFlexibleSpaceBarState extends State<NFlexibleSpaceBar> {
  bool _getEffectiveCenterTitle(ThemeData theme) {
    if (widget.centerTitle != null) {
      return widget.centerTitle!;
    }
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
  }

  Alignment _getTitleAlignment(bool effectiveCenterTitle) {
    if (effectiveCenterTitle) {
      return Alignment.bottomCenter;
    }
    final textDirection = Directionality.of(context);
    switch (textDirection) {
      case TextDirection.rtl:
        return Alignment.bottomRight;
      case TextDirection.ltr:
        return Alignment.bottomLeft;
    }
  }

  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0.0;
      case CollapseMode.parallax:
        final deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

        final children = <Widget>[];

        final deltaExtent = settings.maxExtent - settings.minExtent;

        // 0.0 -> Expanded
        // 1.0 -> Collapsed to toolbar
        final t = clampDouble(
            1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent,
            0.0,
            1.0);
        // print("=======build=======$t========");

        // background
        if (widget.background != null) {
          final double fadeStart =
              math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
          const fadeEnd = 1.0;
          assert(fadeStart <= fadeEnd);
          // If the min and max extent are the same, the app bar cannot collapse
          // and the content should be visible, so opacity = 1.
          final opacity = settings.maxExtent == settings.minExtent
              ? 1.0
              : 1.0 - Interval(fadeStart, fadeEnd).transform(t);
          var height = settings.maxExtent;

          // StretchMode.zoomBackground
          if (widget.stretchModes.contains(StretchMode.zoomBackground) &&
              constraints.maxHeight > height) {
            height = constraints.maxHeight;
          }
          children.add(Positioned(
            top: _getCollapsePadding(t, settings),
            left: 0.0,
            right: 0.0,
            height: height,
            child: Opacity(
              // IOS is relying on this semantics node to correctly traverse
              // through the app bar when it is collapsed.
              alwaysIncludeSemantics: true,
              opacity: opacity,
              child: widget.background,
            ),
          ));

          // StretchMode.blurBackground
          if (widget.stretchModes.contains(StretchMode.blurBackground) &&
              constraints.maxHeight > settings.maxExtent) {
            final blurAmount =
                (constraints.maxHeight - settings.maxExtent) / 10;
            children.add(Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: blurAmount,
                  sigmaY: blurAmount,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ));
          }
        }

        // title
        if (widget.title != null) {
          final theme = Theme.of(context);

          Widget? title;
          switch (theme.platform) {
            case TargetPlatform.iOS:
            case TargetPlatform.macOS:
              title = widget.title;
              break;
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.linux:
            case TargetPlatform.windows:
              title = Semantics(
                namesRoute: true,
                child: widget.title,
              );
              break;
          }

          // StretchMode.fadeTitle
          if (widget.stretchModes.contains(StretchMode.fadeTitle) &&
              constraints.maxHeight > settings.maxExtent) {
            final stretchOpacity = 1 -
                clampDouble((constraints.maxHeight - settings.maxExtent) / 100,
                    0.0, 1.0);
            title = Opacity(
              opacity: stretchOpacity,
              child: title,
            );
          }

          final opacity = settings.toolbarOpacity;
          if (opacity > 0.0) {
            var titleStyle = theme.primaryTextTheme.titleLarge!;
            titleStyle = titleStyle.copyWith(
              color: titleStyle.color!.withOpacity(opacity),
            );
            final effectiveCenterTitle = _getEffectiveCenterTitle(theme);
            final padding = widget.titlePadding ??
                EdgeInsetsDirectional.only(
                  start: effectiveCenterTitle ? 0.0 : 72.0,
                  bottom: 16.0,
                );
            final scaleValue =
                Tween<double>(begin: widget.expandedTitleScale, end: 1.0)
                    .transform(t);
            final scaleTransform = Matrix4.identity()
              ..scale(scaleValue, scaleValue, 1.0)
              ..translate(t * 30);
            final translateTransform = Matrix4.identity()
              ..translate(t * 30);
            final titleAlignment =
                _getTitleAlignment(effectiveCenterTitle);
            children.add(
              Container(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Transform(
                      alignment: titleAlignment,
                      transform: scaleTransform,
                      child: Align(
                        alignment: titleAlignment,
                        child: DefaultTextStyle(
                          style: titleStyle,
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return Container(
                                width: constraints.maxWidth / scaleValue,
                                alignment: titleAlignment,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 5,
                                  children: [
                                    title!,
                                    if (widget.titleIconBuilder != null)
                                      widget.titleIconBuilder!(t)
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    if (widget.fixedSubtitle != null)
                      Transform(
                          alignment: titleAlignment,
                          transform: translateTransform,
                          child: widget.fixedSubtitle!)
                  ],
                ),
              ),
            );
          }
        }

        return ClipRect(child: Stack(children: children));
      },
    );
  }
}
