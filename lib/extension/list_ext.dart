//
//  ListExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/21/21 10:11 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//


import 'dart:convert';

import 'package:flutter_templet_project/extension/string_ext.dart';

extension ListExt<T,E> on List<E> {


  static bool isEmpty(List? val) {
    return val == null || val.isEmpty;
  }

  static bool isNotEmpty(List? val) {
    return val != null && val.isNotEmpty;
  }

  ///运算符重载
  List<E> operator *(int value) {
    var l = <E>[];
    for (var i = 0; i < value; i++) {
      l.addAll([...this]);
    }
    return l;
  }
  
  /// 带索引的map
  List<T> mapWithIdx(T Function(E, int i) action) {
    var result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(action(this[i], i));
    }
    return result;
  }

  /// 任意一个元素符合要求则返回,没有符合的返回为空
  E? some(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// 所有元素都满足需求
  bool every(bool Function(E) test) {
    for (final element in this) {
      if (!test(element)) {
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


extension IterableExt<T> on Iterable<T> {

  double sum(double Function(T) extract) {
    var result = 0.0;
    for (final e in this) {
      result += extract(e);
    }
    return result;
  }

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