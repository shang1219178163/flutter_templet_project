//
//  NRollingDigit.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/19 17:59.
//  Copyright © 2026/5/19 shang. All rights reserved.
//

import 'package:flutter/widgets.dart';

class NRollingDigit extends StatelessWidget {
  const NRollingDigit({
    super.key,
    required this.value,
    required this.builder,
  });

  final String value;

  final Widget Function(String v) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 350,
      ),
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        final isNew = child.key == ValueKey(value);
        // if (!isNew) {
        //   return const SizedBox.shrink();//隐藏旧数字动画
        // }

        late final Animation<Offset> offsetAnimation;
        if (isNew) {
          /// 新数字：
          /// 下 -> 中
          offsetAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.linear),
          );
        } else {
          /// 旧数字(AnimatedSwitcher, 旧 child animation 是反向)：
          /// 中 -> 上
          offsetAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.linear),
          );
        }

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(value),
        child: builder(value),
      ),
    );
  }
}
