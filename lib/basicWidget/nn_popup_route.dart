//
//  nn_popup_route.dart
//  flutter_templet_project
//
//  Created by shang on 7/29/21 4:22 PM.
//  Copyright © 7/29/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class NNPopupRoute<T> extends PopupRoute<T> {

  NNPopupRoute({
    this.backgroudColor,
    this.alignment = Alignment.center,
    required this.onClick,
    required this.child
  });

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => Duration(seconds: 0);

  /// backgroudColor
  final Color? backgroudColor;

  /// child'alignment, default value: [Alignment.center]
  final Alignment alignment;

  /// child
  final Widget child;

  /// backgroudView action
  final Function onClick;


  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: Stack(
          children: [
            Container(
              // width: screenSize.width,
              // height: screenSize.height,
              color: backgroudColor ?? Colors.black.withOpacity(0.3),
            ),
            SafeArea(
              child: Align(
                alignment: alignment,
                child: child,
              ),
            ),
          ],
        ),
        onTap: () {
          onClick();
        },
      ),
    );
  }
}