
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

  /// 清除数据
  Future<bool>? remove(String key) {
    return prefs?.remove(key);
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
        try {
          var jsonStr = jsonEncode(value);
          prefs?.setString(key, jsonStr);
        } catch (e) {
          debugPrint("$this $e");
        }
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


  setStringList(String key, List<String>? value) {
    if (value == null) {
      return;
    }
    prefs?.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs?.getStringList(key);
  }

  setString(String key, String? value) {
    if (value == null) {
      return;
    }
    prefs?.setString(key, value);
  }

  String? getString(String key) {
    final result = prefs?.getString(key);
    return result;
  }

  setDouble(String key, double? value) {
    if (value == null) {
      return;
    }
    prefs?.setDouble(key, value);
  }

  double? getDouble(String key) {
    return prefs?.getDouble(key);
  }

  setInt(String key, int? value) {
    if (value == null) {
      return;
    }
    prefs?.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs?.getInt(key);
  }

  setBool(String key, bool? value) {
    if (value == null) {
      return;
    }
    prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs?.getBool(key);
  }

  setMap(String key, Map<String, dynamic>? value) {
    if (value == null) {
      return;
    }
    try {
      final jsonStr = jsonEncode(value);
      setString(key, jsonStr);
    } catch (e) {
      debugPrint("$this $e");
    }
  }

  Map<String, dynamic>? getMap(String key) {
    var value = prefs?.getString(key);
    if (value == null) {
      return null;
    }
    Map<String, dynamic>? map = <String, dynamic>{};
    try {
      map = jsonDecode(value) as Map<String, dynamic>?;
    } catch (e) {
      debugPrint("getMap${e.toString()}");
    }
    return map;
  }
}