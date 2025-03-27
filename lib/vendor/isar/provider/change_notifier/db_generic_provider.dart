//
//  DbStudentProvider.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/24 09:09.
//  Copyright © 2024/2/24 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:isar/isar.dart';

class DBGenericProvider<E> extends ChangeNotifier {
  DBGenericProvider() {
    init();
  }

  Isar get isar => DBManager().isar!;

  final List<E> _entitys = <E>[];
  List<E> get entitys => _entitys;

  Future<void> init() async {
    isar.txn(() async {
      await update();
    });
  }

  /// 查
  Future<void> update() async {
    await findEntitys();
    notifyListeners();
  }

  /// 查
  ///
  /// filterCb 为空,返回所有实体
  Future<List<E>> findEntitys(
      {Future<List<E>> Function(QueryBuilder<E, E, QFilterCondition> isarItems)? filterCb}) async {
    final collections = isar.collection<E>();
    final filters = collections.filter();
    final items = await filterCb?.call(filters) ?? await collections.where().findAll();
    _entitys.clear();
    _entitys.addAll(items);
    return _entitys;
  }

  /// 寻找第一个
  Future<E?> findEntity({required Future<E?> Function(QueryBuilder<E, E, QFilterCondition> isarItems) filterCb}) async {
    final collections = isar.collection<E>();
    final filters = collections.filter();
    final item = await filterCb(filters);
    return item;
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

  /// 模型字段更新
  Future<void> migrate({
    int limit = 50,
  }) async {
    final collections = isar.collection<E>();
    final count = await collections.count();

    // 我们对用户数据进行分页读写，避免同时将所有数据存放到内存
    for (var i = 0; i < count; i += limit) {
      final models = await collections.where().offset(i).limit(limit).findAll();
      await isar.writeTxn(() async {
        // 我们不需要更新任何信息，因为 字段 的 getter 已经被使用
        await collections.putAll(models);
      });
    }
  }
}
