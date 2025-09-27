// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_dialog_sheet/en_display_feature_sub_screen.dart';

const Duration _bottomSheetEnterDuration = Duration(milliseconds: 250);
const Duration _bottomSheetExitDuration = Duration(milliseconds: 200);
const Curve _modalBottomSheetCurve = Easing.legacyDecelerate;
const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;

/// A callback for when the user begins dragging the bottom sheet.
///
/// Used by [BottomSheet.onDragStart].
typedef BottomSheetDragStartHandler = void Function(DragStartDetails details);

/// A callback for when the user stops dragging the bottom sheet.
///
/// Used by [BottomSheet.onDragEnd].
typedef BottomSheetDragEndHandler = void Function(
  DragEndDetails details, {
  required bool isClosing,
});

// PERSISTENT BOTTOM SHEETS

// See scaffold.dart

// MODAL BOTTOM SHEETS
class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress, this.isScrollControlled);

  final double progress;
  final bool isScrollControlled;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      maxHeight: isScrollControlled
          ? constraints.maxHeight
          : constraints.maxHeight * 9.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _ModalBottomSheetNew<T> extends StatefulWidget {
  const _ModalBottomSheetNew({
    super.key,
    required this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.isScrollControlled = false,
    this.enableDrag = true,
  });

  final ModalBottomSheetRouteNew<T> route;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final bool enableDrag;

  @override
  _ModalBottomSheetNewState<T> createState() => _ModalBottomSheetNewState<T>();
}

class _ModalBottomSheetNewState<T> extends State<_ModalBottomSheetNew<T>> {
  ParametricCurve<double> animationCurve = _modalBottomSheetCurve;

  String _getRouteLabel(MaterialLocalizations localizations) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return localizations.dialogLabel;
    }
  }

  void handleDragStart(DragStartDetails details) {
    // Allow the bottom sheet to track the user's finger accurately.
    animationCurve = Curves.linear;
  }

  void handleDragEnd(DragEndDetails details, {bool? isClosing}) {
    // Allow the bottom sheet to animate smoothly from its current position.
    animationCurve = _BottomSheetSuspendedCurve(
      widget.route.animation!.value,
      curve: _modalBottomSheetCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final mediaQuery = MediaQuery.of(context);
    final localizations =
        MaterialLocalizations.of(context);
    final routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route.animation!,
      child: BottomSheet(
        animationController: widget.route._animationController,
        onClosing: () {
          if (widget.route.isCurrent) {
            Navigator.pop(context);
          }
        },
        builder: widget.route.builder,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        shape: widget.shape,
        clipBehavior: widget.clipBehavior,
        constraints: widget.constraints,
        enableDrag: widget.enableDrag,
        onDragStart: handleDragStart,
        onDragEnd: handleDragEnd,
      ),
      builder: (BuildContext context, Widget? child) {
        // Disable the initial animation when accessible navigation is on so
        // that the semantics are added to the tree at the correct time.
        final animationValue = animationCurve.transform(
          mediaQuery.accessibleNavigation ? 1.0 : widget.route.animation!.value,
        );
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: CustomSingleChildLayout(
              delegate: _ModalBottomSheetLayout(
                  animationValue, widget.isScrollControlled),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// A route that represents a Material Design modal bottom sheet.
///
/// {@template flutter.material.ModalBottomSheetRoute}
/// A modal bottom sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
///
/// A closely related widget is a persistent bottom sheet, which shows
/// information that supplements the primary content of the app without
/// preventing the user from interacting with the app. Persistent bottom sheets
/// can be created and displayed with the [showBottomSheet] function or the
/// [ScaffoldState.showBottomSheet] method.
///
/// The [isScrollControlled] parameter specifies whether this is a route for
/// a bottom sheet that will utilize [DraggableScrollableSheet]. Consider
/// setting this parameter to true if this bottom sheet has
/// a scrollable child, such as a [ListView] or a [GridView],
/// to have the bottom sheet be draggable.
///
/// The [isDismissible] parameter specifies whether the bottom sheet will be
/// dismissed when user taps on the scrim.
///
/// The [enableDrag] parameter specifies whether the bottom sheet can be
/// dragged up and down and dismissed by swiping downwards.
///
/// The [useSafeArea] parameter specifies whether a [SafeArea] is inserted. Defaults to false.
/// If false, no SafeArea is added and the top padding is consumed using [MediaQuery.removePadding].
///
/// The optional [backgroundColor], [elevation], [shape], [clipBehavior],
/// [constraints] and [transitionAnimationController]
/// parameters can be passed in to customize the appearance and behavior of
/// modal bottom sheets (see the documentation for these on [BottomSheet]
/// for more details).
///
/// The [transitionAnimationController] controls the bottom sheet's entrance and
/// exit animations. It's up to the owner of the controller to call
/// [AnimationController.dispose] when the controller is no longer needed.
///
/// The optional `settings` parameter sets the [RouteSettings] of the modal bottom sheet
/// sheet. This is particularly useful in the case that a user wants to observe
/// [PopupRoute]s within a [NavigatorObserver].
/// {@endtemplate}
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// See also:
///
///  * [showModalBottomSheet], which is a way to display a ModalBottomSheetRoute.
///  * [BottomSheet], which becomes the parent of the widget returned by the
///    function passed as the `builder` argument to [showModalBottomSheet].
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal bottom sheets.
///  * [DraggableScrollableSheet], creates a bottom sheet that grows
///    and then becomes scrollable once it reaches its maximum size.
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
///  * <https://material.io/design/components/sheets-bottom.html#modal-bottom-sheet>
class ModalBottomSheetRouteNew<T> extends PopupRoute<T> {
  /// A modal bottom sheet route.
  ModalBottomSheetRouteNew({
    required this.builder,
    this.capturedThemes,
    this.barrierLabel,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    required this.isScrollControlled,
    super.settings,
    this.transitionAnimationController,
    this.anchorPoint,
    this.right,
    this.useSafeArea = false,
  });

  /// A builder for the contents of the sheet.
  ///
  /// The bottom sheet will wrap the widget produced by this builder in a
  /// [Material] widget.
  final WidgetBuilder builder;

  /// Stores a list of captured [InheritedTheme]s that are wrapped around the
  /// bottom sheet.
  ///
  /// Consider setting this attribute when the [ModalBottomSheetRoute]
  /// is created through [Navigator.push] and its friends.
  final CapturedThemes? capturedThemes;

  /// Specifies whether this is a route for a bottom sheet that will utilize
  /// [DraggableScrollableSheet].
  ///
  /// Consider setting this parameter to true if this bottom sheet has
  /// a scrollable child, such as a [ListView] or a [GridView],
  /// to have the bottom sheet be draggable.
  final bool isScrollControlled;

  /// The bottom sheet's background color.
  ///
  /// Defines the bottom sheet's [Material.color].
  ///
  /// If this property is not provided, it falls back to [Material]'s default.
  final Color? backgroundColor;

  /// The z-coordinate at which to place this material relative to its parent.
  ///
  /// This controls the size of the shadow below the material.
  ///
  /// Defaults to 0, must not be negative.
  final double? elevation;

  /// The shape of the bottom sheet.
  ///
  /// Defines the bottom sheet's [Material.shape].
  ///
  /// If this property is not provided, it falls back to [Material]'s default.
  final ShapeBorder? shape;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defines the bottom sheet's [Material.clipBehavior].
  ///
  /// Use this property to enable clipping of content when the bottom sheet has
  /// a custom [shape] and the content can extend past this shape. For example,
  /// a bottom sheet with rounded corners and an edge-to-edge [Image] at the
  /// top.
  ///
  /// If this property is null, the [BottomSheetThemeData.clipBehavior] of
  /// [ThemeData.bottomSheetTheme] is used. If that's null, the behavior defaults to [Clip.none]
  /// will be [Clip.none].
  final Clip? clipBehavior;

  /// Defines minimum and maximum sizes for a [BottomSheet].
  ///
  /// Typically a bottom sheet will cover the entire width of its
  /// parent. Consider limiting the width by setting smaller constraints
  /// for large screens.
  ///
  /// If null, the ambient [ThemeData.bottomSheetTheme]'s
  /// [BottomSheetThemeData.constraints] will be used. If that
  /// is null, the bottom sheet's size will be constrained
  /// by its parent (usually a [Scaffold]).
  ///
  /// If constraints are specified (either in this property or in the
  /// theme), the bottom sheet will be aligned to the bottom-center of
  /// the available space. Otherwise, no alignment is applied.
  final BoxConstraints? constraints;

  /// Specifies the color of the modal barrier that darkens everything below the
  /// bottom sheet.
  ///
  /// Defaults to `Colors.black54` if not provided.
  final Color? modalBarrierColor;

  /// Specifies whether the bottom sheet will be dismissed
  /// when user taps on the scrim.
  ///
  /// If true, the bottom sheet will be dismissed when user taps on the scrim.
  ///
  /// Defaults to true.
  final bool isDismissible;

  /// Specifies whether the bottom sheet can be dragged up and down
  /// and dismissed by swiping downwards.
  ///
  /// If true, the bottom sheet can be dragged up and down and dismissed by
  /// swiping downwards.
  ///
  /// Defaults is true.
  final bool enableDrag;

  /// The animation controller that controls the bottom sheet's entrance and
  /// exit animations.
  ///
  /// The BottomSheet widget will manipulate the position of this animation, it
  /// is not just a passive observer.
  final AnimationController? transitionAnimationController;

  /// {@macro flutter.widgets.DisplayFeatureSubScreen.anchorPoint}
  final Offset? anchorPoint;

  final double? right;

  /// If useSafeArea is true, a [SafeArea] is inserted.
  ///
  /// If useSafeArea is false, the bottom sheet is aligned to the bottom of the page
  /// and isn't exposed to the top padding of the MediaQuery.
  ///
  /// Default is false.
  final bool useSafeArea;

  @override
  Duration get transitionDuration => _bottomSheetEnterDuration;

  @override
  Duration get reverseTransitionDuration => _bottomSheetExitDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    if (transitionAnimationController != null) {
      _animationController = transitionAnimationController;
      willDisposeAnimationController = false;
    } else {
      _animationController = BottomSheet.createAnimationController(navigator!);
    }
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget content = EnDisplayFeatureSubScreen(
      anchorPoint: anchorPoint,
      right: right,
      child: Builder(
        builder: (BuildContext context) {
          final sheetTheme =
              Theme.of(context).bottomSheetTheme;
          final defaults = Theme.of(context).useMaterial3
              ? _BottomSheetDefaultsM3(context)
              : const BottomSheetThemeData();
          return _ModalBottomSheetNew<T>(
            route: this,
            backgroundColor: backgroundColor ??
                sheetTheme.modalBackgroundColor ??
                sheetTheme.backgroundColor ??
                defaults.backgroundColor,
            elevation: elevation ??
                sheetTheme.modalElevation ??
                defaults.modalElevation ??
                sheetTheme.elevation,
            shape: shape,
            clipBehavior: clipBehavior,
            constraints: constraints,
            isScrollControlled: isScrollControlled,
            enableDrag: enableDrag,
          );
        },
      ),
    );

    // If useSafeArea is true, a SafeArea is inserted.
    // If useSafeArea is false, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    final bottomSheet = useSafeArea
        ? SafeArea(child: content)
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: content,
          );

    return capturedThemes?.wrap(bottomSheet) ?? bottomSheet;
  }
}

// TODO(guidezpl): Look into making this public. A copy of this class is in
//  scaffold.dart, for now, https://github.com/flutter/flutter/issues/51627
/// A curve that progresses linearly until a specified [startingPoint], at which
/// point [curve] will begin. Unlike [Interval], [curve] will not start at zero,
/// but will use [startingPoint] as the Y position.
///
/// For example, if [startingPoint] is set to `0.5`, and [curve] is set to
/// [Curves.easeOut], then the bottom-left quarter of the curve will be a
/// straight line, and the top-right quarter will contain the entire contents of
/// [Curves.easeOut].
///
/// This is useful in situations where a widget must track the user's finger
/// (which requires a linear animation), and afterwards can be flung using a
/// curve specified with the [curve] argument, after the finger is released. In
/// such a case, the value of [startingPoint] would be the progress of the
/// animation at the time when the finger was released.
///
/// The [startingPoint] and [curve] arguments must not be null.
class _BottomSheetSuspendedCurve extends ParametricCurve<double> {
  /// Creates a suspended curve.
  const _BottomSheetSuspendedCurve(
    this.startingPoint, {
    this.curve = Curves.easeOutCubic,
  });

  /// The progress value at which [curve] should begin.
  ///
  /// This defaults to [Curves.easeOutCubic].
  final double startingPoint;

  /// The curve to use when [startingPoint] is reached.
  final Curve curve;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    assert(startingPoint >= 0.0 && startingPoint <= 1.0);

    if (t < startingPoint) {
      return t;
    }

    if (t == 1.0) {
      return t;
    }

    final curveProgress = (t - startingPoint) / (1 - startingPoint);
    final transformed = curve.transform(curveProgress);
    return lerpDouble(startingPoint, 1, transformed)!;
  }

  @override
  String toString() {
    return '${describeIdentity(this)}($startingPoint, $curve)';
  }
}

/// Shows a modal Material Design bottom sheet.
///
/// {@macro flutter.material.ModalBottomSheetRoute}
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the bottom sheet. It is only used when the method is called. Its
/// corresponding widget can be safely removed from the tree before the bottom
/// sheet is closed.
///
/// The `useRootNavigator` parameter ensures that the root navigator is used to
/// display the [BottomSheet] when set to `true`. This is useful in the case
/// that a modal [BottomSheet] needs to be displayed above all other content
/// but the caller is inside another [Navigator].
///
/// Returns a `Future` that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the modal bottom sheet was closed.
///
/// {@tool dartpad}
/// This example demonstrates how to use [showModalBottomSheet] to display a
/// bottom sheet that obscures the content behind it when a user taps a button.
/// It also demonstrates how to close the bottom sheet using the [Navigator]
/// when a user taps on a button inside the bottom sheet.
///
/// ** See code in examples/api/lib/material/bottom_sheet/show_modal_bottom_sheet.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of [showModalBottomSheet], as described in:
/// https://m3.material.io/components/bottom-sheets/overview
///
/// ** See code in examples/api/lib/material/bottom_sheet/show_modal_bottom_sheet.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [BottomSheet], which becomes the parent of the widget returned by the
///    function passed as the `builder` argument to [showModalBottomSheet].
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal bottom sheets.
///  * [DraggableScrollableSheet], creates a bottom sheet that grows
///    and then becomes scrollable once it reaches its maximum size.
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
///  * <https://material.io/design/components/sheets-bottom.html#modal-bottom-sheet>
Future<T?> showModalBottomSheetNew<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
  double? right = 0,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(ModalBottomSheetRouteNew<T>(
    builder: builder,
    capturedThemes:
        InheritedTheme.capture(from: context, to: navigator.context),
    isScrollControlled: isScrollControlled,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    constraints: constraints,
    isDismissible: isDismissible,
    modalBarrierColor:
        barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
    enableDrag: enableDrag,
    settings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    anchorPoint: anchorPoint,
    right: right,
    useSafeArea: useSafeArea,
  ));
}

// BEGIN GENERATED TOKEN PROPERTIES - BottomSheet

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_143

class _BottomSheetDefaultsM3 extends BottomSheetThemeData {
  const _BottomSheetDefaultsM3(this.context)
      : super(
          elevation: 1.0,
          modalElevation: 1.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.0))),
        );

  final BuildContext context;

  @override
  Color? get backgroundColor => Theme.of(context).colorScheme.surface;

  @override
  Color? get surfaceTintColor => Theme.of(context).colorScheme.surfaceTint;
}

// END GENERATED TOKEN PROPERTIES - BottomSheet
