import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// 缓存app 名称
const String CACHE_APP_NAME = "CACHE_APP_NAME";// 医链健康执业版
/// 缓存app 版本信息
const String CACHE_APP_VERSION = "CACHE_APP_VERSION";// 1.0.0
/// 缓存app 包名
const String CACHE_APP_PACKAGE_NAME = "CACHE_APP_PACKAGE_NAME";//com.yilian.ylHealthAp

/// 缓存用户信息 key
const String CACHE_TOKEN = "TOKEN";


class CacheService {
  CacheService._() {
    init();
  }

  static final CacheService _instance = CacheService._();

  factory CacheService() => _instance;
  // static CacheService get shared => _instance;
  // static CacheService getInstance() => _instance;

  SharedPreferences? prefs;

  init() async {
    prefs ??= await SharedPreferences.getInstance();
    // debugPrint("init: $prefs");
  }

  // /// 清除数据
  // Future<bool> clear(String key) async {
  //   final sp = await SharedPreferences.getInstance();
  //   return sp.remove(key);
  // }

  /// 清除数据
  Future<bool>? remove(String key) {
    return prefs?.remove(key);
  }

  /// 清除所有数据
  Future<bool>? clear() {
    return prefs?.clear();
  }

  /// 存储数据
  save<T>(String key, T value) async {
    var sp = await SharedPreferences.getInstance();
    switch (T) {
      case String:
        sp.setString(key, value as String);
        break;
      case int:
        sp.setInt(key, value as int);
        break;
      case bool:
        sp.setBool(key, value as bool);
        break;
      case double:
        sp.setDouble(key, value as double);
        break;
      case Map:
      case List:
        var jsonStr = const JsonEncoder().convert(value);
        sp.setString(key, jsonStr);
        break;
      default:
        var jsonStr = const JsonEncoder().convert(value);
        sp.setString(key, jsonStr);
        break;
    }
  }

  /// 获取数据
  Future<T?> get<T>(String key) async {
    var sp = await SharedPreferences.getInstance();
    switch (T) {
      case int:
      case bool:
      case double:
      case String:
        return sp.get(key) as T?;
      case Map:
      case List:
        var jsonStr = sp.get(key) as String?;
        if (jsonStr != null) {
          var value = const JsonDecoder().convert(jsonStr);
          return Future.value(value as T);
        }
        return Future.value(null);
      default:
        dynamic value = sp.get(key) as T?;
        if (value == null) {
          return Future.value(null);
        }
        var result = const JsonDecoder().convert(value);
        return Future.value(result);
    }
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
    return jsonDecode(value) as Map<String, dynamic>?;
  }
}


extension CacheServiceExt on CacheService{
  /// 医链健康执业版
  String? getAppNam(){
    return CacheService().getString(CACHE_APP_NAME);
  }
  /// 1.0.0
  String? getVersion(){
    return CacheService().getString(CACHE_APP_VERSION);
  }
  /// com.yilian.ylHealthApp
  String? getPackageName(){
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

  bool get isLogin{
    final token = CacheService().token ?? "";
    final result = token.isNotEmpty;
    return result;
  }

}