//
//  LayoutLogPrint.dart
//  flutter_templet_project
//
//  Created by shang on 10/22/21 9:37 AM.
//  Copyright © 10/22/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

class LayoutLogPrint<T> extends StatelessWidget {
  const LayoutLogPrint({
    Key? key,
    this.tag,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final T? tag; //指定日志tag

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      // assert在编译release版本时会被去除
      assert(() {
        debugPrint('${tag ?? key ?? child}: $constraints');
        return true;
      }());
      return child;
    });
  }
}

// class SliverLayoutLogPrint<T> extends StatelessWidget {
//   const SliverLayoutLogPrint({
//     Key? key,
//     this.tag,
//     required this.child,
//   }) : super(key: key);
//
//   final Widget child;
//   final T? tag; //指定日志tag
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverLayoutBuiler(builder: (_, constraints) {
//       // assert在编译release版本时会被去除
//       assert(() {
//         print('${tag ?? key ?? child}: $constraints');
//         return true;
//       }());
//       return child;
//     });
//   }
// }
