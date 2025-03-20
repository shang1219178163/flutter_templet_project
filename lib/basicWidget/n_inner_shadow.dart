import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

/// 内阴影组件
class NInnerShadow extends StatelessWidget {
  const NInnerShadow({
    super.key,
    required this.borderRadius,
    required this.shadows,
    required this.child,
  });

  final BorderRadiusGeometry borderRadius;
  final List<Shadow> shadows;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: _InnerShadow(
        shadows: shadows,
        child: child,
      ),
    );
  }
}

class _InnerShadow extends SingleChildRenderObjectWidget {
  const _InnerShadow({
    Key? key,
    this.shadows = const <Shadow>[],
    Widget? child,
  }) : super(key: key, child: child);

  final List<Shadow> shadows;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(BuildContext context, _RenderInnerShadow renderObject) {
    renderObject.shadows = shadows;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  late List<Shadow> shadows;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final rect = offset & child!.size;

    context.canvas.saveLayer(rect, Paint());
    context.paintChild(child!, offset);

    for (final shadow in shadows) {
      final shadowRect = rect.inflate(-shadow.blurSigma);
      final shadowPaint = Paint()
        ..blendMode = BlendMode.srcATop
        ..colorFilter = ColorFilter.mode(shadow.color, BlendMode.srcOut)
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: shadow.blurSigma,
          sigmaY: shadow.blurSigma,
          tileMode: TileMode.decal,
        );

      context.canvas
        ..saveLayer(shadowRect, shadowPaint)
        ..translate(shadow.offset.dx, shadow.offset.dy);
      context.paintChild(child!, offset);

      context.canvas.restore();
    }
    context.canvas.restore();
  }
}
