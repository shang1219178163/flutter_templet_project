//
//  DbManager.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/24 09:00.
//  Copyright © 2024/2/24 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
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

  late Isar isar;

  /// 会话详情控制器
  late DBGenericController<DBTodo> todoModelController;

  /// 群详情控制器
  late DBGenericController<DBStudent> studentModelController;

  /// 聊天信息控制器
  late DBGenericController<DBOrder> orderModelController;

  Future<void> init() async {
    try {
      isar = await _openDB(schemas: [
        DBTodoSchema,
        DBStudentSchema,
        DBOrderSchema,
      ]);
      todoModelController = Get.put(DBGenericController<DBTodo>());
      studentModelController = Get.put(DBGenericController<DBStudent>());
      orderModelController = Get.put(DBGenericController<DBOrder>());
    } catch (e) {
      debugPrint("$this $e");
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
  Future<bool> _closeDB({bool deleteFromDisk = false}) async {
    if (!isar.isOpen) {
      return false;
    }
    final result = await isar.close(deleteFromDisk: deleteFromDisk);
    return result;
  }

  /// 清空数据库
  Future<void> clear() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
