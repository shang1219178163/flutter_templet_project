//
//  CustomeMaterialPageRoute.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/12 23:19.
//  Copyright © 2024/7/12 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class FadePageRoute<T> extends MaterialPageRoute<T> {
  FadePageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  // final CupertinoPageTransitionsBuilder

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
