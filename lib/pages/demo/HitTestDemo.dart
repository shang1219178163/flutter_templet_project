//
//  HitTestDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/14/21 8:59 AM.
//  Copyright © 12/14/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class HitTest extends StatelessWidget {
  const HitTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hit Test'),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  border: Border.all(color: Colors.blue),
                ),
                child: GestureDetector(
                  onTap: () => DLog.d("I'm hit!"),
                  child: ExpandedHitTestArea(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.red),
                      ),
                      child: NText("ExpandedHitTestArea"),
                    ),
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 100,
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => debugPrint("Tapped"),
                        child: ExpandedHitTestArea(child: Text("<aaaaa")),
                      ),
                      SizedBox(height: 20),
                      Text("Title"),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue),
                ),
                child: MyCustomHitTestWidget(
                  radius: 50,
                  color: Colors.orange,
                  onTap: () {
                    DLog.d('Custom hit test area tapped!');
                  },
                  textSpan: TextSpan(
                    text: '$runtimeType' * 1,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ExpandedHitTestArea extends SingleChildRenderObjectWidget {
  const ExpandedHitTestArea({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => RenderExpandedHitTestArea();
}

class RenderExpandedHitTestArea extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout() {
    if (child == null) {
      return;
    }
    child!.layout(constraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child?.parentData is BoxParentData) {
      var childParentData = child?.parentData as BoxParentData?;
      context.paintChild(child!, childParentData?.offset ?? Offset.zero + offset);
    }
  }

  @override
  bool hitTest(HitTestResult result, {required Offset position}) {
    const minimalSize = 44;
    final deltaX = (minimalSize - size.width).clamp(0, double.infinity) / 2;
    final deltaY = (minimalSize - size.height).clamp(0, double.infinity) / 2;
    final rect = Rect.fromLTRB(-deltaX, -deltaY, size.width + deltaX, size.height + deltaY);
    final contain = rect.contains(position);
    DLog.d([rect, position, contain].join(", "));
    if (contain) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}

/// 自定义圆形组件支持 HitTest 自定义
class MyCustomHitTestWidget extends SingleChildRenderObjectWidget {
  MyCustomHitTestWidget({
    super.key,
    required this.radius,
    required this.color,
    this.onTap,
    this.textSpan,
    this.textPainter,
  });

  final double radius;
  final Color color;
  final VoidCallback? onTap;
  final TextSpan? textSpan;
  final TextPainter? textPainter;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MyHitTestRenderBox(
      radius: radius,
      color: color,
      onTap: onTap,
      textSpan: textSpan,
      textPainter: textPainter,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant MyHitTestRenderBox renderObject) {
    renderObject
      ..radius = radius
      ..color = color
      ..onTap = onTap
      ..textSpan = textSpan
      ..textPainter = textPainter;
  }
}

class MyHitTestRenderBox extends RenderBox {
  MyHitTestRenderBox({
    required this.radius,
    required this.color,
    this.onTap,
    this.textSpan,
    this.textPainter,
  });

  double radius;
  Color color;
  VoidCallback? onTap;
  TextSpan? textSpan;
  TextPainter? textPainter;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    // final r = (position - center).distance <= radius;

    final rect = RRect.fromRectAndCorners(
      Rect.fromLTRB(0, 0, radius * 2, radius * 2),
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );

    final contains = rect.contains(position);
    DLog.d([
      position,
      contains,
      center,
      // radius,
      // constraints,
      // r,
      contains,
    ].asMap());

    if (contains) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      onTap?.call();
    }
  }

  @override
  void performLayout() {
    size = constraints.constrain(Size(radius * 2, radius * 2));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the circular hit test area
    canvas.drawCircle(
      offset + Offset(radius, radius),
      radius,
      paint,
    );

    // Draw text at the center
    final textPainterNew = textPainter ??
        TextPainter(
          text: textSpan ??
              TextSpan(
                text: '$runtimeType',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          textDirection: TextDirection.ltr,
        );
    textPainterNew.layout(maxWidth: size.width);
    final textOffset = offset +
        Offset(
          (size.width - textPainterNew.width) / 2,
          (size.height - textPainterNew.height) / 2,
        );
    textPainterNew.paint(canvas, textOffset);
  }
}
