//
//  notifier_demo.dart
//  flutter_templet_project
//
//  Created by shang on 10/13/21 1:58 PM.
//  Copyright © 10/13/21 shang. All rights reserved.
//

///推荐使用 ValueNotifier, ChangeNotifier 太繁琐

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/model/order_model.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

/// ChangeNotifier(不推荐使用,麻烦)
class CartModel extends ChangeNotifier {
  final List<OrderModel> _items = []; // 购物车内容, 设为private
  // 只读的购物车内容(getter)
  UnmodifiableListView<OrderModel> get items => UnmodifiableListView(_items);

  // double get totalPrice => _items.map((e) => e.pirce).reduce((value, element) => value + element); // 当前购物车总价的getter(假设每件都是42块)
  double get totalPrice {
    if (_items.isEmpty) {
      return 0;
    }
    return _items
        .map((e) => e.pirce)
        .reduce((value, e) => value + e)
        .roundToDouble();
  }

  /// 加入物品到购物车
  void add(OrderModel item) {
    _items.add(item);
    notifyListeners(); // <==***This call tells the widgets that are listening to this model to rebuild.
  }

  /// 删除商品
  void remove(int index) {
    if (_items.length < index) {
      return;
    }
    _items.removeAt(index);
    notifyListeners(); // <==***This call tells the widgets that are listening to this model to rebuild.
  }

  /// 删除最后商品
  void removeLast() {
    if (_items.isEmpty) {
      return;
    }
    _items.removeLast();
    notifyListeners(); // <==***This call tells the widgets that are listening to this model to rebuild.
  }

  /// 清空购物车
  void removeAll() {
    _items.clear();
    notifyListeners(); // <==***This call tells the widgets that are listening to this model to rebuild.
  }

  @override
  String toString() {
    return "${runtimeType} 共 ${_items.length} 件商品,总价: ¥${totalPrice.toString()}";
  }
}

/// ValueNotifier<List<OrderModel>>(替代品 ValueNotifierList)
class ValueNotifierOrderModels extends ValueNotifier<List<OrderModel>> {
  ValueNotifierOrderModels() : super(<OrderModel>[]); // 构造函数要提供value的初始值

  // double get totalPrice => value.map((e) => e.pirce).reduce((value, element) => value + element); // 当前购物车总价的getter(假设每件都是42块)
  double get totalPrice {
    if (value.isEmpty) {
      return 0;
    }
    return value
        .map((e) => e.pirce)
        .reduce((value, element) => value + element)
        .roundToDouble();
  }

  void add(OrderModel item) {
    value.add(item);
    _copyValue();
  }

  /// 删除
  void remove(int index) {
    if (value.length < index) {
      return;
    }
    value.removeAt(index);
    _copyValue();
  }

  /// 删除最后商品
  void removeLast() {
    if (value.isEmpty) {
      return;
    }
    value.removeLast();
    _copyValue();
  }

  void removeAll() {
    value.clear();
    _copyValue();
  }

  /// 进行深copy(原理与iOS的kvo原理类似.list添加元素,未改变地址,所以无法触发监听,利用深copy 重新赋值,就触发监听了)
  void _copyValue() {
    value = [...value];
  }

  @override
  String toString() {
    return "${runtimeType} 共 ${value.length} 件商品,总价: ¥${totalPrice.toString()}";
  }
}

/// 泛型数组监听
class ValueNotifierList<T> extends ValueNotifier<List<T>> {
  ValueNotifierList(List<T> initValue) : super(initValue);

  void add(T item) {
    value.add(item);
    _copyValue();
  }

  /// 删除
  void remove(int index) {
    if (value.length < index) {
      return;
    }
    value.removeAt(index);
    _copyValue();
  }

  /// 删除最后
  void removeLast() {
    if (value.isEmpty) {
      return;
    }
    value.removeLast();
    _copyValue();
  }

  void removeAll() {
    value.clear();
    _copyValue();
  }

  /// 进行深copy(原理与iOS的kvo原理类似.list添加元素,未改变地址,所以无法触发监听,利用深copy 重新赋值,就触发监听了)
  void _copyValue() {
    value = [...value];
  }

  @override
  String toString() {
    return "${runtimeType} total: ${value.length} count}";
  }
}

/// StateNotifier(需要安装第三方插件包)

/// ValueNotifier<int>
class ValueNotifierNum extends ValueNotifier<num> {
  ValueNotifierNum(
      {this.initValue = 0,
      this.minValue = 0,
      this.maxValue = 100000,
      this.block})
      : super(initValue);

  num initValue;

  num minValue;

  num maxValue;

  void Function(num minValue, num maxValue)? block;

  void add(num val) {
    if (val < 0 && value <= minValue) {
      if (block != null) block!(minValue, maxValue);
      return;
    }

    if (val > 0 && value >= maxValue) {
      if (block != null) block!(minValue, maxValue);
      return;
    }
    value += val;
  }

  @override
  String toString() {
    return "${runtimeType} 当前值 ${value.toString()}";
  }
}

extension ValueNotierExtension<T> on T {
  /// ValueNotifier<T>
  ValueNotifier<T> get notifier => ValueNotifier<T>(this);
}

/// 购物车重新定义
class CartModelNew extends ValueNotifierList<OrderModel> {
  CartModelNew(List<OrderModel> value) : super(value);

  double get totalPrice {
    if (value.isEmpty) {
      return 0;
    }
    return value
        .map((e) => e.pirce)
        .reduce((value, element) => value + element)
        .roundToDouble();
  }
}
