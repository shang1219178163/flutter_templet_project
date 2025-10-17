// ignore_for_file: dead_code

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// CacheService 阎村key
enum CacheKey {
  seedColor(needLogin: false, desc: "主题色"),
  brightness(needLogin: false, desc: "亮度"),

  localOperateLog(needLogin: false, desc: "本地操作日志缓存"),
  requestEnv(needLogin: false, desc: "请求环境"),
  requestEnvDevOrigin(needLogin: false, desc: "请求环境(dev)"),
  requestError(needLogin: false, desc: "请求错误缓存"),
  appName(needLogin: false, desc: "App名称"),
  appVersion(needLogin: false, desc: "App版本号"),
  appVersionCode(needLogin: false, desc: "App版本号(安卓)"),
  appPackageName(needLogin: false, desc: "App包名Com.Yilian.Ylhealthapp"),
  token(needLogin: false, desc: "token"),
  loginAccount(needLogin: false, desc: "用户登录账号"),
  loginPwd(needLogin: false, desc: "账号密码"),
  userId(needLogin: true, desc: "用户id"),
  registrationId(needLogin: true, desc: "极光注册id"),
  lastJPush(needLogin: true, desc: "极光推送消息"),
  lastRequestError(needLogin: true, desc: "最后一次请求报错"),
  tagRootModel(needLogin: true, desc: "标签缓存"),
  accountList(needLogin: false, desc: "账号列表"),
  lastPageRoute(needLogin: true, desc: "重启app前页面路由"),
  resetLastPageRoute(needLogin: true, desc: "是否恢复重启前页面路由");

  const CacheKey({
    required this.desc,
    required this.needLogin,
  });

  /// 当前枚举对应的 描述文字
  final String desc;

  /// 仅登录可用
  final bool needLogin;
}

enum CacheNewKey {
  aaa(needLogin: true, desc: "用户id"),
  bbb(needLogin: true, desc: "标签缓存"),
  ccc(needLogin: false, desc: "账号列表");

  const CacheNewKey({
    required this.desc,
    required this.needLogin,
  });

  /// 当前枚举对应的 描述文字
  final String desc;

  /// 仅登录可用
  final bool needLogin;
}

class CacheService {
  CacheService._() {
    init();
  }

  static final CacheService _instance = CacheService._();

  factory CacheService() => _instance;

  static CacheService get shard => _instance;

  SharedPreferences? _prefs;
  SharedPreferences get prefs => _prefs!;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    // debugPrint("init prefs: $prefs");
  }

  /// memory cache, 内存缓存
  final _memoryMap = <String, dynamic>{};

  /// 获取持久化数据中所有存入的key
  Set<String> getKeys() {
    return prefs.getKeys();
  }

  /// 获取持久化数据中是否包含某个key
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  /// 重新加载所有数据,仅重载运行时
  Future<void> reload() async {
    return prefs.reload();
  }

  /// 清除数据
  Future<bool> remove(String key) {
    _memoryMap.remove(key);
    return prefs.remove(key);
  }

  /// 退出登录时清除
  Future<bool>? clear() async {
    for (final e in CacheKey.values) {
      if (e.needLogin) {
        await remove(e.name);
      }
    }
    return true;
  }

  /// 动态值
  Object? operator [](String key) {
    final val = prefs.get(key);
    return val;
  }

  /// 动态复制
  void operator []=(String key, String? val) {
    if (val == null) {
      return;
    }
    prefs.setString(key, val);
  }

  /// 泛型获取值
  Future<bool> set<T>(String key, T value) {
    switch (T) {
      case bool:
        return prefs.setBool(key, value as bool);
        break;
      case int:
        return prefs.setInt(key, value as int);
        break;
      case double:
        return prefs.setDouble(key, value as double);
        break;
      case String:
        return prefs.setString(key, value as String);
        break;
      default:
        try {
          var jsonStr = jsonEncode(value);
          return prefs.setString(key, jsonStr);
        } catch (e) {
          debugPrint("$this $e");
        }
        break;
    }
    return Future.value(false);
  }

  /// 泛型获取值
  T? get<T>(String key) {
    var value = prefs.get(key);
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
      debugPrint("$this $e");
    }
    return value as T?;
  }

  FutureOr<bool> setStringList(String key, List<String>? value) {
    if (value == null) {
      return false;
    }
    return prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  /// 模型列表转存
  FutureOr<bool> setModels<T>({
    required String key,
    required List<T> value,
    required Map<String, dynamic> Function(T e) mapCb,
  }) {
    if (value.isNotEmpty != true) {
      return Future.value(false);
    }
    var list = value.map((e) {
      final result = jsonEncode(mapCb(e));
      return result;
    }).toList();
    return CacheService().setStringList(key, list);
  }

  /// 模型列表读取
  List<T> getModels<T>({
    required String key,
    required T Function(Map<String, dynamic> map) modelCb,
  }) {
    final value = CacheService().getStringList(key);
    if (value == null || value.isNotEmpty != true) {
      return <T>[];
    }

    final result = value.map((e) {
      final json = jsonDecode(e) as Map<String, dynamic>;
      return modelCb(json);
    }).toList();
    return result;
  }

  FutureOr<bool> setString(String key, String? value) async {
    if (value == null) {
      return false;
    }
    final result = await prefs.setString(key, value);
    return result;
  }

  String? getString(String key) {
    final result = prefs.getString(key);
    return result;
  }

  FutureOr<bool> setDouble(String key, double? value) {
    if (value == null) {
      return false;
    }
    return prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  FutureOr<bool> setInt(String key, int? value) {
    if (value == null) {
      return false;
    }
    return prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  FutureOr<bool> setBool(String key, bool? value) {
    if (value == null) {
      return false;
    }
    return prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  FutureOr<bool> setMap(String key, Map<String, dynamic>? value) {
    if (value == null) {
      return false;
    }
    try {
      final jsonStr = jsonEncode(value);
      return setString(key, jsonStr);
    } catch (e) {
      debugPrint("$this $e");
    }
    return false;
  }

  Map<String, dynamic>? getMap(String key) {
    var value = prefs.getString(key);
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

  /// 更新
  Future<Map<String, dynamic>> updateMap({
    required String key,
    required Map<String, dynamic> Function(Map<String, dynamic> v) onUpdate,
  }) async {
    final map = CacheService().getMap(key) ?? <String, dynamic>{};
    final mapNew = onUpdate(map);
    await CacheService().setMap(key, mapNew);
    final mapAfter = CacheService().getMap(key) ?? {};
    return mapAfter;
  }

  /// 标签
  set tagsRootModel(TagsRootModel? model) {
    if (model == null) {
      return;
    }
    _memoryMap[CacheKey.tagRootModel.name] = model.toJson();
    CacheService().setMap(CacheKey.tagRootModel.name, model.toJson());
  }

  TagsRootModel? get tagsRootModel {
    final val = _memoryMap[CacheKey.tagRootModel.name];
    final json = val ?? CacheService().getMap(CacheKey.tagRootModel.name);
    if (json == null) {
      return null;
    }
    final model = TagsRootModel.fromJson(json);
    return model;
  }

  /// 更新本地操作日志
  Future<Map<String, String>> updateLogs({required String value, bool isClear = false}) async {
    final cacheKey = CacheKey.localOperateLog.name;
    final cache = getMap(cacheKey) ?? {};
    final map = Map<String, String>.from(cache);
    if (value.isEmpty) {
      return map;
    }

    if (isClear) {
      map.clear();
    }
    map[value] = DateTime.now().toString().substring(0, 23);
    await setMap(cacheKey, map);
    return map;
  }
}

extension CacheServiceExt on CacheService {
  /// 清除缓存数据
  Future<bool>? clear() async {
    final env = CacheService().getString(CacheKey.requestEnv.name);

    final isClear = await prefs.clear();
    debugPrint("isClear: $isClear");

    CacheService().setString(CacheKey.requestEnv.name, env);

    return Future.value(true);
  }

  Future<void> noClear(List<String> keys, VoidCallback onDone) async {
    final tuples = keys.map((key) {
      final value = CacheService().getString(key);
      return (key, value);
    });

    onDone();

    tuples.forEach((e) {
      CacheService().set(e.$1, e.$2);
    });
  }

  List<String> get noClearKeys {
    return [
      CacheKey.requestEnv.name,
    ];
  }

  /// 清除登录环境
  clearEnv() {
    CacheService().remove(CacheKey.requestEnv.name);
  }

  /// 设置登录环境
  set env(AppEnvironment? val) {
    if (val == null) {
      return;
    }
    final result = val.toString();
    CacheService().setString(CacheKey.requestEnv.name, result);
  }

  /// 获取登录环境
  AppEnvironment? get env {
    final result = CacheService().getString(CacheKey.requestEnv.name);
    final val = AppEnvironment.fromString(result);
    return val;
  }

  /// 设置登录环境 dev 下的域名
  set devOrigin(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CacheKey.requestEnvDevOrigin.name, val);
  }

  /// 获取登录环境 dev 下的域名
  String? get devOrigin {
    return CacheService().getString(CacheKey.requestEnvDevOrigin.name);
  }

  /// 医链执业版
  String? get appName {
    return CacheService().getString(CacheKey.appName.name);
  }

  /// 1.0.0
  String? get appVersion {
    return CacheService().getString(CacheKey.appVersion.name);
  }

  /// 应用版本号 100
  String? get appVersionCode {
    return CacheService().getString(CacheKey.appVersionCode.name);
  }

  /// com.yilian.ylHealthApp
  String? get packageName {
    return CacheService().getString(CacheKey.appPackageName.name);
  }

  /// 设置 token
  set token(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CacheKey.token.name, val);
  }

  /// 获取token
  String? get token {
    return CacheService().getString(CacheKey.token.name);
  }

  /// 是否是登录状态
  bool get isLogin {
    final token = CacheService().token ?? "";
    final result = token.isNotEmpty;
    return result;
  }

  /// 设置登录账号
  set loginAccount(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CacheKey.loginAccount.name, val);
  }

  /// 获取登录账号
  String? get loginAccount {
    return CacheService().getString(CacheKey.loginAccount.name);
  }

  /// 设置 登录账号密码
  set loginPwd(String? val) {
    if (val == null || val.isEmpty) {
      return;
    }
    CacheService().setString(CacheKey.loginPwd.name, val);
  }

  /// 获取登录账号密码
  String? get loginPwd {
    return CacheService().getString(CacheKey.loginPwd.name);
  }

  /// 获取用户id
  String? get userID {
    return CacheService().getString(CacheKey.userId.name);
  }
}
