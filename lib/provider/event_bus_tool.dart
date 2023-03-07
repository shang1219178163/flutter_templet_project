//
//  event_bus_tool.dart
//  flutter_templet_project
//
//  Created by shang on 10/14/21 4:46 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//


//订阅者回调签名
import 'dart:async';
import 'package:flutter/material.dart';

typedef void EventCallback(arg);

/// 自定义时间总线
class EventBusTool {
  //私有构造函数
  EventBusTool._internal();

  //保存单例
  static EventBusTool _instance = EventBusTool._internal();

  //工厂构造函数
  factory EventBusTool() => _instance;

  static EventBusTool get instance => _instance;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _map = Map<Object, List<EventCallback>?>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    _map[eventName] ??= <EventCallback>[];
    _map[eventName]!.add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback? f]) {
    var list = _map[eventName] ?? [];
    if (f == null) {
      _map[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _map[eventName] ?? [];
    int length = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = length; i > -1; --i) {
      list[i](arg);
    }
  }
}
