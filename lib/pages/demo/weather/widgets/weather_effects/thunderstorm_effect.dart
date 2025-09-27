import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/weather/widgets/weather_effects/rain_effect.dart';

class ThunderstormEffect extends StatefulWidget {
  final double animationSpeed;

  const ThunderstormEffect({
    super.key,
    this.animationSpeed = 1.0,
  });

  @override
  State<ThunderstormEffect> createState() => _ThunderstormEffectState();
}

class _ThunderstormEffectState extends State<ThunderstormEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Lightning> lightnings = [];
  final List<RainDrop> raindrops = [];
  final List<Cloud> stormClouds = [];
  final Random random = Random();

  bool _showLightning = false;
  double _lightningOpacity = 0.0;
  late DateTime _lastLightningTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    )..repeat();

    _lastLightningTime = DateTime.now();

    // 创建雨滴
    for (var i = 0; i < 120; i++) {
      raindrops.add(RainDrop(
        x: random.nextDouble() * 500,
        y: random.nextDouble() * 800 - 800,
        length: random.nextDouble() * 20 + 10,
        speed: random.nextDouble() * 20 + 12, // 稍微减慢初始速度
        opacity: random.nextDouble() * 0.6 + 0.3,
      ));
    }

    // 创建雷电
    for (var i = 0; i < 3; i++) {
      lightnings.add(Lightning(
        startX: random.nextDouble() * 300 + 50,
        startY: 20,
        segments: random.nextInt(5) + 3,
        width: random.nextDouble() * 3 + 2,
        opacity: 0.0,
      ));
    }

    // 创建风暴云
    for (var i = 0; i < 6; i++) {
      stormClouds.add(Cloud(
        x: random.nextDouble() * 400 - 100,
        y: random.nextDouble() * 150,
        width: random.nextDouble() * 160 + 120,
        height: random.nextDouble() * 80 + 50,
        opacity: random.nextDouble() * 0.5 + 0.3,
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
        // 更新雨滴
        for (final drop in raindrops) {
          // 使用动画速度参数调整雨滴下落速度
          drop.y += drop.speed * widget.animationSpeed;
          if (drop.y > 800) {
            drop.y = random.nextDouble() * -100 - 50;
            drop.x = random.nextDouble() * 500;
          }
        }

        // 随机闪电，根据动画速度调整频率
        final now = DateTime.now();
        if (now.difference(_lastLightningTime).inMilliseconds > (random.nextInt(5000) + 1000) / widget.animationSpeed) {
          _showLightning = true;
          _lightningOpacity = random.nextDouble() * 0.5 + 0.5;
          _lastLightningTime = now;

          // 重新生成闪电路径
          for (final lightning in lightnings) {
            lightning.regenerate(random);
            lightning.opacity = _lightningOpacity * (random.nextDouble() * 0.5 + 0.5);
          }

          // 2-3帧后隐藏闪电
          Future.delayed(Duration(milliseconds: (random.nextInt(100) + 50)), () {
            if (mounted) {
              setState(() {
                _showLightning = false;
              });
            }
          });
        }

        return CustomPaint(
          painter: ThunderstormPainter(
            raindrops: raindrops,
            lightnings: lightnings,
            clouds: stormClouds,
            showLightning: _showLightning,
            ambientDarkness: 0.6 + (random.nextDouble() * 0.1), // 随机波动的环境黑暗度
          ),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class Cloud {
  double x;
  double y;
  double width;
  double height;
  double opacity;

  Cloud({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.opacity,
  });
}

class Lightning {
  double startX;
  double startY;
  int segments;
  double width;
  double opacity;
  List<Offset> path = [];

  Lightning({
    required this.startX,
    required this.startY,
    required this.segments,
    required this.width,
    required this.opacity,
  }) {
    regenerate(Random());
  }

  void regenerate(Random random) {
    path.clear();
    path.add(Offset(startX, startY));

    var currentX = startX;
    var currentY = startY;

    for (var i = 0; i < segments; i++) {
      currentX += random.nextDouble() * 40 - 20;
      currentY += random.nextDouble() * 80 + 40;
      path.add(Offset(currentX, currentY));
    }
  }
}

class ThunderstormPainter extends CustomPainter {
  final List<RainDrop> raindrops;
  final List<Lightning> lightnings;
  final List<Cloud> clouds;
  final bool showLightning;
  final double ambientDarkness;
  final Random random = Random();

  ThunderstormPainter({
    required this.raindrops,
    required this.lightnings,
    required this.clouds,
    required this.showLightning,
    required this.ambientDarkness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制暴风雨背景
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blueGrey.shade900.withOpacity(ambientDarkness),
          Colors.blueGrey.shade700.withOpacity(ambientDarkness),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // 绘制云层
    for (final cloud in clouds) {
      final cloudPaint = Paint()
        ..color = Colors.grey.shade800.withOpacity(cloud.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

      final centerX = cloud.x + cloud.width / 2;
      final radius = cloud.height / 2;

      // 绘制云的主体
      canvas.drawCircle(
        Offset(centerX - cloud.width * 0.25, cloud.y),
        radius,
        cloudPaint,
      );

      canvas.drawCircle(
        Offset(centerX, cloud.y - radius * 0.2),
        radius * 1.2,
        cloudPaint,
      );

      canvas.drawCircle(
        Offset(centerX + cloud.width * 0.25, cloud.y),
        radius * 0.9,
        cloudPaint,
      );

      canvas.drawCircle(
        Offset(centerX - cloud.width * 0.4, cloud.y + radius * 0.3),
        radius * 0.7,
        cloudPaint,
      );

      // 绘制云的底部以增加体积感
      final rect = Rect.fromLTWH(
        centerX - cloud.width * 0.45,
        cloud.y - radius * 0.1,
        cloud.width * 0.9,
        radius * 1.3,
      );

      canvas.drawOval(rect, cloudPaint);
    }

    // 绘制雨滴
    final rainPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (final drop in raindrops) {
      // 雨滴主体
      canvas.drawLine(
        Offset(drop.x, drop.y),
        Offset(drop.x, drop.y + drop.length),
        Paint()
          ..color = Colors.white.withOpacity(drop.opacity)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // 如果闪电出现，绘制闪电并增加全屏亮度
    if (showLightning) {
      // 全屏闪光
      final flashPaint = Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), flashPaint);

      // 绘制闪电
      for (final lightning in lightnings) {
        if (lightning.opacity > 0) {
          final lightningPaint = Paint()
            ..color = Colors.white.withOpacity(lightning.opacity)
            ..strokeWidth = lightning.width
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round;

          // 绘制闪电路径
          if (lightning.path.length > 1) {
            final path = Path();
            path.moveTo(lightning.path.first.dx, lightning.path.first.dy);

            for (var i = 1; i < lightning.path.length; i++) {
              path.lineTo(lightning.path[i].dx, lightning.path[i].dy);
            }

            canvas.drawPath(path, lightningPaint);

            // 绘制闪电光晕效果
            final glowPaint = Paint()
              ..color = Colors.white.withOpacity(lightning.opacity * 0.3)
              ..strokeWidth = lightning.width * 3
              ..strokeCap = StrokeCap.round
              ..style = PaintingStyle.stroke
              ..strokeJoin = StrokeJoin.round
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

            canvas.drawPath(path, glowPaint);

            // 添加随机分支
            if (random.nextBool() && lightning.path.length > 2) {
              final branchIndex = random.nextInt(lightning.path.length - 1) + 1;
              final start = lightning.path[branchIndex - 1];
              final direction = lightning.path[branchIndex] - start;
              final branchStart = start + direction * 0.5;

              final branchPath = Path();
              branchPath.moveTo(branchStart.dx, branchStart.dy);

              var currentPoint = branchStart;
              final branchSegments = random.nextInt(3) + 1;

              for (var i = 0; i < branchSegments; i++) {
                final newPoint = Offset(
                  currentPoint.dx + random.nextDouble() * 30 - 15,
                  currentPoint.dy + random.nextDouble() * 30 + 10,
                );
                branchPath.lineTo(newPoint.dx, newPoint.dy);
                currentPoint = newPoint;
              }

              canvas.drawPath(branchPath, lightningPaint..strokeWidth = lightning.width * 0.7);
              canvas.drawPath(branchPath, glowPaint..strokeWidth = lightning.width * 2);
            }
          }
        }
      }
    }

    // 绘制雨水积聚的效果
    final reflectionRect = Rect.fromLTWH(0, size.height * 0.85, size.width, size.height * 0.15);
    final reflectionPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.2),
        ],
      ).createShader(reflectionRect);

    canvas.drawRect(reflectionRect, reflectionPaint);

    // 绘制雨滴溅落效果
    for (final drop in raindrops) {
      if (drop.y + drop.length >= size.height * 0.85) {
        final splashOpacity = drop.opacity * 0.5;
        final splashRadius = random.nextDouble() * 2 + 1.5;

        canvas.drawCircle(
          Offset(drop.x, size.height * 0.85),
          splashRadius,
          Paint()
            ..color = Colors.white.withOpacity(splashOpacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ThunderstormPainter oldDelegate) => true;
}
