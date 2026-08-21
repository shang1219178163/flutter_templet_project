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

  /// 轻度阴影，提升按钮，对应 [ElevatedButton]。
  elevated,

  /// 重度阴影，悬浮提升按钮，对应 [FloatingActionButton]。
  floating,

  /// 图标按钮，对应 [IconButton]。
  icon,
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
    this.side,
    this.primary,
    this.gradient,
    this.disabledGradient,
    this.textStyle,
    this.disabledTextStyle,
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

  /// 外层约束，包在按钮外层 [ConstrainedBox] 上。
  final BoxConstraints? constraints;

  /// 按钮最小尺寸。
  final Size? minimumSize;

  /// 按钮固定尺寸。
  final Size? fixedSize;

  /// 按钮最大尺寸。
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

  final BorderSide? side;

  /// 主题色；为空时取 [ColorScheme.primary]，可覆盖各类按钮主题色。
  final Color? primary;

  /// 渐进色背景；非 null 时覆盖实心背景色（描边/文字按钮不生效）。
  final Gradient? gradient;

  /// 禁用态渐进色背景；视觉禁用已改为整体透明度，此字段保留兼容，当前不参与绘制。
  final Gradient? disabledGradient;

  /// 启用态文字样式；其中 [TextStyle.color] 会同步到 foregroundColor。
  final TextStyle? textStyle;

  /// 禁用态文字样式；视觉禁用已改为整体透明度，此字段保留兼容，当前不参与绘制。
  final TextStyle? disabledTextStyle;

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

  /// 是否处于禁用态（[onPressed] 为 null）。
  bool get isDisabled => onPressed == null;

  /// 当前类型是否支持渐进色背景（描边/文字按钮不支持）。
  bool get supportsGradientType => ![NButtonType.outlined, NButtonType.text].contains(type);

  /// 当前应绘制的渐进色；描边/文字按钮恒为 null。禁用态与启用态使用同一渐变。
  Gradient? get effectiveGradient {
    if (!supportsGradientType) {
      return null;
    }
    return gradient;
  }

  /// 是否使用渐进色背景绘制。
  bool get canUseGradient => effectiveGradient != null;

  /// 实际生效的文字样式；未传 [textStyle] 时使用默认样式。
  TextStyle get effectiveTextStyle =>
      textStyle ??
      const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'PingFang SC',
      );

  /// 启用态前景色；渐进色背景且未指定文字色时默认白色。
  Color? get foregroundColor => effectiveTextStyle.color ?? (canUseGradient ? Colors.white : null);

  /// 禁用态前景色（保留 API）；视觉禁用统一由外层透明度处理，不再单独改色。
  Color? get disabledForegroundColor => disabledTextStyle?.color ?? foregroundColor;

  /// 实际主题色；未传 [primary] 时使用 [ColorScheme.primary]。
  Color resolvePrimary(ColorScheme colorScheme) => primary ?? colorScheme.primary;

  /// 视觉上始终按启用态交给 Material；真正禁用由外层拦截点击 + 透明度表达。
  VoidCallback get visualOnPressed => onPressed ?? _visualNoop;

  static void _visualNoop() {}

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final useMaterial3 = themeData.useMaterial3;
    final colorScheme = themeData.colorScheme;
    final effectivePrimary = resolvePrimary(colorScheme);
    final themedColorScheme = colorScheme.copyWith(primary: effectivePrimary);
    var child = buildButtonByType(
      useMaterial3: useMaterial3,
      primary: effectivePrimary,
      onPrimary: themedColorScheme.onPrimary,
    );
    if (canUseGradient) {
      child = DecoratedBox(
        decoration: ShapeDecoration(
          gradient: effectiveGradient,
          shape: buttonShape,
        ),
        child: child,
      );
    }
    if (constraints != null) {
      child = ConstrainedBox(constraints: constraints!, child: child);
    }
    if (tooltip != null) {
      child = Tooltip(message: tooltip!, child: child);
    }
    // 禁用态 UI 与启用态相同，仅整体透明度 0.5
    if (isDisabled) {
      child = IgnorePointer(
        child: Opacity(opacity: 0.4, child: child),
      );
    }
    // 用 Theme 覆盖各类 Material 按钮的 primary 主题色
    return Theme(
      data: themeData.copyWith(
        colorScheme: themedColorScheme,
        floatingActionButtonTheme: themeData.floatingActionButtonTheme.copyWith(
          backgroundColor: primary == null ? null : effectivePrimary,
        ),
      ),
      child: child,
    );
  }

  /// 按钮外形；[radius] >= 999 时图标为圆形，其余为胶囊形。
  OutlinedBorder get buttonShape {
    if (radius >= 999) {
      final sideNew = side ?? BorderSide(color: Colors.transparent);
      return type == NButtonType.icon ? CircleBorder(side: sideNew) : StadiumBorder(side: sideNew);
    }
    return ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// 按 [type] 创建对应 SDK 按钮。
  Widget buildButtonByType({
    required bool useMaterial3,
    required Color primary,
    required Color onPrimary,
  }) {
    switch (type) {
      case NButtonType.filled:
        {
          final buttonStyle = buildFilledStyle(primary);
          if (useMaterial3) {
            return buildFilledButton(style: buttonStyle, content: resolveContent(), label: resolveLabel());
          }
          return buildElevatedButton(style: buttonStyle, content: resolveContent(), label: resolveLabel());
        }
      case NButtonType.filledTonal:
        {
          final buttonStyle = buildFilledTonalStyle(primary);
          if (useMaterial3) {
            return buildFilledButtonTonal(style: buttonStyle, content: resolveContent(), label: resolveLabel());
          }
          return buildElevatedButton(style: buttonStyle, content: resolveContent(), label: resolveLabel());
        }
      case NButtonType.outlined:
        {
          final buttonStyle = buildOutlinedStyle(primary);
          return buildOutlinedButton(style: buttonStyle, content: resolveContent(), label: resolveLabel());
        }
      case NButtonType.text:
        {
          final buttonStyle = buildTextStyle(primary);
          return buildTextButton(style: buttonStyle, content: resolveContent(), label: resolveLabel());
        }
      case NButtonType.elevated:
        {
          final buttonStyle = buildElevatedStyle(primary);
          return buildElevatedButton(style: buttonStyle, content: resolveContent(), label: resolveLabel());
        }
      case NButtonType.floating:
        {
          final buttonStyle = buildFloatingStyle(primary, onPrimary);
          return buildFloatingActionButton(style: buttonStyle, content: resolveContent(), label: resolveLabel());
        }
      case NButtonType.icon:
        {
          final buttonStyle = buildIconStyle(primary);
          return buildIconButton(style: buttonStyle, content: resolveIconContent());
        }
    }
  }

  /// 解析普通按钮内容，优先 [child]，其次 [label]。
  Widget resolveContent() => child ?? label!;

  /// 解析带图标按钮的 label，优先 [label]，其次 [child] / [icon]。
  Widget resolveLabel() => label ?? child ?? icon!;

  /// 解析图标按钮内容，优先 [icon]，其次 [child] / [label]。
  Widget resolveIconContent() => icon ?? child ?? label!;

  /// 合并公共尺寸、圆角、点击热区样式。
  ButtonStyle mergeCommonSizeStyle(ButtonStyle baseStyle) {
    return baseStyle.merge(
      ButtonStyle(
        maximumSize: maximumSize == null ? null : WidgetStatePropertyAll(maximumSize),
        minimumSize: minimumSize == null ? null : WidgetStatePropertyAll(minimumSize),
        fixedSize: fixedSize == null ? null : WidgetStatePropertyAll(fixedSize),
        padding: padding == null ? null : WidgetStatePropertyAll(padding),
        shape: WidgetStatePropertyAll(buttonShape),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  /// 合并公共文字色 / 图标色；[includeIconColor] 为 true 时同步写入 iconColor。
  /// 禁用态颜色与启用态一致（外层 Opacity 表达禁用）。
  ButtonStyle mergeForegroundStyle(
    ButtonStyle baseStyle, {
    bool includeIconColor = false,
    OutlinedBorder? shape,
    BorderSide? enabledSide,
    Color? fallbackForeground,
  }) {
    final resolvedForeground = foregroundColor ?? fallbackForeground;
    return baseStyle.merge(
      ButtonStyle(
        textStyle: WidgetStatePropertyAll(effectiveTextStyle),
        foregroundColor: resolvedForeground == null ? null : WidgetStatePropertyAll(resolvedForeground),
        iconColor: includeIconColor && resolvedForeground != null ? WidgetStatePropertyAll(resolvedForeground) : null,
        side: enabledSide == null ? null : WidgetStatePropertyAll(enabledSide),
        shape: shape == null ? null : WidgetStatePropertyAll(shape),
      ),
    );
  }

  /// 合并主题色到背景；仅在显式传入 [primary] 且非渐进色时生效。
  ButtonStyle mergePrimaryBackgroundStyle(ButtonStyle baseStyle, Color primary) {
    if (canUseGradient || this.primary == null) {
      return baseStyle;
    }
    return baseStyle.merge(
      ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(primary),
      ),
    );
  }

  /// 渐进色时去掉组件自带背景，露出外层 [DecoratedBox]。
  ButtonStyle mergeGradientTransparentStyle(ButtonStyle baseStyle) {
    if (!canUseGradient) {
      return baseStyle;
    }
    return baseStyle.merge(
      const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }

  /// 构建 [NButtonType.filled] 样式。
  ButtonStyle buildFilledStyle(Color primary) {
    var buttonStyle = style ?? FilledButton.styleFrom();
    buttonStyle = mergeCommonSizeStyle(buttonStyle);
    buttonStyle = mergeForegroundStyle(buttonStyle);
    buttonStyle = mergePrimaryBackgroundStyle(buttonStyle, primary);
    buttonStyle = mergeGradientTransparentStyle(buttonStyle);
    return buttonStyle;
  }

  /// 构建 [NButtonType.filledTonal] 样式。
  ///
  /// Material tonal：浅色底 + 主题色字；显式 [primary] 时底为 primary 16% 透明，字为 primary。
  ButtonStyle buildFilledTonalStyle(Color primary) {
    var buttonStyle = style ?? FilledButton.styleFrom();
    buttonStyle = mergeCommonSizeStyle(buttonStyle);
    buttonStyle = mergeForegroundStyle(
      buttonStyle,
      fallbackForeground: this.primary == null ? null : primary,
    );
    buttonStyle = mergePrimaryBackgroundStyle(buttonStyle, primary.withOpacity(0.16));
    buttonStyle = mergeGradientTransparentStyle(buttonStyle);
    return buttonStyle;
  }

  /// 构建 [NButtonType.outlined] 样式，描边色与前景色取 [primary]。
  ButtonStyle buildOutlinedStyle(Color primary) {
    var buttonStyle = style ?? OutlinedButton.styleFrom();
    buttonStyle = mergeCommonSizeStyle(buttonStyle);
    buttonStyle = mergeForegroundStyle(
      buttonStyle,
      enabledSide: BorderSide(color: primary, width: 1),
      shape: buttonShape,
      fallbackForeground: primary,
    );
    return buttonStyle;
  }

  /// 构建 [NButtonType.text] 样式。
  ButtonStyle buildTextStyle(Color primary) {
    var buttonStyle = style ?? TextButton.styleFrom();
    buttonStyle = mergeCommonSizeStyle(buttonStyle);
    buttonStyle = mergeForegroundStyle(buttonStyle, fallbackForeground: primary);
    return buttonStyle;
  }

  /// 构建 [NButtonType.elevated] 样式。
  ///
  /// Material 3：surface 底 + primary 字 + 阴影，不把 primary 当作填充色。
  ButtonStyle buildElevatedStyle(Color primary) {
    var buttonStyle = style ??
        ElevatedButton.styleFrom(
          elevation: 1,
        );
    buttonStyle = mergeCommonSizeStyle(buttonStyle);
    buttonStyle = mergeForegroundStyle(buttonStyle, fallbackForeground: primary);
    buttonStyle = mergeGradientTransparentStyle(buttonStyle);
    return buttonStyle;
  }

  /// 构建 [NButtonType.floating] 样式；启用态字色为 [onPrimary]。
  ButtonStyle buildFloatingStyle(Color primary, Color onPrimary) {
    var buttonStyle = style ?? const ButtonStyle();
    buttonStyle = mergeCommonSizeStyle(buttonStyle);
    buttonStyle = mergeForegroundStyle(buttonStyle, fallbackForeground: onPrimary);
    buttonStyle = mergePrimaryBackgroundStyle(buttonStyle, primary);
    buttonStyle = mergeGradientTransparentStyle(buttonStyle);
    return buttonStyle;
  }

  /// 构建 [NButtonType.icon] 样式，同时写入 iconColor。
  ButtonStyle buildIconStyle(Color primary) {
    var buttonStyle = style ?? IconButton.styleFrom();
    buttonStyle = mergeCommonSizeStyle(buttonStyle);
    buttonStyle = mergeForegroundStyle(
      buttonStyle,
      includeIconColor: true,
      fallbackForeground: primary,
    );
    buttonStyle = mergeGradientTransparentStyle(buttonStyle);
    return buttonStyle;
  }

  /// 构建 [ElevatedButton]，有 [icon] 时走 `.icon` 构造。
  Widget buildElevatedButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return ElevatedButton(
        onPressed: visualOnPressed,
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
      onPressed: visualOnPressed,
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

  /// 构建 [FilledButton]，有 [icon] 时走 `.icon` 构造。
  Widget buildFilledButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return FilledButton(
        onPressed: visualOnPressed,
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
      onPressed: visualOnPressed,
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

  /// 构建 [FilledButton.tonal]，有 [icon] 时走 `.tonalIcon` 构造。
  Widget buildFilledButtonTonal({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return FilledButton.tonal(
        onPressed: visualOnPressed,
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
      onPressed: visualOnPressed,
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

  /// 构建 [OutlinedButton]，有 [icon] 时走 `.icon` 构造。
  Widget buildOutlinedButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return OutlinedButton(
        onPressed: visualOnPressed,
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
      onPressed: visualOnPressed,
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

  /// 构建 [TextButton]，有 [icon] 时走 `.icon` 构造。
  Widget buildTextButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    if (icon == null) {
      return TextButton(
        onPressed: visualOnPressed,
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
      onPressed: visualOnPressed,
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

  /// 构建 [FloatingActionButton.extended]，前景色从 [style] 解析。
  Widget buildFloatingActionButton({
    required ButtonStyle? style,
    required Widget content,
    required Widget label,
  }) {
    final foregroundColor = style?.foregroundColor?.resolve(const <WidgetState>{});
    final extendedTextStyle = style?.textStyle?.resolve(const <WidgetState>{});
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
        heroTag: null,
        onPressed: visualOnPressed,
        focusNode: focusNode,
        autofocus: autofocus,
        backgroundColor:
            canUseGradient ? Colors.transparent : (style?.backgroundColor?.resolve(const <WidgetState>{}) ?? primary),
        foregroundColor: foregroundColor,
        elevation: canUseGradient ? 0 : null,
        focusElevation: canUseGradient ? 0 : null,
        hoverElevation: canUseGradient ? 0 : null,
        highlightElevation: canUseGradient ? 0 : null,
        shape: buttonShape,
        extendedPadding: padding,
        extendedTextStyle: extendedTextStyle,
        icon: icon == null ? null : (iconAlignment == IconAlignment.start ? icon : label),
        label: iconAlignment == IconAlignment.start ? label : (icon ?? const SizedBox()),
      ),
    );
  }

  /// 构建 [IconButton]，并通过 [IconTheme] 同步图标颜色。
  Widget buildIconButton({
    required ButtonStyle? style,
    required Widget content,
  }) {
    final foregroundColor =
        style?.foregroundColor?.resolve(const <WidgetState>{}) ?? style?.iconColor?.resolve(const <WidgetState>{});
    return IconButton(
      onPressed: visualOnPressed,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      color: foregroundColor,
      disabledColor: foregroundColor,
      icon: IconTheme.merge(
        data: IconThemeData(color: foregroundColor),
        child: content,
      ),
    );
  }
}
