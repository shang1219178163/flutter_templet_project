import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// shape 预设（含默认半径；[rounded] 可被滑块覆盖）
enum ShapeKind {
  none(label: 'none', radius: 0),
  rounded(label: 'rounded', radius: 16),
  stadium(label: 'stadium', radius: 999);

  const ShapeKind({required this.label, required this.radius});

  /// Chip 文案
  final String label;

  /// 默认圆角半径；[rounded] 可被调用方覆盖
  final double radius;

  /// [BorderRadius]；[rounded] 传 [roundedRadius] 覆盖默认 [radius]
  BorderRadiusGeometry borderRadius({double? roundedRadius}) {
    final r = this == ShapeKind.rounded ? (roundedRadius ?? radius) : radius;
    return r <= 0 ? BorderRadius.zero : BorderRadius.circular(r);
  }

  /// [ShapeBorder]；[none] 为 null，[stadium] 为 [StadiumBorder]
  ShapeBorder? shape({double? roundedRadius}) {
    return switch (this) {
      ShapeKind.none => null,
      ShapeKind.rounded => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundedRadius ?? radius),
        ),
      ShapeKind.stadium => const StadiumBorder(),
    };
  }

  /// 轮廓描边场景（如 Chip.avatarBorder）
  OutlinedBorder? outlinedBorder({double? roundedRadius}) {
    final s = shape(roundedRadius: roundedRadius);
    return s is OutlinedBorder ? s : null;
  }
}

/// clipBehavior 预设
enum ClipKind {
  none(label: 'none', clip: Clip.none),
  hardEdge(label: 'hardEdge', clip: Clip.hardEdge),
  antiAlias(label: 'antiAlias', clip: Clip.antiAlias),
  antiAliasWithSaveLayer(label: 'antiAliasWithSaveLayer', clip: Clip.antiAliasWithSaveLayer);

  const ClipKind({required this.label, required this.clip});

  /// Chip 文案
  final String label;

  /// 对应 [Clip]
  final Clip clip;
}

/// systemOverlayStyle 预设
enum OverlayKind {
  none(label: 'none', style: null),
  light(label: 'light', style: SystemUiOverlayStyle.light),
  dark(label: 'dark', style: SystemUiOverlayStyle.dark);

  const OverlayKind({required this.label, required this.style});

  /// Chip 文案
  final String label;

  /// 对应 [SystemUiOverlayStyle]；[none] 为 null
  final SystemUiOverlayStyle? style;
}

/// 滚动物理预设
enum PhysicsKind {
  platform(label: 'platform', physics: null),
  always(label: 'always', physics: AlwaysScrollableScrollPhysics()),
  bouncing(label: 'bouncing', physics: BouncingScrollPhysics()),
  clamping(label: 'clamping', physics: ClampingScrollPhysics()),
  never(label: 'never', physics: NeverScrollableScrollPhysics());

  const PhysicsKind({required this.label, required this.physics});

  /// Chip 文案
  final String label;

  /// 对应 [ScrollPhysics]；[platform] 为 null
  final ScrollPhysics? physics;
}

/// 装饰卡片：渐变顶条、圆角描边、标题区 + 内容。
class NDecorationCard extends StatelessWidget {
  const NDecorationCard({
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
      color: theme.cardColor,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
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
