//
//  DbStudentProvider.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/24 09:09.
//  Copyright © 2024/2/24 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:isar/isar.dart';


class DBStudentProvider<E extends DBStudent> extends ChangeNotifier {
  DBStudentProvider() {
    init();
  }

  final isar = DBManager().isar;

  final List<E> _entitys = <E>[];
  List<E> get entitys => _entitys;

  Future<void> init() async {
    isar.txn(() async {
      await update();
    });
  }

  /// 查
  Future<void> update() async {
    final items = await isar.collection<E>().where().findAll();
    _entitys.clear();
    _entitys.addAll(items);
    notifyListeners();
  }

  /// 增/改
  Future<void> putAll(List<E> list) async {
    await isar.writeTxn(() async {
      await isar.collection<E>().putAll(list);
      await update();
    });
  }
  /// 增/改
  Future<void> put(E e) async {
    await putAll([e]);
  }

  /// 删
  Future<void> deleteAll(List<Id> ids) async {
    await isar.writeTxn(() async {
      final count = await isar.collection<E>().deleteAll(ids);
      debugPrint('$this deleted $count');

      await update();
    });
  }

  /// 删
  Future<void> delete(Id id) async {
    await deleteAll([id]);
  }

}