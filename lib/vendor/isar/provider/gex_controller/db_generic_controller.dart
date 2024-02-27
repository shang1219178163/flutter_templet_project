//
//  DbTodoController.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/24 09:36.
//  Copyright © 2024/2/24 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';


class DBGenericController<E> extends GetxController {
  DBGenericController() {
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
  @override
  Future<void> update([List<Object>? ids, bool condition = true]) async {
    if (!Get.isRegistered<DBGenericController<E>>()) {
      return;
    }
    await getAllEntitys();
    super.update(ids, condition);
  }

  /// 过滤
  List<E> filterEntitys({List<E> Function(QueryBuilder<E, E, QFilterCondition> isarItems)? filterCb}) {
    final collections = isar.collection<E>();
    final items = filterCb?.call(collections.filter()) ?? collections.where().findAllSync();
    _entitys.clear();
    _entitys.addAll(items);
    return _entitys;
  }

  /// 获取所有实体
  Future<List<E>> getAllEntitys() async {
    return filterEntitys();
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
