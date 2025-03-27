//
//  ListExtension.dart
//  flutter_templet_project
//
//  Created by shang on 10/21/21 10:11 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:get/get.dart';

extension IterableExt<E> on Iterable<E> {
  /// 获取随机元素
  E? get randomOne {
    if (isEmpty) {
      return null;
    }
    final index = Random().nextInt(length);
    final e = elementAt(index);
    return e;
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
      final element = elementAt(i);
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
      final element = elementAt(i);
      if (test(element)) {
        return i;
      }
    }
    return null;
  }

  /// 倒叙查询符合条件元素
  int? findLastIndex(bool Function(E) test) {
    for (var i = length - 1; i >= 0; i--) {
      final element = elementAt(i);
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

  /// 递归遍历
  recursion(void Function(E e)? cb) {
    forEach((item) {
      cb?.call(item);
      recursion(cb);
    });
  }

  /// 通过步长切割字符串
  ///
  /// from - 开始索引,默认 0
  /// to - 结束索引, 默认总长
  /// by - 每次分割最大长度,默认1
  List<T> splitStride<T>({
    int from = 0,
    int? to,
    int by = 1,
    required T Function(int start, int end, List<E> items) onItem,
  }) {
    final count = to ?? length;

    var result = <T>[];
    for (var i = from; i < count; i += by) {
      var end = (i + by) < count ? (i + by) : count - 1;
      result.add(onItem(i, end, toList()));
    }

    return result;
  }
}

extension IterableNullableItemExt<E> on Iterable<E?> {
  /// 移除数组空值
  Iterable<E> removeNull() {
    var result = where((e) => e != null).whereType<E>();
    return result;
  }
}

extension ListExt<T, E> on List<E> {
  /// 动态值
  E operator [](int index) {
    final i = index.clamp(0, length - 1);
    return this[i];
  }

  /// 动态复制
  void operator []=(int index, E val) {
    final i = index.clamp(0, length - 1);
    this[i] = val;
  }

  ///运算符重载
  List<E> operator *(int value) {
    var result = List<E>.generate(value, (index) => this as E);
    return result;
  }

  /// 用多个元素取代数组中满足条件的第一个元素
  /// replacements 取代某个元素的集合
  /// isReversed 是否倒序查询
  List<E> replaceFirst(
    bool Function(E) test, {
    required List<E> replacements,
    bool isReversed = false,
  }) {
    final target = !isReversed ? firstWhere(test) : findLast(test);
    if (target == null) {
      return this;
    }
    return replaceTarget(target, replacements: replacements);
  }

  /// 用多个元素取代数组中某个元素
  /// replacements 取代某个元素的集合
  List<E> replaceTarget(
    E target, {
    required List<E> replacements,
  }) {
    final index = indexOf(target);
    if (index != -1) {
      replaceRange(index, index + 1, replacements);
    }
    return this;
  }

  Iterable<E> exchange(int fromIdx, int toIdx) {
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

  /// 同 sorted
  List<E> sorted([int Function(E a, E b)? compare]) {
    sort(compare);
    return this;
  }

  /// 数组降维
  List<E> flatMap() {
    final list = <E>[];
    for (final e in this) {
      if (e is List<E>) {
        list.addAll((e as List<E>).flatMap());
      } else {
        list.add(e);
      }
    }
    return list;
  }
}
