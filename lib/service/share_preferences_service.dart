import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SharePreferenceService {
  SharePreferenceService._();

  static final SharePreferenceService _instance = SharePreferenceService._();

  factory SharePreferenceService() => _instance;

  static SharePreferenceService get instance => _instance;

  /// 清除数据
  Future<bool> clear(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove(key);
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
}
