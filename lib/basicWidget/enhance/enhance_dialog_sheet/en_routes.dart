// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_dialog_sheet/en_display_feature_sub_screen.dart';


/// A general dialog route which allows for customization of the dialog popup.
///
/// It is used internally by [showGeneralDialog] or can be directly pushed
/// onto the [Navigator] stack to enable state restoration. See
/// [showGeneralDialog] for a state restoration app example.
///
/// This function takes a `pageBuilder`, which typically builds a dialog.
/// Content below the dialog is dimmed with a [ModalBarrier]. The widget
/// returned by the `builder` does not share a context with the location that
/// `showDialog` is originally called from. Use a [StatefulBuilder] or a
/// custom [StatefulWidget] if the dialog needs to update dynamically.
///
/// The `barrierDismissible` argument is used to indicate whether tapping on the
/// barrier will dismiss the dialog. It is `true` by default and cannot be `null`.
///
/// The `barrierColor` argument is used to specify the color of the modal
/// barrier that darkens everything below the dialog. If `null`, the default
/// color `Colors.black54` is used.
///
/// The `settings` argument define the settings for this route. See
/// [RouteSettings] for details.
///
/// {@template flutter.widgets.RawDialogRoute}
/// A [DisplayFeature] can split the screen into sub-screens. The closest one to
/// [anchorPoint] is used to render the content.
///
/// If no [anchorPoint] is provided, then [Directionality] is used:
///
///   * for [TextDirection.ltr], [anchorPoint] is `Offset.zero`, which will
///     cause the content to appear in the top-left sub-screen.
///   * for [TextDirection.rtl], [anchorPoint] is `Offset(double.maxFinite, 0)`,
///     which will cause the content to appear in the top-right sub-screen.
///
/// If no [anchorPoint] is provided, and there is no [Directionality] ancestor
/// widget in the tree, then the widget asserts during build in debug mode.
/// {@endtemplate}
///
/// See also:
///
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
///  * [showGeneralDialog], which is a way to display a RawDialogRoute.
///  * [showDialog], which is a way to display a DialogRoute.
///  * [showCupertinoDialog], which displays an iOS-style dialog.
class RawDialogRouteNew<T> extends PopupRoute<T> {
  /// A general dialog route which allows for customization of the dialog popup.
  RawDialogRouteNew({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    Color? barrierColor = const Color(0x80000000),
    String? barrierLabel,
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    super.settings,
    this.anchorPoint,
    this.right,
  })  : _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder;

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;
  final String? _barrierLabel;

  @override
  Color? get barrierColor => _barrierColor;
  final Color? _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder? _transitionBuilder;

  /// {@macro flutter.widgets.DisplayFeatureSubScreen.anchorPoint}
  final Offset? anchorPoint;

  final double? right;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: EnDisplayFeatureSubScreen(
        anchorPoint: anchorPoint,
        right: right,
        child: _pageBuilder(context, animation, secondaryAnimation),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder == null) {
      // Some default transition.
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
        ),
        child: child,
      );
    }
    return _transitionBuilder!(context, animation, secondaryAnimation, child);
  }
}

/// Displays a dialog above the current contents of the app.
///
/// This function allows for customization of aspects of the dialog popup.
///
/// This function takes a `pageBuilder` which is used to build the primary
/// content of the route (typically a dialog widget). Content below the dialog
/// is dimmed with a [ModalBarrier]. The widget returned by the `pageBuilder`
/// does not share a context with the location that [showGeneralDialog] is
/// originally called from. Use a [StatefulBuilder] or a custom
/// [StatefulWidget] if the dialog needs to update dynamically. The
/// `pageBuilder` argument can not be null.
///
/// The `context` argument is used to look up the [Navigator] for the
/// dialog. It is only used when the method is called. Its corresponding widget
/// can be safely removed from the tree before the dialog is closed.
///
/// The `useRootNavigator` argument is used to determine whether to push the
/// dialog to the [Navigator] furthest from or nearest to the given `context`.
/// By default, `useRootNavigator` is `true` and the dialog route created by
/// this method is pushed to the root navigator.
///
/// If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// dialog rather than just `Navigator.pop(context, result)`.
///
/// The `barrierDismissible` argument is used to determine whether this route
/// can be dismissed by tapping the modal barrier. This argument defaults
/// to false. If `barrierDismissible` is true, a non-null `barrierLabel` must be
/// provided.
///
/// The `barrierLabel` argument is the semantic label used for a dismissible
/// barrier. This argument defaults to `null`.
///
/// The `barrierColor` argument is the color used for the modal barrier. This
/// argument defaults to `Color(0x80000000)`.
///
/// The `transitionDuration` argument is used to determine how long it takes
/// for the route to arrive on or leave off the screen. This argument defaults
/// to 200 milliseconds.
///
/// The `transitionBuilder` argument is used to define how the route arrives on
/// and leaves off the screen. By default, the transition is a linear fade of
/// the page's contents.
///
/// The `routeSettings` will be used in the construction of the dialog's route.
/// See [RouteSettings] for more details.
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the dialog was closed.
///
/// ### State Restoration in Dialogs
///
/// Using this method will not enable state restoration for the dialog. In order
/// to enable state restoration for a dialog, use [Navigator.restorablePush]
/// or [Navigator.restorablePushNamed] with [RawDialogRoute].
///
/// For more information about state restoration, see [RestorationManager].
///
/// {@tool sample}
/// This sample demonstrates how to create a restorable dialog. This is
/// accomplished by enabling state restoration by specifying
/// [WidgetsApp.restorationScopeId] and using [Navigator.restorablePush] to
/// push [RawDialogRoute] when the button is tapped.
///
/// {@macro flutter.widgets.RestorationManager}
///
/// ** See code in examples/api/lib/widgets/routes/show_general_dialog.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
///  * [showDialog], which displays a Material-style dialog.
///  * [showCupertinoDialog], which displays an iOS-style dialog.
Future<T?> showGeneralDialogNew<T extends Object?>({
  required BuildContext context,
  required RoutePageBuilder pageBuilder,
  bool barrierDismissible = false,
  String? barrierLabel,
  Color barrierColor = const Color(0x80000000),
  Duration transitionDuration = const Duration(milliseconds: 200),
  RouteTransitionsBuilder? transitionBuilder,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  double? right,
}) {
  assert(pageBuilder != null);
  assert(useRootNavigator != null);
  assert(!barrierDismissible || barrierLabel != null);
  return Navigator.of(context, rootNavigator: useRootNavigator)
      .push<T>(RawDialogRouteNew<T>(
    pageBuilder: pageBuilder,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    transitionBuilder: transitionBuilder,
    settings: routeSettings,
    anchorPoint: anchorPoint,
    right: right,
  ));
}

