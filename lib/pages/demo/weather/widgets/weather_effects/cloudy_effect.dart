import 'dart:math';
import 'package:flutter/material.dart';

class CloudyEffect extends StatefulWidget {
  final double animationSpeed;

  const CloudyEffect({
    super.key,
    this.animationSpeed = 1.0,
  });

  @override
  State<CloudyEffect> createState() => _CloudyEffectState();
}

class _CloudyEffectState extends State<CloudyEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Cloud> clouds = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // 创建云
    for (int i = 0; i < 5; i++) {
      clouds.add(Cloud(
        x: random.nextDouble() * 300 - 100,
        y: 30.0 + random.nextDouble() * 250,
        width: random.nextDouble() * 150 + 100,
        height: random.nextDouble() * 60 + 40,
        speed: random.nextDouble() * 0.2 + 0.1,
        opacity: random.nextDouble() * 0.4 + 0.1,
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
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 更新云的位置
        for (var cloud in clouds) {
          // 使用动画速度参数调整云移动速度
          cloud.x += cloud.speed * widget.animationSpeed;
          if (cloud.x > size.width + 100) {
            cloud.x = -cloud.width;
            cloud.y = 30.0 + random.nextDouble() * 250;
          }
        }

        return CustomPaint(
          painter: CloudPainter(clouds),
          size: size,
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
  double speed;
  double opacity;

  Cloud({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.speed,
    required this.opacity,
  });
}

class CloudPainter extends CustomPainter {
  final List<Cloud> clouds;

  CloudPainter(this.clouds);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景光线
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.lightBlue.shade300,
          Colors.lightBlue.shade100,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    // 绘制云
    for (var cloud in clouds) {
      final cloudPaint = Paint()
        ..color = Colors.white.withOpacity(cloud.opacity)
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

      // 额外的云朵细节
      canvas.drawCircle(
        Offset(centerX - cloud.width * 0.4, cloud.y + radius * 0.3),
        radius * 0.7,
        cloudPaint,
      );

      canvas.drawCircle(
        Offset(centerX + cloud.width * 0.4, cloud.y + radius * 0.2),
        radius * 0.6,
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

      // 绘制云朵投下的柔和阴影
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.03)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawOval(
        Rect.fromLTWH(rect.left + 10, rect.top + rect.height * 0.9, rect.width,
            rect.height * 0.3),
        shadowPaint,
      );
    }

    // 绘制远处的更淡的云层以增加深度感
    final distantCloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    // 绘制几个远处的大型云团
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.2),
      size.width * 0.15,
      distantCloudPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.15),
      size.width * 0.12,
      distantCloudPaint,
    );

    // 绘制一些阳光穿透云层的效果
    if (clouds.isNotEmpty) {
      final sunlightPaint = Paint()
        ..color = Colors.yellow.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

      canvas.drawCircle(
        Offset(size.width * 0.7, size.height * 0.1),
        size.width * 0.2,
        sunlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CloudPainter oldDelegate) {
    return true; // 总是重绘以使动画流畅
  }
}
