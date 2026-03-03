import 'package:flutter/material.dart';

/// 点击打印尺寸
class NRenderBox extends StatefulWidget {
  const NRenderBox({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<NRenderBox> createState() => _NRenderBoxState();
}

class _NRenderBoxState extends State<NRenderBox> {
  final renderKey = GlobalKey();

  RenderBox? get renderBox {
    final ctx = renderKey.currentContext;
    if (ctx == null) {
      return null;
    }
    final box = ctx.findRenderObject() as RenderBox?;
    return box;
  }

  Offset? get renderPosition {
    return renderBox?.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: renderKey,
      onTap: () {
        if (renderBox == null) {
          return;
        }
        final position = renderPosition;
        final size = renderBox!.size;
        final rect = Rect.fromLTWH(position!.dx, position.dy, size.width, size.height);
        debugPrint("$widget rect: $rect");
      },
      child: widget.child,
    );
  }
}
