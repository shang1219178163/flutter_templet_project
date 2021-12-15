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
import 'package:flutter_templet_project/extensions/ddlog.dart';

class HitTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hit Test'),
      ),
      body: _buildBody1(),
    );
  }

  _buildBody(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Container(
              alignment: Alignment.bottomCenter,
              color: Colors.yellow,
              height: 100,
              width: 100,
              child: GestureDetector(
                onTap: () => ddlog("I'm hit! I'm hit!"),
                child: ExpandedHitTestArea(
                  child: Container(width: 60, height: 40, color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => ddlog("Tapped"),
                    child: ExpandedHitTestArea(child: Text("<")),
                  ),
                  SizedBox(height: 20),
                  Text("Title"),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  _buildBody1() {
    return Center(
      child: GestureDetector(
        ///这里设置behavior
        behavior: HitTestBehavior.translucent,
        onTap: (){
          ddlog("onTap");
        },
        child: Container(
          height: 50,
          width: 100,
          color: Colors.yellow,
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: OutlinedButton(
            child: Text("OutlinedButton"),
            onPressed: (){
            ddlog("onPressed");
          },),
        ),
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

  // trivial implementations left out to save space: computeMinIntrinsicWidth, computeMaxIntrinsicWidth, computeMinIntrinsicHeight, computeMaxIntrinsicHeight

  @override
  void performLayout() {
    if (child == null) return;
    child!.layout(constraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final BoxParentData childParentData = child!.parentData as BoxParentData;
      context.paintChild(child!, childParentData.offset + offset);
    }
  }

  @override
  bool hitTest(HitTestResult result, {required Offset position}) {
    const minimalSize = 44;
    final deltaX = (minimalSize - size.width).clamp(0, double.infinity) / 2;
    final deltaY = (minimalSize - size.height).clamp(0, double.infinity) / 2;
    if (Rect.fromLTRB(-deltaX, -deltaY, size.width + deltaX, size.height + deltaY).contains(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}