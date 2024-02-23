//
// import 'package:flutter/material.dart';
// import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
//
// /// 待办事项基于 isar 数据库的 Provider 实现
// class DBStudentProvider<E extends DBStudent> extends ChangeNotifier {
//   DBStudentProvider() {
//     init();
//   }
//
//   late Isar isar;
//
//   List<E> _entitys = <E>[];
//   List<E> get entitys => _entitys;
//
//   Future<void> init() async {
//     isar = await openDB(schemas: [DBTodoSchema, DBStudentSchema, ]);
//     isar.txn(() async {
//       await update();
//     });
//   }
//
//   Future<Isar> openDB({required List<CollectionSchema<dynamic>> schemas,}) async {
//     final dir = await getApplicationDocumentsDirectory();
//     final result = await Isar.open(
//       schemas,
//       directory: dir.path,
//       inspector: true,
//     );
//     return result;
//   }
//
//   /// 查
//   Future<void> update() async {
//     _entitys = await isar.collection<E>().where().findAll();
//     notifyListeners();
//   }
//
//   /// 增/改
//   Future<void> putAll(List<E> list) async {
//     await isar.writeTxn(() async {
//       await isar.collection<E>().putAll(list);
//       await update();
//     });
//   }
//   /// 增/改
//   Future<void> put(E e) async {
//     await putAll([e]);
//   }
//
//   /// 删
//   Future<void> deleteAll(List<Id> ids) async {
//     await isar.writeTxn(() async {
//       final count = await isar.collection<E>().deleteAll(ids);
//       debugPrint('$this deleted $count');
//
//       await update();
//     });
//   }
//
//   /// 删
//   Future<void> delete(Id id) async {
//     await deleteAll([id]);
//   }
//
// }