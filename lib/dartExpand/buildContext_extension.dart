//
//  buildContext_extension.dart
//  fluttertemplet
//
//  Created by shang on 10/14/21 2:21 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';

extension BuildContextExt on BuildContext {

  ///扩展方法
  void logRendBoxInfo() {
    RenderObject? renderObject = this.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) {
      return;
    }
    RenderBox box = renderObject;
    Offset origin = box.localToGlobal(Offset.zero);
    print([DateTime.now(), origin, box.size]);
  }
  // get scaffoldMessenger => ScaffoldMessenger.of(this);
  //
  // void showSnackBar(SnackBar snackBar, [bool isReplace = false]) {
  //   if (isReplace) {
  //     this.scaffoldMessenger.hideCurrentSnackBar();
  //   }
  //   this.scaffoldMessenger.showSnackBar(snackBar);
  // }

}


extension StatefulWidgetExt<T extends StatefulWidget> on State<T> {
  /// 扩展属性 ScaffoldMessenger.of(this.context);
  get scaffoldMessenger => ScaffoldMessenger.of(this.context);
  /// 扩展方法
  void showSnackBar(SnackBar snackBar, [bool isReplace = false]) {
    if (isReplace) {
      scaffoldMessenger.hideCurrentSnackBar();
    }
    scaffoldMessenger.showSnackBar(snackBar);
  }

  /// 扩展属性 Theme.of(this.context)
  get theme => Theme.of(this.context);

}

// showSnackBar({
//   required BuildContext context,
//   required SnackBar snackBar,
//   bool isReplace = false
// }) {
//   final scaffoldMessenger = ScaffoldMessenger.of(context);
//   if (isReplace) {
//     scaffoldMessenger.hideCurrentSnackBar();
//   }
//   scaffoldMessenger.showSnackBar(snackBar);
// }

// extension SnackBarExt on SnackBar {
//
//   void showBy(BuildContext context, [bool isReplace = false]) {
//     if (isReplace) {
//       context.scaffoldMessenger.hideCurrentSnackBar();
//     }
//     context.scaffoldMessenger.showSnackBar(this);
//   }
// }


// extension SmartIterable<T> on Iterable<T> {
//   void doTheSmartThing(void Function(T) smart) {
//     for (var e in this) smart(e);
//   }
// }
// extension SmartList<T> on List<T> {
//   void doTheSmartThing(void Function(T) smart) {
//     for (int i = 0; i < length; i++) smart(this[i]);
//   }
// }