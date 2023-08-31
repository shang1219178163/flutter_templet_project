
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {

  CacheService._() {
    init();
  }

  static final CacheService _instance = CacheService._();

  factory CacheService() => _instance;

  static CacheService get shard => _instance;

  SharedPreferences? prefs;

  init() async {
    prefs ??= await SharedPreferences.getInstance();
    debugPrint("init prefs: $prefs");
  }



  /// 动态值
  Object? operator [](String key){
    final val = prefs?.get(key);
    return val;
  }

  /// 动态复制
  void operator []=(String key, String? val){
    if (val == null) {
      return;
    }
    prefs?.setString(key, val);
  }

  /// 泛型获取值
  void set<T>(String key, T? value) {
    if (value == null) {
      return;
    }
    switch (T) {
      case String:
        prefs?.setString(key, value as String);
        break;
      case int:
        prefs?.setInt(key, value as int);
        break;
      case bool:
        prefs?.setBool(key, value as bool);
        break;
      case double:
        prefs?.setDouble(key, value as double);
        break;
      case Map:
      case List:
        var jsonStr = jsonEncode(value);
        prefs?.setString(key, jsonStr);
        break;
    }
  }

  /// 泛型获取值
  T? get<T>(String key) {
    var value = prefs?.get(key);
    if (value == null) {
      return null;
    }
    if (value is! String) {
      return value as T?;
    }

    try {
      var result = jsonDecode(value);
      return result;
    } catch (e) {
      return value as T?;
    }
  }

}