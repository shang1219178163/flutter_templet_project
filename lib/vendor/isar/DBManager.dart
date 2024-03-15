//
//  DbManager.dart
//  flutter_templet_project
//
//  Created by shang on 2024/2/24 09:00.
//  Copyright © 2024/2/24 shang. All rights reserved.
//




import 'package:flutter_templet_project/vendor/isar/model/db_order.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// 数据库管理类
class DBManager {
  DBManager._();
  static final DBManager _instance = DBManager._();
  factory DBManager() => _instance;
  static DBManager get instance => _instance;

  late Isar isar;

  Future<void> init() async {
    isar = await openDB(schemas: [
      DBTodoSchema,
      DBStudentSchema,
      DBOrderSchema,
    ]);
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

}