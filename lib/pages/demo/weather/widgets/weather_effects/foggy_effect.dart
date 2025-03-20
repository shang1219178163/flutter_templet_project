import 'dart:math';
import 'package:flutter/material.dart';

class FoggyEffect extends StatefulWidget {
  final double animationSpeed;

  const FoggyEffect({
    super.key,
    this.animationSpeed = 1.0,
  });

  @override
  State<FoggyEffect> createState() => _FoggyEffectState();
}

class _FoggyEffectState extends State<FoggyEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FogCloud> _fogClouds = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 5),
    )..repeat();

    // 创建雾气云团 - 使用更少但更大的云团
    _createFogClouds();
  }

  void _createFogClouds() {
    // 清除现有云团
    _fogClouds.clear();

    // 创建前景和背景雾气
    _createLayeredFogClouds(5, 0.0, 0.3, 0.06); // 前景雾
    _createLayeredFogClouds(8, 0.4, 0.8, 0.02); // 中间雾
    _createLayeredFogClouds(10, 0.7, 1.0, 0.01); // 背景雾
  }

  void _createLayeredFogClouds(
      int count, double minOpacity, double maxOpacity, double maxSpeed) {
    for (int i = 0; i < count; i++) {
      final size = 150.0 + random.nextDouble() * 300;

      _fogClouds.add(
        FogCloud(
          x: random.nextDouble() * 1000 - 300,
          y: random.nextDouble() * 800,
          size: Size(size, size * (0.3 + random.nextDouble() * 0.4)),
          opacity: minOpacity + random.nextDouble() * (maxOpacity - minOpacity),
          speed: (random.nextDouble() * 0.5 + 0.5) * maxSpeed,
          wiggleAmount: 1.0 + random.nextDouble() * 2.0,
          wiggleSpeed: 0.2 + random.nextDouble() * 0.4,
          phase: random.nextDouble() * 2 * pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animationValue = _controller.value;

        // 更新雾气位置 - 使用正弦曲线使移动更加平滑自然
        for (var cloud in _fogClouds) {
          // 水平移动
          cloud.x += cloud.speed * widget.animationSpeed;

          // 垂直轻微摆动，创造漂浮感
          cloud.yOffset =
              sin(animationValue * 2 * pi * cloud.wiggleSpeed + cloud.phase) *
                  cloud.wiggleAmount;

          // 当云团完全移出屏幕时，从左侧重新进入
          if (cloud.x > size.width + cloud.size.width) {
            cloud.x = -cloud.size.width;
            cloud.y = random.nextDouble() * size.height;
          }
        }

        return CustomPaint(
          painter: NewFogPainter(
            fogClouds: _fogClouds,
            animationValue: animationValue,
          ),
          size: size,
        );
      },
    );
  }
}

class FogCloud {
  double x;
  double y;
  double yOffset = 0;
  final Size size;
  final double opacity;
  final double speed;
  final double wiggleAmount;
  final double wiggleSpeed;
  final double phase;

  FogCloud({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.wiggleAmount,
    required this.wiggleSpeed,
    required this.phase,
  });
}

class NewFogPainter extends CustomPainter {
  final List<FogCloud> fogClouds;
  final double animationValue;

  NewFogPainter({
    required this.fogClouds,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景 - 使用更柔和的颜色
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey.shade200, // 较亮的灰色
          Colors.grey.shade300,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // 绘制模糊的远景深度
    _drawSilhouettes(canvas, size);

    // 绘制全屏环境雾气 - 创造整体氛围
    _drawAmbientFog(canvas, size);

    // 绘制各种云团 - 按不透明度排序（从后到前）
    fogClouds.sort((a, b) => a.opacity.compareTo(b.opacity));

    for (var cloud in fogClouds) {
      final fogPaint = Paint()
        ..color = Colors.white.withOpacity(cloud.opacity)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          20 + (1 - cloud.opacity) * 40, // 透明度越低，模糊程度越高
        );

      // 创建椭圆形的雾气云团
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cloud.x, cloud.y + cloud.yOffset),
          width: cloud.size.width,
          height: cloud.size.height,
        ),
        fogPaint,
      );

      // 为一些云团添加更亮的中心，增加体积感
      if (cloud.opacity > 0.4) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cloud.x, cloud.y + cloud.yOffset),
            width: cloud.size.width * 0.6,
            height: cloud.size.height * 0.6,
          ),
          Paint()
            ..color = Colors.white.withOpacity(cloud.opacity * 0.7)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
        );
      }
    }

    // 顶部添加额外的雾气层
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.3),
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // 添加微妙的光影效果
    _drawLightEffects(canvas, size);
  }

  void _drawSilhouettes(Canvas canvas, Size size) {
    final silhouettePaint = Paint()
      ..color = Colors.blueGrey.shade800.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // 使用随机种子，确保每次重建时形状相同
    final silhouetteRandom = Random(42);

    // 远处的山脉或建筑轮廓
    for (int i = 0; i < 3; i++) {
      final silhouettePath = Path();
      final baseY = size.height - (i * 50 + 100);

      silhouettePath.moveTo(0, size.height);
      silhouettePath.lineTo(0, baseY);

      double x = 0;
      while (x < size.width) {
        final segmentWidth = 40 + silhouetteRandom.nextDouble() * 80;
        final height = 10 + silhouetteRandom.nextDouble() * 30;

        x += segmentWidth;
        silhouettePath.lineTo(x, baseY - height);
      }

      silhouettePath.lineTo(size.width, size.height);
      silhouettePath.close();

      canvas.drawPath(silhouettePath, silhouettePaint);
    }
  }

  void _drawAmbientFog(Canvas canvas, Size size) {
    // 创建渐变雾气效果
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.1, 0.4, 0.8],
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );
  }

  void _drawLightEffects(Canvas canvas, Size size) {
    // 添加顶部微弱的光源效果
    final lightX = sin(animationValue * pi * 0.2) * 0.3 + 0.5; // 光源缓慢移动

    canvas.drawCircle(
      Offset(size.width * lightX, -size.height * 0.2),
      size.width * 0.5,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.yellow.shade100.withOpacity(0.12),
            Colors.white.withOpacity(0),
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width * lightX, -size.height * 0.2),
            radius: size.width * 0.5,
          ),
        ),
    );
  }

  @override
  bool shouldRepaint(covariant NewFogPainter oldDelegate) => true;
}
