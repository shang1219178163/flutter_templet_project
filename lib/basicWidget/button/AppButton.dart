import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/button/AppButtonTheme.dart';

enum AppButtonStyle { filled, filledTonal, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.style = AppButtonStyle.filled,
    this.fgColor,
    this.bgColor,
    this.fgColorDisabled,
    this.bgColorDisabled,
    // this.outlinedColor,
    // this.outlinedColorDisabled,
    this.radius = 4,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.isSemanticButton,
    this.iconAlignment = IconAlignment.start,
  });

  /// 按钮样式 filled, filledTonal, outlined, text
  final AppButtonStyle style;

  /// 前景色
  final Color? fgColor;

  /// 背景色
  final Color? bgColor;

  /// 前景色 禁用状态
  final Color? fgColorDisabled;

  /// 背景色 禁用状态
  final Color? bgColorDisabled;

  // /// 边框颜色
  // final Color? outlinedColor;
  //
  // /// 边框颜色 禁用状态
  // final Color? outlinedColorDisabled;

  /// 大于等于999 为椭圆
  final double radius;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final ValueChanged<bool>? onHover;

  final ValueChanged<bool>? onFocusChange;

  final Clip? clipBehavior;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool? isSemanticButton;

  final IconAlignment iconAlignment;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    final primary = themeData.colorScheme.primary;
    final onPrimary = themeData.colorScheme.onPrimary;

    final enable = onPressed != null;

    final appButtonTheme = Theme.of(context).extension<AppButtonTheme>();

    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size(40, 18),
      textStyle: const TextStyle(
        fontSize: 14,
      ),
      shape: radius >= 999
          ? StadiumBorder()
          : ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
    );

    var buttonStyleNew = buttonStyle;
    switch (style) {
      case AppButtonStyle.filledTonal:
        {
          final bgColor = isDark ? Colors.cyan : appButtonTheme?.bgColor?.withOpacity(0.1) ?? primary.withOpacity(0.1);
          final bgColorDisabled = isDark
              ? appButtonTheme?.bgColorDisabled ?? Color(0xFF1F1F1F)
              : appButtonTheme?.bgColorDisabled ?? Color(0xFFE0E0E0);

          final fgColor = isDark ? appButtonTheme?.fgColor ?? onPrimary : appButtonTheme?.bgColor ?? primary;
          final fgColorDisabled = isDark
              ? appButtonTheme?.fgColorDisabled ?? Colors.grey.shade600
              : appButtonTheme?.fgColorDisabled ?? Color(0xFF8E8E8E);

          buttonStyleNew = buttonStyle.copyWith(
            backgroundColor: stateValue(value: bgColor, disabledValue: bgColorDisabled),
            foregroundColor: stateValue(value: fgColor, disabledValue: fgColorDisabled),
            side: WidgetStateProperty.all(
              BorderSide(color: Colors.transparent, width: 1),
            ),
          );
        }
        break;
      case AppButtonStyle.outlined:
        {
          final bgColor = isDark ? Colors.transparent : appButtonTheme?.fgColor ?? onPrimary;
          final bgColorDisabled = isDark
              ? appButtonTheme?.bgColorDisabled ?? Colors.transparent
              : appButtonTheme?.bgColorDisabled ?? onPrimary;

          final fgColor = isDark ? appButtonTheme?.bgColor ?? primary : appButtonTheme?.bgColor ?? primary;
          final fgColorDisabled = isDark
              ? appButtonTheme?.fgColorDisabled ?? Colors.grey.shade600
              : appButtonTheme?.fgColorDisabled ?? Color(0xFF8E8E8E);

          buttonStyleNew = buttonStyle.copyWith(
            backgroundColor: stateValue(value: bgColor, disabledValue: bgColorDisabled),
            foregroundColor: stateValue(value: fgColor, disabledValue: fgColorDisabled),
            side: stateValue(
              value: BorderSide(color: fgColor, width: 1),
              disabledValue: BorderSide(color: bgColorDisabled, width: 1),
            ),
          );
        }
        break;
      case AppButtonStyle.text:
        {
          final bgColor = isDark ? onPrimary : onPrimary;
          final bgColorDisabled = isDark ? onPrimary : onPrimary;

          final fgColor = isDark ? appButtonTheme?.bgColor ?? onPrimary : appButtonTheme?.bgColor ?? primary;
          final fgColorDisabled = isDark ? Colors.grey.shade600 : Color(0xFF8E8E8E);
          buttonStyleNew = buttonStyle.copyWith(
            backgroundColor: stateValue(value: bgColor, disabledValue: bgColorDisabled),
            foregroundColor: stateValue(value: fgColor, disabledValue: fgColorDisabled),
            side: WidgetStateProperty.all(
              BorderSide(color: Colors.transparent, width: 1),
            ),
          );
        }
        break;
      default:
        {
          final bgColor = isDark ? appButtonTheme?.bgColor ?? primary : appButtonTheme?.bgColor ?? primary;
          final bgColorDisabled = isDark
              ? appButtonTheme?.bgColorDisabled ?? Color(0xFF1F1F1F)
              : appButtonTheme?.bgColorDisabled ?? Color(0xFFE0E0E0);

          final fgColor = isDark ? appButtonTheme?.fgColor ?? onPrimary : appButtonTheme?.fgColor ?? onPrimary;
          final fgColorDisabled = isDark
              ? appButtonTheme?.fgColorDisabled ?? Colors.grey.shade600
              : appButtonTheme?.fgColorDisabled ?? Color(0xFF8E8E8E);

          buttonStyleNew = buttonStyle.copyWith(
            backgroundColor: stateValue(value: bgColor, disabledValue: bgColorDisabled),
            foregroundColor: stateValue(value: fgColor, disabledValue: fgColorDisabled),
            side: WidgetStateProperty.all(
              BorderSide(color: Colors.transparent, width: 1),
            ),
          );
        }
        break;
    }
    return ElevatedButton(
      style: buttonStyleNew,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      iconAlignment: iconAlignment,
      child: child,
    );
  }

  WidgetStateProperty<T?>? stateValue<T>({
    required T value,
    required T disabledValue,
  }) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return disabledValue;
      }
      return value;
    });
  }
}

class AppButtonNew extends StatelessWidget {
  const AppButtonNew({
    super.key,
    this.style = AppButtonStyle.filled,
    this.radius = 4,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.isSemanticButton,
    this.iconAlignment = IconAlignment.start,
  });

  /// 按钮样式 filled, filledTonal, outlined, text
  final AppButtonStyle style;

  /// 大于等于999 为椭圆
  final double radius;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final ValueChanged<bool>? onHover;

  final ValueChanged<bool>? onFocusChange;

  final Clip? clipBehavior;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool? isSemanticButton;

  final IconAlignment iconAlignment;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size(40, 18),
      textStyle: const TextStyle(
        fontSize: 14,
      ),
      shape: radius >= 999
          ? StadiumBorder()
          : ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
    );

    Widget button = SizedBox();
    switch (style) {
      case AppButtonStyle.filledTonal:
        {
          button = FilledButton(
            style: buttonStyle,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            iconAlignment: iconAlignment,
            child: child,
          );
        }
        break;
      case AppButtonStyle.outlined:
        {
          button = OutlinedButton(
            style: buttonStyle,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            iconAlignment: iconAlignment,
            child: child,
          );
        }
        break;
      case AppButtonStyle.text:
        {
          button = TextButton(
            style: buttonStyle,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            iconAlignment: iconAlignment,
            child: child,
          );
        }
        break;
      default:
        {
          button = ElevatedButton(
            style: buttonStyle,
            onPressed: onPressed,
            onLongPress: onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            iconAlignment: iconAlignment,
            child: child,
          );
        }
        break;
    }
    return button;
  }
}
