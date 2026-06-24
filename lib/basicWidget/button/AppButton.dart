import 'package:flutter/material.dart';

enum AppButtonType { filled, filledTonal, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.type = AppButtonType.filled,
    this.style,
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
  final AppButtonType type;

  final ButtonStyle? style;

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
    ).merge(style);

    Widget button = SizedBox();
    switch (type) {
      case AppButtonType.filledTonal:
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
      case AppButtonType.outlined:
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
      case AppButtonType.text:
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
