import 'dart:ui';

import 'package:flutter/material.dart';

/// 光晕环：按 Aninix / Lottie 72×72、60fps、0–89 帧还原。
///
/// 内环固定半径、描边加粗并渐显；外环同步扩大并淡入再淡出。
class AnimatedHalo extends StatefulWidget {
  const AnimatedHalo({
    super.key,
    this.size = 72,
    this.color = const Color(0xFF51D3B1),
    this.innerColor = const Color(0xFF00B887),
    this.spacing = 6,
    this.strokeWidth = 2,
    this.innerStrokeWidth = 4,
    this.duration = const Duration(milliseconds: 1483),
    required this.child,
  });

  /// 画布边长，对应稿 72。
  final double size;

  /// 外环描边色。
  final Color color;

  /// 内环描边色。
  final Color innerColor;

  /// 外环相对内环的半径增量，稿面默认 6。
  final double spacing;

  /// 外环线宽。
  final double strokeWidth;

  /// 内环线宽。
  final double innerStrokeWidth;

  /// 一轮动画时长，稿面 1483ms。
  final Duration duration;
  /// 中间内容，会被裁成圆形。
  final Widget child;

  @override
  State<AnimatedHalo> createState() => _AnimatedHaloState();
}

class _AnimatedHaloState extends State<AnimatedHalo> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant AnimatedHalo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      controller
        ..duration = widget.duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.size / 72;
    final imageSize = ((30 - widget.innerStrokeWidth / 2) * 2 * scale).clamp(0.0, widget.size);
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: SizedBox.square(
              dimension: imageSize,
              child: widget.child,
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size.square(widget.size),
                painter: _AnimatedHaloPainter(
                  progress: controller.value,
                  color: widget.color,
                  innerColor: widget.innerColor,
                  spacing: widget.spacing,
                  strokeWidth: widget.strokeWidth,
                  innerStrokeWidth: widget.innerStrokeWidth,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AnimatedHaloPainter extends CustomPainter {
  _AnimatedHaloPainter({
    required this.progress,
    required this.color,
    required this.innerColor,
    required this.spacing,
    required this.strokeWidth,
    required this.innerStrokeWidth,
  });

  /// 0–1，对应 0–89 帧。
  final double progress;
  final Color color;
  final Color innerColor;
  final double spacing;
  final double strokeWidth;
  final double innerStrokeWidth;

  static const _ease = Cubic(0.5, 0.35, 0.15, 1);
  static const _comp = 72.0;
  static const _frames = 89.0;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / _comp;
    final center = Offset(size.width / 2, size.height / 2);
    final frame = progress * _frames;
    final innerRadius = 30 * scale;
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerStrokeWidth * scale
      ..color = innerColor.withValues(alpha: _innerOpacity(frame));
    canvas.drawCircle(center, innerRadius, innerPaint);
    final outerOpacity = _outerOpacity(frame);
    if (outerOpacity <= 0) {
      return;
    }
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * scale
      ..color = color.withValues(alpha: outerOpacity);
    canvas.drawCircle(center, _outerRadius(frame, innerRadius, scale), outerPaint);
  }

  double _outerRadius(double frame, double innerRadius, double scale) {
    final t = (frame / 88.434).clamp(0.0, 1.0);
    return innerRadius + spacing * scale * Curves.easeOut.transform(t);
  }

  double _outerOpacity(double frame) {
    return _keyframe(frame, const [
      (1.248, 0.0),
      (40.326, 1.0),
      (50.358, 1.0),
      (88.47, 0.0),
    ]);
  }

  double _innerOpacity(double frame) {
    return _keyframe(frame, const [
      (0.378, 0.5),
      (88.416, 1.0),
    ]);
  }

  double _keyframe(double frame, List<(double, double)> keys) {
    if (frame <= keys.first.$1) {
      return keys.first.$2;
    }
    if (frame >= keys.last.$1) {
      return keys.last.$2;
    }
    for (var i = 0; i < keys.length - 1; i++) {
      final a = keys[i];
      final b = keys[i + 1];
      if (frame > b.$1) {
        continue;
      }
      if (a.$2 == b.$2) {
        return a.$2;
      }
      final t = ((frame - a.$1) / (b.$1 - a.$1)).clamp(0.0, 1.0);
      return lerpDouble(a.$2, b.$2, _ease.transform(t))!;
    }
    return keys.last.$2;
  }

  @override
  bool shouldRepaint(covariant _AnimatedHaloPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.innerColor != innerColor ||
        oldDelegate.spacing != spacing ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.innerStrokeWidth != innerStrokeWidth;
  }
}
