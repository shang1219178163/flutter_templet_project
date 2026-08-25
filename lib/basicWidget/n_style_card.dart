import 'package:flutter/material.dart';

/// shape 预设
enum ShapeKind { none, rounded, stadium }

/// clipBehavior 含 null
enum ClipKind { nil, none, hardEdge, antiAlias, antiAliasWithSaveLayer }

/// systemOverlayStyle 预设
enum OverlayKind { none, light, dark }

/// 统一风格卡片：渐变顶条、圆角描边、标题区 + 内容。
class NStyleCard extends StatelessWidget {
  const NStyleCard({
    super.key,
    required this.icon,
    this.title = '',
    this.subtitle,
    this.trailing,
    this.header,
    required this.child,
    this.footer,
  });

  /// 左上角图标。
  final Widget icon;

  /// 主色标题。
  final String title;

  /// 副标题，等宽展示参数名。
  final String? subtitle;

  /// 标题行右侧，如分段控件。
  final Widget? trailing;

  /// 若传入则替代 [title] / [subtitle] 文本。
  final Widget? header;

  /// 内边距内的主内容。
  final Widget child;

  /// 卡片内、内边距外的底部内容。
  final Widget? footer;

  /// 效果展示页常用 Curve
  static const curvePresets = <Curve>[
    Curves.fastOutSlowIn,
    Curves.linear,
    Curves.easeIn,
    Curves.easeInOut,
    Curves.easeOut,
    Curves.bounceOut,
  ];

  static String nameOfCurve(Curve curve) {
    if (identical(curve, Curves.fastOutSlowIn)) {
      return 'fastOutSlowIn';
    }
    if (identical(curve, Curves.linear)) {
      return 'linear';
    }
    if (identical(curve, Curves.easeIn)) {
      return 'easeIn';
    }
    if (identical(curve, Curves.easeInOut)) {
      return 'easeInOut';
    }
    if (identical(curve, Curves.easeOut)) {
      return 'easeOut';
    }
    if (identical(curve, Curves.bounceOut)) {
      return 'bounceOut';
    }
    return '$curve';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shadowColor: scheme.shadow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  scheme.primary,
                  scheme.tertiary,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          size: 20,
                          color: scheme.onPrimaryContainer,
                        ),
                        child: icon,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: header ??
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subtitle!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontFamily: 'monospace',
                                    fontSize: 12.5,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ],
                          ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      trailing!,
                    ],
                  ],
                ),
                Divider(
                  height: 25,
                  thickness: 1,
                  color: scheme.outlineVariant.withValues(alpha: 0.55),
                ),
                child,
              ],
            ),
          ),
          if (footer != null) ...[
            Divider(
              height: 1,
              color: scheme.outlineVariant.withValues(alpha: 0.55),
            ),
            footer!,
          ],
        ],
      ),
    );
  }
}
