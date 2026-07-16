import 'package:flutter/material.dart';

/// 按钮样式类型。
enum NButtonType {
  /// 实心填充按钮；Material 3 对应 [FilledButton]，Material 2 回退为 [ElevatedButton]。
  filled,

  /// 色调填充按钮；Material 3 对应 [FilledButton.tonal]，Material 2 回退为 [ElevatedButton]。
  filledTonal,

  /// 描边按钮，对应 [OutlinedButton]。
  outlined,

  /// 文字按钮，对应 [TextButton]。
  text,

  /// 悬浮提升按钮，对应 [ElevatedButton]。
  elevated,

  floating,
}

/// 统一封装 Material 按钮，按 [type] 映射到 SDK 对应组件。
class NButton extends StatelessWidget {
  const NButton({
    super.key,
    this.type = NButtonType.filled,
    this.constraints,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.radius = 12,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    this.isSemanticButton,
    this.iconAlignment = IconAlignment.start,
    this.tooltip,
  });

  /// 按钮样式类型。
  final NButtonType type;

  final BoxConstraints? constraints;

  final Size? minimumSize;
  final Size? fixedSize;
  final Size? maximumSize;

  /// 点击回调，为 null 时按钮禁用。
  final VoidCallback? onPressed;

  /// 长按回调。
  final VoidCallback? onLongPress;

  /// 指针进入或离开按钮区域时回调。
  final ValueChanged<bool>? onHover;

  /// 焦点变化时回调。
  final ValueChanged<bool>? onFocusChange;

  /// 自定义按钮样式。
  final ButtonStyle? style;

  /// 内边距
  final EdgeInsets? padding;

  /// 大于等于999 为椭圆
  final double radius;

  /// 焦点节点。
  final FocusNode? focusNode;

  /// 是否自动获取焦点。
  final bool autofocus;

  /// 子组件裁剪方式。
  final Clip? clipBehavior;

  /// 按钮状态控制器。
  final MaterialStatesController? statesController;

  /// 是否为语义化按钮，仅 [NButtonType.text] 生效。
  final bool? isSemanticButton;

  /// 图标相对文字的对齐方式，带 [icon] 时生效。
  final IconAlignment iconAlignment;

  /// 悬停或长按时显示的提示文案。
  final String? tooltip;

  /// 按钮内容，与 [label] 二选一；带 [icon] 时作为 label 的备选。
  final Widget? child;

  /// 按钮文字，与 [child] 二选一；带 [icon] 时优先作为 label。
  final Widget? label;

  /// 按钮图标，非 null 时使用 SDK 对应的 `.icon` 构造。
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    var child = buildButton(context);
    if (tooltip == null) {
      return child;
    }

    if (constraints != null) {
      child = ConstrainedBox(constraints: constraints!, child: child);
    }
    return Tooltip(message: tooltip!, child: child);
  }

  Widget buildButton(BuildContext context) {
    final themeData = Theme.of(context);
    final useMaterial3 = themeData.useMaterial3;
    final colorScheme = themeData.colorScheme;

    final content = child ?? label!;
    final buttonLabel = label ?? child!;

    final sideColor = [NButtonType.outlined].contains(type) ? colorScheme.primary : Colors.transparent;
    var styleNew = style ??
        FilledButton.styleFrom(
          // minimumSize: Size(40, 18),
          maximumSize: maximumSize,
          minimumSize: minimumSize,
          fixedSize: fixedSize,
          padding: padding,
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'PingFang SC',
          ),
          side: BorderSide(color: sideColor, width: 1),
          shape: radius >= 999
              ? StadiumBorder()
              : ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
        );

    switch (type) {
      case NButtonType.elevated:
        {
          return buildElevatedButton(style: styleNew, content: content, label: buttonLabel);
        }
      // case NButtonType.filled:
      //   {
      //     if (!useMaterial3) {
      //       return buildElevatedButton(style: styleNew, content: content, label: buttonLabel);
      //     }
      //     return buildFilledButton(style: styleNew, content: content, label: buttonLabel);
      //   }
      case NButtonType.filledTonal:
        {
          if (!useMaterial3) {
            return buildElevatedButton(style: styleNew, content: content, label: buttonLabel);
          }
          return buildFilledButtonTonal(style: styleNew, content: content, label: buttonLabel);
        }
      case NButtonType.outlined:
        {
          return buildOutlinedButton(style: styleNew, content: content, label: buttonLabel);
        }
      case NButtonType.text:
        {
          return buildTextButton(style: styleNew, content: content, label: buttonLabel);
        }
      case NButtonType.floating:
        {
          return buildFloatingActionButton(style: styleNew, content: content, label: buttonLabel);
        }
      default:
        {
          if (!useMaterial3) {
            return buildElevatedButton(style: styleNew, content: content, label: buttonLabel);
          }
          return buildFilledButton(style: styleNew, content: content, label: buttonLabel);
        }
    }
  }

  Widget buildElevatedButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        iconAlignment: iconAlignment,
        child: content,
      );
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      icon: icon,
      label: label,
      iconAlignment: iconAlignment,
    );
  }

  Widget buildFilledButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return FilledButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        iconAlignment: iconAlignment,
        child: content,
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      icon: icon,
      label: label,
      iconAlignment: iconAlignment,
    );
  }

  Widget buildFilledButtonTonal({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return FilledButton.tonal(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        child: content,
      );
    }
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      icon: icon,
      label: label,
      iconAlignment: iconAlignment,
    );
  }

  Widget buildOutlinedButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return OutlinedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        iconAlignment: iconAlignment,
        child: content,
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      icon: icon,
      label: label,
      iconAlignment: iconAlignment,
    );
  }

  Widget buildTextButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return TextButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        iconAlignment: iconAlignment,
        child: content,
      );
    }
    return TextButton.icon(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      icon: icon,
      label: label,
      iconAlignment: iconAlignment,
    );
  }

  Widget buildFloatingActionButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    final shape = radius >= 999
        ? StadiumBorder()
        : ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          );
    return Container(
      width: fixedSize?.width,
      height: fixedSize?.height,
      constraints: constraints ??
          BoxConstraints(
            minWidth: minimumSize?.width ?? 0,
            minHeight: minimumSize?.height ?? 0,
            maxWidth: maximumSize?.width ?? double.infinity,
            maxHeight: maximumSize?.height ?? double.infinity,
          ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        focusNode: focusNode,
        autofocus: autofocus,
        shape: shape,
        extendedPadding: padding,
        icon: icon == null ? null : (iconAlignment == IconAlignment.start ? icon : label),
        label: iconAlignment == IconAlignment.start ? label : (icon ?? SizedBox()),
      ),
    );
  }
}
