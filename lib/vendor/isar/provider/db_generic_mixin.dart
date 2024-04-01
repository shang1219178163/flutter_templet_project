//
//  DbGenericMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/1 14:16.
//  Copyright © 2024/4/1 shang. All rights reserved.
//


import 'package:isar/isar.dart';

/// 类协议
mixin DbGenericMixin<E> {

  /// 过滤
  ///
  /// filterCb 为空,返回所有实体
  Future<List<E>> filterEntitys({Future<List<E>> Function(QueryBuilder<E, E, QFilterCondition> isarItems)? filterCb}) async {
    throw UnimplementedError();
  }

  /// 寻找第一个
  Future<E?> filterEntity({required Future<E?> Function(QueryBuilder<E, E, QFilterCondition> isarItems) filterCb}) async {
    throw UnimplementedError();
  }

  /// 增/改
  Future<void> putAll(List<E> list) async {
    throw UnimplementedError();
  }

  /// 增/改
  Future<void> put(E e) async {
    await putAll([e]);
  }

  /// 删
  Future<void> deleteAll(List<Id> ids) async {
    throw UnimplementedError();
  }

  /// 删
  Future<void> delete(Id id) async {
    await deleteAll([id]);
  }

  /// 模型字段更新
  Future<void> migrate({int limit = 50,}) async {
    throw UnimplementedError();
  }
}