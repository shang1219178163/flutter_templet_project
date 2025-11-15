//
//  DbManager.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/24 09:00.
//  Copyright © 2024/2/24 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';

import 'package:flutter_templet_project/vendor/isar/model/db_order.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/provider/gex_controller/db_generic_controller.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// 数据库管理类
class DBManager {
  DBManager._();
  static final DBManager _instance = DBManager._();
  factory DBManager() => _instance;
  static DBManager get instance => _instance;

  String get exception => _exception ?? "";

  String? _exception;

  late Isar? isar;

  /// 会话详情控制器
  late DBGenericController<DBTodo>? todoModelController;

  /// 群详情控制器
  late DBGenericController<DBStudent>? studentModelController;

  /// 聊天信息控制器
  late DBGenericController<DBOrder>? orderModelController;

  /// 监听列表
  final List<VoidCallback> _listeners = [];

  // 添加监听
  void addListener(VoidCallback cb) {
    if (_listeners.contains(cb)) {
      return;
    }
    _listeners.add(cb);
  }

  // 移除监听
  void removeListener(VoidCallback cb) {
    _listeners.remove(cb);
  }

  // 通知所有监听器
  void notifyListeners() {
    for (final ltr in _listeners) {
      ltr();
    }
  }

  Future<void> init() async {
    try {
      isar = null;
      todoModelController = null;
      studentModelController = null;
      orderModelController = null;

      isar = await _openDB(schemas: [
        DBTodoSchema,
        DBStudentSchema,
        DBOrderSchema,
      ]);
      todoModelController = Get.put(DBGenericController<DBTodo>(), tag: isar!.name);
      studentModelController = Get.put(DBGenericController<DBStudent>(), tag: isar!.name);
      orderModelController = Get.put(DBGenericController<DBOrder>(), tag: isar!.name);

      notifyListeners();
      DLog.d("$runtimeType 初始化成功");
    } catch (e) {
      DLog.d("❌ $runtimeType 初始化失败: $e");
      _exception = e.toString();
    } finally {
      logDB(prefix: "openDB");
    }
  }

  /// 打开 DB
  Future<Isar> _openDB({
    required List<CollectionSchema<dynamic>> schemas,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final result = await Isar.open(
      schemas,
      directory: dir.path,
      inspector: !kReleaseMode,
    );
    DLog.d("openDB: \n ${dir.path}");
    return result;
  }

  /// 打开 DB
  Future<bool> closeDB({bool deleteFromDisk = false}) async {
    try {
      final result = await isar!.close(deleteFromDisk: deleteFromDisk);
      return result;
    } catch (e) {
      DLog.d("$runtimeType closeDB exception: $e");
    } finally {
      logDB(prefix: "closeDB after");
    }
    return false;
  }

  /// 清空数据库
  Future<void> clear() async {
    await isar?.writeTxn(() async {
      await isar?.clear();
    });
  }

  /// 数据库配置打印
  void logDB({String? prefix = 'debugPrint', dynamic params}) {
    DLog.d("$runtimeType $prefix ${[
      DBManager().isar?.hashCode,
      DBManager().isar?.name,
      DBManager().isar?.isOpen,
      params,
    ].asMap()}");
  }
}
