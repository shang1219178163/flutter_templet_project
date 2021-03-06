//
//  ListExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/21/21 10:11 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//


extension ListExt<E> on List<E>{
  ///运算符重载
  List<E> operator *(int value) {
    var l = <E>[];
    for (var i = 0; i < value; i++) {
      l.addAll([...this]);
    }
    return l;
  }

  static bool isNotEmpty(List l) {
    return l != null && l.isNotEmpty;
  }
  /// 扩展方法
  List<E> sorted([int compare(E a, E b)?]) {
    this.sort(compare);
    return this;
  }

}
