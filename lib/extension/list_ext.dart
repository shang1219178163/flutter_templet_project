//
//  ListExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/21/21 10:11 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:get/get.dart';

extension ListExt<T,E> on List<E> {


  // static bool isEmpty(List? val) {
  //   return val == null || val.isEmpty;
  // }
  //
  // static bool isNotEmpty(List? val) {
  //   return val != null && val.isNotEmpty;
  // }

  ///运算符重载
  List<E> operator *(int value) {
    var l = <E>[];
    for (var i = 0; i < value; i++) {
      l.addAll([...this]);
    }
    return l;
  }

  /// 重写属性
  E? get first {
    try {
      return this.first;
    } catch (exception) {
      return null;
    }
  }

  /// 重写属性
  E? get last {
    try {
      return this.last;
    } catch (exception) {
      return null;
    }
  }

  /// 查询元素索引,没有则返回为空
  int? indexOf(E element) {
    try {
      return this.indexOf(element);
    } catch (exception) {
      return null;
    }
  }

  /// 倒叙查询元素索引
  int? lastIndexOf(E element) {
    try {
      return this.lastIndexOf(element);
    } catch (exception) {
      return null;
    }
  }

  /// 查询符合条件元素,没有则返回为空
  E? find(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
  /// 倒叙查询符合条件元素
  E? findLast(bool Function(E) test) {
    for (var i = length - 1; i >= 0; i--) {
      final element = this[i];
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// 查询符合条件元素,没有则返回为空
  E? firstWhere(bool Function(E) test) => find(test);
  /// 倒叙查询符合条件元素
  E? lastWhere(bool Function(E) test) => findLast(test);

  /// 查询符合条件元素,没有则返回为空
  int? findIndex(bool Function(E) test) {
    for (var i = 0; i <= length - 1; i++) {
      final element = this[i];
      if (test(element)) {
        return i;
      }
    }
    return null;
  }
  /// 倒叙查询符合条件元素
  int? findLastIndex(bool Function(E) test) {
    for (var i = length - 1; i >= 0; i--) {
      final element = this[i];
      if (test(element)) {
        return i;
      }
    }
    return null;
  }
  /// 查询符合条件元素,没有则返回为空
  int? indexWhere(bool Function(E) test) => findIndex(test);
  /// 倒叙查询符合条件元素
  int? lastIndexWhere(bool Function(E) test) => findLastIndex(test);

  /// 所有元素都满足需求(回调返回第一个不满足需求的元素)
  bool every(bool Function(E) test, {ValueChanged<E>? cb}) {
    for (final element in this) {
      if (!test(element)) {
        cb?.call(element);
        return false;
      }
    }
    return true;
  }
  
  /// 数组降维() expand
  // List<T> flatMap(List<T> action(E e)) {
    // var result = <T>[];
    // this.forEach((e) {
    //   result.addAll(action(e));
    // });
    // return result;
  // }

  /// 同 sorted
  List<E> sorted([int Function(E a, E b)? compare]) {
    sort(compare);
    return this;
  }

  List<E> exchange(int fromIdx, int toIdx) {
    if (fromIdx >= length || toIdx >= length) {
      return this;
    }
    var e = this[fromIdx];
    var toE = this[toIdx];
    //exchange
    this[fromIdx] = toE;
    this[toIdx] = e;
    return this;
  }

  /// 递归遍历
  recursion(void Function(E e)? cb) {
    forEach((item) {
      cb?.call(item);
      recursion(cb);
    });
  }

  // /// 转为 Map<String, dynamic>
  // Map<String, E> toMap() {
  //   var map = <String, E>{};
  //   for (final item in this) {
  //     map["$item"] = item;
  //   }
  //   return map;
  // }
}

extension ListExtObject<E extends Object> on List<E> {
  // List<E> sortedByKey(String key, {bool ascending = true}) {
  //   this.forEach((element) {
  //     print("sortByKey:${element}");
  //   });
  //   if (ascending) {
  //     this.sort((a, b) => a[key].compareTo(b[key]));
  //   } else {
  //     this.sort((a, b) => b[key].compareTo(a[key]));
  //   }
  //   return this;
  // }

  List<E> sortedByValue({bool ascending = true, required dynamic Function(E obj) cb}) {
    if (ascending) {
      // this.sort((a, b) => cb(a).compareTo(cb(b)));
      sort((a, b) => _customeCompare(cb(a), cb(b)));
    } else {
      // this.sort((a, b) => cb(b).compareTo(cb(a)));
      sort((a, b) => _customeCompare(cb(b), cb(a)));
    }
    return this;
  }

  /// 处理字符串中包含数字排序异常的问题
  _customeCompare(dynamic a, dynamic b) {
    if (a is String && b is String) {
      return a.compareCustom(b);
    }
    return a.compareTo(b);
  }
}


extension IterableExt<E> on Iterable<E> {

  // /// 重新
  // E? get firstNBew {
  //   var it = iterator;
  //   if (!it.moveNext()) {
  //     return null;
  //   }
  //   return it.current;
  // }
  //
  // E? get last {
  //   var it = iterator;
  //   if (!it.moveNext()) {
  //     return null;
  //   }
  //   E result;
  //   do {
  //     result = it.current;
  //   } while (it.moveNext());
  //   return result;
  // }

  // double sum(double Function(T) cb) {
  //   var result = 0.0;
  //   for (final e in this) {
  //     result += cb(e);
  //   }
  //   return result;
  // }

  // Iterable<T> filter() {
  //   return whereType<T>();
  // }
}


extension ListNullExt<E> on List<E?> {

  /// 移除数组空值
  List<E> removeNull() {
    var val = this;
    val.removeWhere((e) => e == null);
    final result = val.whereType<E>().toList();
    return result;
  }
}