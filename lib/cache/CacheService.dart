
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 请求错误缓存
const String CACHE_REQUEST_ERROR = "CACHE_REQUEST_ERROR";

/// 缓存app 名称
const String CACHE_APP_NAME = "CACHE_APP_NAME"; // 医链执业版
/// 缓存app 版本号
const String CACHE_APP_VERSION = "CACHE_APP_VERSION"; // 1.0.0
/// 缓存app 包名 - com.yilian.ylHealthApp
const String CACHE_APP_PACKAGE_NAME = "CACHE_APP_PACKAGE_NAME";

const String CACHE_TOKEN = "CACHE_TOKEN";

/// 用户信息 key
const String CACHE_USER_ID = "CACHE_USER_ID";


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


extension CacheServiceExt on CacheService {
  /// 医链执业版
  String? get appName {
    return CacheService().getString(CACHE_APP_NAME);
  }

  /// 1.0.0
  String? get appVersion {
    return CacheService().getString(CACHE_APP_VERSION);
  }

  /// com.yilian.ylHealthApp
  String? get packageName {
    return CacheService().getString(CACHE_APP_PACKAGE_NAME);
  }

  /// 设置 token
  set token(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CACHE_TOKEN, val);
  }

  /// 获取token
  String? get token {
    return CacheService().getString(CACHE_TOKEN);
  }

  /// 是否是登录状态
  bool get isLogin {
    final token = CacheService().token ?? "";
    final result = token.isNotEmpty;
    return result;
  }

  /// 获取用户id
  String? get userID {
    return CacheService().getString(CACHE_USER_ID);
  }

}