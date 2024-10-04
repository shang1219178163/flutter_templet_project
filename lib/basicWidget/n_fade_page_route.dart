//
//  NFadeRoute.dart
//  flutter_templet_project
//
//  Created by shang on 4/6/23 10:07 AM.
//  Copyright © 4/6/23 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

class NFadePageRoute extends PageRoute {
  NFadePageRoute({
    required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    this.needFadeTransition = true,
  });

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;

  /// 需要 FadeTransition
  final bool needFadeTransition;

  /// 构造器
  final WidgetBuilder builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //当前路由被激活，是打开新路由
    if (!isActive) {
      return builder(context);
    }

    if (!needFadeTransition) {
      return builder(context);
    }

    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }
}
