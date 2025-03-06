import 'dart:math';
import 'package:flutter/material.dart';

class SnowEffect extends StatefulWidget {
  final double animationSpeed;

  const SnowEffect({
    super.key,
    this.animationSpeed = 1.0,
  });

  @override
  State<SnowEffect> createState() => _SnowEffectState();
}

class _SnowEffectState extends State<SnowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> snowflakes = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // 创建雪花
    for (int i = 0; i < 100; i++) {
      snowflakes.add(Snowflake(
        x: random.nextDouble() * 500,
        y: random.nextDouble() * 800 - 800,
        size: random.nextDouble() * 6 + 2,
        speed: random.nextDouble() * 1.5 + 0.5, // 降低初始速度
        swingRange: random.nextDouble() * 4 + 1,
        swingSpeed: random.nextDouble() * 0.005 + 0.002, // 降低摆动速度
        angle: random.nextDouble() * pi * 2,
        opacity: random.nextDouble() * 0.5 + 0.4,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 更新雪花位置
        for (var snowflake in snowflakes) {
          // 使用动画速度参数调整雪花下落和摆动速度
          snowflake.y += snowflake.speed * widget.animationSpeed;
          snowflake.angle += snowflake.swingSpeed * widget.animationSpeed;
          snowflake.x += sin(snowflake.angle) *
              snowflake.swingRange *
              0.1 *
              widget.animationSpeed;

          if (snowflake.y > 800) {
            // 重置雪花位置
            snowflake.y = random.nextDouble() * -100 - 10;
            snowflake.x = random.nextDouble() * 500;
          }
        }

        return CustomPaint(
          painter: SnowPainter(snowflakes),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class Snowflake {
  double x;
  double y;
  double size;
  double speed;
  double swingRange; // 摆动幅度
  double swingSpeed; // 摆动速度
  double angle; // 当前角度
  double opacity;

  Snowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.swingRange,
    required this.swingSpeed,
    required this.angle,
    required this.opacity,
  });
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;

  SnowPainter(this.snowflakes);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制雪地
    final groundRect =
        Rect.fromLTWH(0, size.height * 0.85, size.width, size.height * 0.15);
    final groundPaint = Paint()..color = Colors.white.withOpacity(0.8);

    canvas.drawRect(groundRect, groundPaint);

    // 绘制雪花
    for (var snowflake in snowflakes) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(snowflake.opacity);

      canvas.drawCircle(
          Offset(snowflake.x, snowflake.y), snowflake.size, paint);

      // 绘制雪花细节
      if (snowflake.size > 4) {
        for (int i = 0; i < 6; i++) {
          final angle = 2 * pi / 6 * i;
          final lineLength = snowflake.size * 1.2;

          canvas.drawLine(
            Offset(snowflake.x, snowflake.y),
            Offset(
              snowflake.x + cos(angle) * lineLength,
              snowflake.y + sin(angle) * lineLength,
            ),
            Paint()
              ..color = Colors.white.withOpacity(snowflake.opacity * 0.7)
              ..strokeWidth = 0.8,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant SnowPainter oldDelegate) => true;
}
