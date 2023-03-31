//
//  ExpandAreaContainer.dart
//  flutter_templet_project
//
//  Created by shang on 12/14/21 10:17 AM.
//  Copyright © 12/14/21 shang. All rights reserved.
//

// example code:
//```
// GestureDetectorContainer(
//   edge: EdgeInsets.all(20),
//   color: Colors.yellow,
//   onTap: (){
//     ddlog("onTap");
//   },
//   child: OutlinedButton(
//     child: Text("OutlinedButton"),
//     onPressed: (){
//       ddlog("onPressed");
//     },
//   ),
// ),
//```

import 'package:flutter/cupertino.dart';

class GestureDetectorContainer extends StatelessWidget {

  const GestureDetectorContainer({
    Key? key,
    required this.child,
    this.edge = const EdgeInsets.all(0),
    this.onTap,
    this.width,
    this.height,
    this.alignment,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.constraints,
  }) : super(key: key);

  final Widget child;

  final EdgeInsets? edge;

  final GestureTapCallback? onTap;

  final double? width;
  final double? height;
  final BoxConstraints? constraints;

  /// Align the [child] within the container.
  final AlignmentGeometry? alignment;

  /// The color to paint behind the [child].
  final Color? color;

  /// The decoration to paint behind the [child].
  final Decoration? decoration;

  /// The decoration to paint in front of the [child].
  final Decoration? foregroundDecoration;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  final Matrix4? transform;

  /// The alignment of the origin, relative to the size of the container, if [transform] is specified.
  final AlignmentGeometry? transformAlignment;

  /// The clip behavior when [Container.decoration] is not null.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      ///这里设置behavior
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        color: color,
        alignment: alignment,
        padding: edge,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
}




