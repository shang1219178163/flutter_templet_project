import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

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

  final BoxFit fit;

  /// Whether this switch is on or off.
  final bool value;

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
          activeTrackColor: activeColor,
          inactiveTrackColor: trackColor,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(EnumProperty<BoxFit>('fit', fit));
    properties.add(DiagnosticsProperty<bool>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onChanged', onChanged));
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('trackColor', trackColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(ColorProperty('focusColor', focusColor));
    properties.add(ColorProperty('onLabelColor', onLabelColor));
    properties.add(ColorProperty('offLabelColor', offLabelColor));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onFocusChange', onFocusChange));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<bool?>('applyTheme', applyTheme));
    properties.add(EnumProperty<DragStartBehavior>('dragStartBehavior', dragStartBehavior));
  }
}
