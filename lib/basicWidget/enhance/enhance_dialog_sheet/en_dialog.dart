// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/enhance_dialog_sheet/en_routes.dart';


//   /// {@macro flutter.material.dialog.backgroundColor}
//   final Color? backgroundColor;

//   /// {@macro flutter.material.dialog.elevation}
//   final double? elevation;

//   /// {@macro flutter.material.dialog.shadowColor}
//   final Color? shadowColor;

//   /// {@macro flutter.material.dialog.surfaceTintColor}
//   final Color? surfaceTintColor;

//   /// The semantic label of the dialog used by accessibility frameworks to
//   /// announce screen transitions when the dialog is opened and closed.
//   ///
//   /// If this label is not provided, a semantic label will be inferred from the
//   /// [title] if it is not null. If there is no title, the label will be taken
//   /// from [MaterialLocalizations.dialogLabel].
//   ///
//   /// See also:
//   ///
//   ///  * [SemanticsConfiguration.namesRoute], for a description of how this
//   ///    value is used.
//   final String? semanticLabel;

//   /// {@macro flutter.material.dialog.insetPadding}
//   final EdgeInsets insetPadding;

//   /// {@macro flutter.material.dialog.clipBehavior}
//   final Clip clipBehavior;

//   /// {@macro flutter.material.dialog.shape}
//   final ShapeBorder? shape;

//   /// {@macro flutter.material.dialog.shape}
//   final AlignmentGeometry? alignment;

//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasMaterialLocalizations(context));
//     final ThemeData theme = Theme.of(context);

//     String? label = semanticLabel;
//     switch (theme.platform) {
//       case TargetPlatform.macOS:
//       case TargetPlatform.iOS:
//         break;
//       case TargetPlatform.android:
//       case TargetPlatform.fuchsia:
//       case TargetPlatform.linux:
//       case TargetPlatform.windows:
//         label ??= MaterialLocalizations.of(context).dialogLabel;
//     }

//     // The paddingScaleFactor is used to adjust the padding of Dialog
//     // children.
//     final double paddingScaleFactor = _paddingScaleFactor(MediaQuery.of(context).textScaleFactor);
//     final TextDirection? textDirection = Directionality.maybeOf(context);

//     Widget? titleWidget;
//     if (title != null) {
//       final EdgeInsets effectiveTitlePadding = titlePadding.resolve(textDirection);
//       titleWidget = Padding(
//         padding: EdgeInsets.only(
//           left: effectiveTitlePadding.left * paddingScaleFactor,
//           right: effectiveTitlePadding.right * paddingScaleFactor,
//           top: effectiveTitlePadding.top * paddingScaleFactor,
//           bottom: children == null ? effectiveTitlePadding.bottom * paddingScaleFactor : effectiveTitlePadding.bottom,
//         ),
//         child: DefaultTextStyle(
//           style: titleTextStyle ?? DialogTheme.of(context).titleTextStyle ?? theme.textTheme.titleLarge!,
//           child: Semantics(
//             // For iOS platform, the focus always lands on the title.
//             // Set nameRoute to false to avoid title being announce twice.
//             namesRoute: label == null && theme.platform != TargetPlatform.iOS,
//             container: true,
//             child: title,
//           ),
//         ),
//       );
//     }

//     Widget? contentWidget;
//     if (children != null) {
//       final EdgeInsets effectiveContentPadding = contentPadding.resolve(textDirection);
//       contentWidget = Flexible(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(
//             left: effectiveContentPadding.left * paddingScaleFactor,
//             right: effectiveContentPadding.right * paddingScaleFactor,
//             top: title == null ? effectiveContentPadding.top * paddingScaleFactor : effectiveContentPadding.top,
//             bottom: effectiveContentPadding.bottom * paddingScaleFactor,
//           ),
//           child: ListBody(children: children!),
//         ),
//       );
//     }

//     Widget dialogChild = IntrinsicWidth(
//       stepWidth: 56.0,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(minWidth: 280.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             if (title != null) titleWidget!,
//             if (children != null) contentWidget!,
//           ],
//         ),
//       ),
//     );

//     if (label != null) {
//       dialogChild = Semantics(
//         scopesRoute: true,
//         explicitChildNodes: true,
//         namesRoute: true,
//         label: label,
//         child: dialogChild,
//       );
//     }
//     return Dialog(
//       backgroundColor: backgroundColor,
//       elevation: elevation,
//       shadowColor: shadowColor,
//       surfaceTintColor: surfaceTintColor,
//       insetPadding: insetPadding,
//       clipBehavior: clipBehavior,
//       shape: shape,
//       alignment: alignment,
//       child: dialogChild,
//     );
//   }
// }

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

/// Displays a Material dialog above the current contents of the app, with
/// Material entrance and exit animations, modal barrier color, and modal
/// barrier behavior (dialog is dismissible with a tap on the barrier).
///
/// This function takes a `builder` which typically builds a [Dialog] widget.
/// Content below the dialog is dimmed with a [ModalBarrier]. The widget
/// returned by the `builder` does not share a context with the location that
/// [showDialog] is originally called from. Use a [StatefulBuilder] or a
/// custom [StatefulWidget] if the dialog needs to update dynamically.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the dialog. It is only used when the method is called. Its corresponding
/// widget can be safely removed from the tree before the dialog is closed.
///
/// The `barrierDismissible` argument is used to indicate whether tapping on the
/// barrier will dismiss the dialog. It is `true` by default and can not be `null`.
///
/// The `barrierColor` argument is used to specify the color of the modal
/// barrier that darkens everything below the dialog. If `null` the default color
/// `Colors.black54` is used.
///
/// The `useSafeArea` argument is used to indicate if the dialog should only
/// display in 'safe' areas of the screen not used by the operating system
/// (see [SafeArea] for more details). It is `true` by default, which means
/// the dialog will not overlap operating system areas. If it is set to `false`
/// the dialog will only be constrained by the screen size. It can not be `null`.
///
/// The `useRootNavigator` argument is used to determine whether to push the
/// dialog to the [Navigator] furthest from or nearest to the given `context`.
/// By default, `useRootNavigator` is `true` and the dialog route created by
/// this method is pushed to the root navigator. It can not be `null`.
///
/// see [RouteSettings] for details.
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// dialog rather than just `Navigator.pop(context, result)`.
///
/// Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the dialog was closed.
///
/// {@tool dartpad}
/// This sample demonstrates how to use [showDialog] to display a dialog box.
///
/// ** See code in examples/api/lib/material/dialog/show_dialog.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of [showDialog], as described in:
/// https://m3.material.io/components/dialogs/overview
///
/// ** See code in examples/api/lib/material/dialog/show_dialog.1.dart **
/// {@end-tool}
///
/// ### State Restoration in Dialogs
///
/// Using this method will not enable state restoration for the dialog. In order
/// to enable state restoration for a dialog, use [Navigator.restorablePush]
/// or [Navigator.restorablePushNamed] with [DialogRoute].
///
/// For more information about state restoration, see [RestorationManager].
///
/// {@tool dartpad}
/// This sample demonstrates how to create a restorable Material dialog. This is
/// accomplished by enabling state restoration by specifying
/// [MaterialApp.restorationScopeId] and using [Navigator.restorablePush] to
/// push [DialogRoute] when the button is tapped.
///
/// {@macro flutter.widgets.RestorationManager}
///
/// ** See code in examples/api/lib/material/dialog/show_dialog.2.dart **
/// {@end-tool}
///
/// See also:
///
///  * [AlertDialog], for dialogs that have a row of buttons below a body.
///  * [SimpleDialog], which handles the scrolling of the contents and does
///    not show buttons below its body.
///  * [Dialog], on which [SimpleDialog] and [AlertDialog] are based.
///  * [showCupertinoDialog], which displays an iOS-style dialog.
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
///  * <https://material.io/design/components/dialogs.html>
///  * <https://m3.material.io/components/dialogs>
Future<T?> showDialogNew<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  double? right = 0,
}) {
  assert(builder != null);
  assert(barrierDismissible != null);
  assert(useSafeArea != null);
  assert(useRootNavigator != null);
  assert(_debugIsActive(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).context,
  );

  return Navigator.of(context, rootNavigator: useRootNavigator)
      .push<T>(DialogRouteNew<T>(
    context: context,
    builder: builder,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    settings: routeSettings,
    themes: themes,
    anchorPoint: anchorPoint,
    right: right,
  ));
}

bool _debugIsActive(BuildContext context) {
  if (context is Element && !context.debugIsActive) {
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary('This BuildContext is no longer valid.'),
      ErrorDescription(
          'The showDialog function context parameter is a BuildContext that is no longer valid.'),
      ErrorHint(
        'This can commonly occur when the showDialog function is called after awaiting a Future. '
        'In this situation the BuildContext might refer to a widget that has already been disposed during the await. '
        'Consider using a parent context instead.',
      ),
    ]);
  }
  return true;
}

/// A dialog route with Material entrance and exit animations,
/// modal barrier color, and modal barrier behavior (dialog is dismissible
/// with a tap on the barrier).
///
/// It is used internally by [showDialog] or can be directly pushed
/// onto the [Navigator] stack to enable state restoration. See
/// [showDialog] for a state restoration app example.
///
/// This function takes a `builder` which typically builds a [Dialog] widget.
/// Content below the dialog is dimmed with a [ModalBarrier]. The widget
/// returned by the `builder` does not share a context with the location that
/// `showDialog` is originally called from. Use a [StatefulBuilder] or a
/// custom [StatefulWidget] if the dialog needs to update dynamically.
///
/// The `context` argument is used to look up
/// [MaterialLocalizations.modalBarrierDismissLabel], which provides the
/// modal with a localized accessibility label that will be used for the
/// modal's barrier. However, a custom `barrierLabel` can be passed in as well.
///
/// The `barrierDismissible` argument is used to indicate whether tapping on the
/// barrier will dismiss the dialog. It is `true` by default and cannot be `null`.
///
/// The `barrierColor` argument is used to specify the color of the modal
/// barrier that darkens everything below the dialog. If `null`, the default
/// color `Colors.black54` is used.
///
/// The `useSafeArea` argument is used to indicate if the dialog should only
/// display in 'safe' areas of the screen not used by the operating system
/// (see [SafeArea] for more details). It is `true` by default, which means
/// the dialog will not overlap operating system areas. If it is set to `false`
/// the dialog will only be constrained by the screen size. It can not be `null`.
///
/// The `settings` argument define the settings for this route. See
/// [RouteSettings] for details.
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// See also:
///
///  * [showDialog], which is a way to display a DialogRoute.
///  * [showCupertinoDialog], which displays an iOS-style dialog.
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
class DialogRouteNew<T> extends RawDialogRouteNew<T> {
  /// A dialog route with Material entrance and exit animations,
  /// modal barrier color, and modal barrier behavior (dialog is dismissible
  /// with a tap on the barrier).
  DialogRouteNew({
    required BuildContext context,
    required WidgetBuilder builder,
    CapturedThemes? themes,
    super.barrierColor = Colors.black54,
    super.barrierDismissible,
    String? barrierLabel,
    bool useSafeArea = true,
    super.settings,
    super.anchorPoint,
    super.right,
  })  : assert(barrierDismissible != null),
        super(
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            final Widget pageChild = Builder(builder: builder);
            Widget dialog = themes?.wrap(pageChild) ?? pageChild;
            if (useSafeArea) {
              dialog = SafeArea(child: dialog);
            }
            return pageChild;
          },
          barrierLabel: barrierLabel ??
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          transitionDuration: const Duration(milliseconds: 150),
          transitionBuilder: _buildMaterialDialogTransitions,
        );
}

double _paddingScaleFactor(double textScaleFactor) {
  final double clampedTextScaleFactor = clampDouble(textScaleFactor, 1.0, 2.0);
  // The final padding scale factor is clamped between 1/3 and 1. For example,
  // a non-scaled padding of 24 will produce a padding between 24 and 8.
  return lerpDouble(1.0, 1.0 / 3.0, clampedTextScaleFactor - 1.0)!;
}
