import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:social_fe_app/utils/dlog.dart';

/// 继承 CupertinoSwitch 的 开关
class NCupertinoSwitch extends StatelessWidget {
  const NCupertinoSwitch({
    super.key,
    this.width = 42,
    this.height = 28,
    this.fit = BoxFit.contain,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.trackColor,
    this.thumbColor,
    this.applyTheme,
    this.focusColor,
    this.onLabelColor,
    this.offLabelColor,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  /// 宽高比6:4(原来59:39)
  final double? width;

  final double? height;

  final BoxFit? fit;

  /// Whether this switch is on or off.
  final bool value;

  /// Called when the user toggles with switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled, which has a reduced opacity.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// CupertinoSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool>? onChanged;

  /// The color to use for the track when the switch is on.
  ///
  /// If null and [applyTheme] is false, defaults to [CupertinoColors.systemGreen]
  /// in accordance to native iOS behavior. Otherwise, defaults to
  /// [CupertinoThemeData.primaryColor].
  final Color? activeColor;

  /// The color to use for the track when the switch is off.
  ///
  /// Defaults to [CupertinoColors.secondarySystemFill] when null.
  final Color? trackColor;

  /// The color to use for the thumb of the switch.
  ///
  /// Defaults to [CupertinoColors.white] when null.
  final Color? thumbColor;

  /// The color to use for the focus highlight for keyboard interactions.
  ///
  /// Defaults to a slightly transparent [activeColor].
  final Color? focusColor;

  /// The color to use for the accessibility label when the switch is on.
  ///
  /// Defaults to [CupertinoColors.white] when null.
  final Color? onLabelColor;

  /// The color to use for the accessibility label when the switch is off.
  ///
  /// Defaults to [Color.fromARGB(255, 179, 179, 179)]
  /// (or [Color.fromARGB(255, 255, 255, 255)] in high contrast) when null.
  final Color? offLabelColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@template flutter.cupertino.CupertinoSwitch.applyTheme}
  /// Whether to apply the ambient [CupertinoThemeData].
  ///
  /// If true, the track uses [CupertinoThemeData.primaryColor] for the track
  /// when the switch is on.
  ///
  /// Defaults to [CupertinoThemeData.applyThemeToAll].
  /// {@endtemplate}
  final bool? applyTheme;

  /// {@template flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag behavior used to move the
  /// switch from on to off will begin at the position where the drag gesture won
  /// the arena. If set to [DragStartBehavior.down] it will begin at the position
  /// where a down event was first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for
  ///    the different behaviors.
  ///
  /// {@endtemplate}
  final DragStartBehavior dragStartBehavior;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: fit,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          trackColor: trackColor,
          thumbColor: thumbColor,
          applyTheme: applyTheme,
          focusColor: focusColor,
          onLabelColor: onLabelColor,
          offLabelColor: offLabelColor,
          focusNode: focusNode,
          onFocusChange: onFocusChange,
          autofocus: autofocus,
          dragStartBehavior: dragStartBehavior,
        ),
      ),
    );
  }
}
