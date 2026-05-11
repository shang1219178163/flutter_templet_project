import 'dart:math';
import 'package:flutter/material.dart';

class NLikeParticleButton extends StatefulWidget {
  const NLikeParticleButton({
    super.key,
    this.size = 30,
    this.boomSize = const Size(120, 120),
  });

  /// 点赞图标尺寸
  final double size;
  final Size? boomSize;

  @override
  State<NLikeParticleButton> createState() => _NLikeParticleButtonState();
}

class _NLikeParticleButtonState extends State<NLikeParticleButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(_tick);

    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0),
        weight: 60,
      ),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _tick() {
    const dt = 1 / 60;
    for (final p in _particles) {
      p.update(dt);
    }
    _particles.removeWhere((p) => p.life <= 0);
    setState(() {});
  }

  void _emitParticles(Offset center) {
    _particles.clear();

    const count = 24;
    const baseSpeed = 220.0;
    // const Offset center = Offset(60, 60); // CustomPaint 正中心

    for (var i = 0; i < count; i++) {
      final angle = 2 * pi * i / count;
      final direction = Offset(cos(angle), sin(angle));

      _particles.add(
        _Particle(
          position: center,
          direction: direction,
          speed: baseSpeed,
          life: 1.0,
          radius: 2.5,
          color: Colors.pinkAccent,
        ),
      );
    }
  }

  void _onTap() {
    _controller.forward(from: 0);

    final box = context.findRenderObject()! as RenderBox;
    final center = box.size.center(Offset.zero);
    _emitParticles(center);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          size: widget.boomSize ?? Size(widget.size * 1.5, widget.size * 1.5),
          painter: _ParticlePainter(_particles),
        ),
        GestureDetector(
          onTap: _onTap,
          child: ScaleTransition(
            scale: _scale,
            child: Icon(
              Icons.thumb_up,
              size: widget.size,
              color: Colors.pink,
            ),
          ),
        ),
      ],
    );
  }
}

class _Particle {
  Offset position;
  final Offset direction; // 单位向量
  final double speed;
  double life;
  final double radius;
  final Color color;

  _Particle({
    required this.position,
    required this.direction,
    required this.speed,
    required this.life,
    required this.radius,
    required this.color,
  });

  void update(double dt) {
    final decay = life.clamp(0, 1.0).toDouble();
    position += direction * speed * decay * dt;
    life -= dt * 1.5;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final p in particles) {
      if (p.life <= 0) {
        continue;
      }
      paint.color = p.color.withOpacity(p.life);
      canvas.drawCircle(p.position, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
