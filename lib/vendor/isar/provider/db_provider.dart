//
//  DbTodoProvider.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/23 22:42.
//  Copyright © 2024/2/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// 待办事项基于 isar 数据库的 Provider 实现
class DBProvider extends ChangeNotifier {
  DBProvider() {
    init();
  }

  late Isar isar;

  /// 待办事项
  final List<DBTodo> _todos = <DBTodo>[];
  List<DBTodo> get todos => _todos;

  /// 学生列表
  final List<DBStudent> _students = <DBStudent>[];
  List<DBStudent> get students => _students;

  Future<void> init() async {
    isar = await openDB(schemas: [
      DBTodoSchema,
      DBStudentSchema,
    ]);
    isar.txn(() async {
      await update<DBTodo>();
      await update<DBStudent>();
    });
  }

  /// 查
  Future<void> update<E>() async {
    final items = await isar.collection<E>().where().findAll();
    if (items is List<DBTodo>) {
      _todos.clear();
      _todos.addAll(items as List<DBTodo>);
    }
    else if (items is List<DBStudent>) {
      _students.clear();
      _students.addAll(items as List<DBStudent>);
    }
    notifyListeners();
  }

  Future<Isar> openDB({required List<CollectionSchema<dynamic>> schemas,}) async {
    final dir = await getApplicationDocumentsDirectory();
    final result = await Isar.open(
      schemas,
      directory: dir.path,
      inspector: true,
    );
    return result;
  }

  /// 增/改
  Future<void> putAll<E>(List<E> list) async {
    await isar.writeTxn(() async {
      await isar.collection<E>().putAll(list);
      await update<E>();
    });
  }
  /// 增/改
  Future<void> put<E>(E e) async {
    await putAll<E>([e]);
  }

  /// 删
  Future<void> deleteAll<E>(List<Id> ids) async {
    await isar.writeTxn(() async {
      final count = await isar.collection<E>().deleteAll(ids);
      debugPrint('$this deleted $count');

      await update<E>();
    });
  }

  /// 删
  Future<void> delete<E>(Id id) async {
    await deleteAll<E>([id]);
  }

}
