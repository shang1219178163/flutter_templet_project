//
//  DbManager.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/24 09:00.
//  Copyright © 2024/2/24 shang. All rights reserved.
//

import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_order.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/provider/gex_controller/db_generic_controller.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// 数据库管理类
class DBManager {
  factory DBManager() => instance;
  DBManager._();
  static final DBManager instance = DBManager._();

  /// GetX 控制器统一 tag，页面用 [findController]
  static const String controllerTag = 'db_manager';

  static final _schemas = <CollectionSchema<dynamic>>[
    DBTodoSchema,
    DBStudentSchema,
    DBOrderSchema,
  ];

  String? _exception;
  String get exception => _exception ?? '';

  Isar? _isar;
  bool get isReady => _isar?.isOpen ?? false;

  Isar get isar {
    assert(isReady, 'DBManager 未初始化或已关闭${_exception ?? ''}');
    return _isar!;
  }

  final _listeners = <VoidCallback>[];

  static bool isControllerRegistered<E>() {
    return Get.isRegistered<DBGenericController<E>>(tag: controllerTag);
  }

  static DBGenericController<E> findController<E>() {
    assert(instance.isReady && isControllerRegistered<E>(), 'DBManager/Controller<$E> 未就绪');
    return Get.find<DBGenericController<E>>(tag: controllerTag);
  }

  void addListener(VoidCallback cb) {
    if (!_listeners.contains(cb)) {
      _listeners.add(cb);
    }
  }

  void removeListener(VoidCallback cb) => _listeners.remove(cb);

  void notifyListeners() {
    for (final cb in _listeners) {
      cb();
    }
  }

  Future<void> init() async {
    _exception = null;
    try {
      await closeDB();
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        _schemas,
        directory: dir.path,
        inspector: !kReleaseMode,
      );
      Get
        ..put(DBGenericController<DBTodo>(), tag: controllerTag)
        ..put(DBGenericController<DBStudent>(), tag: controllerTag)
        ..put(DBGenericController<DBOrder>(), tag: controllerTag);
      notifyListeners();
      DLog.d('$runtimeType 初始化成功 path=${dir.path}');
    } catch (e) {
      _exception = e.toString();
      DLog.d('❌ $runtimeType 初始化失败: $e');
      await closeDB();
    } finally {
      logDB(prefix: 'openDB');
    }
  }

  /// 关闭 DB、清理控制器；[init] 重开/失败回滚也走这里
  Future<void> closeDB({bool deleteFromDisk = false}) async {
    await _deleteController<DBTodo>();
    await _deleteController<DBStudent>();
    await _deleteController<DBOrder>();

    final db = _isar;
    _isar = null;
    if (db?.isOpen ?? false) {
      await db!.close(deleteFromDisk: deleteFromDisk);
    }
  }

  Future<void> clear() => isar.writeTxn(isar.clear);

  Future<void> _deleteController<E>() async {
    if (Get.isRegistered<DBGenericController<E>>(tag: controllerTag)) {
      await Get.delete<DBGenericController<E>>(tag: controllerTag, force: true);
    }
  }

  void logDB({String prefix = 'debugPrint', Object? params}) {
    DLog.d('$runtimeType $prefix ${[
      _isar?.hashCode,
      _isar?.name,
      _isar?.isOpen,
      isReady,
      params,
    ].asMap()}');
  }
}
