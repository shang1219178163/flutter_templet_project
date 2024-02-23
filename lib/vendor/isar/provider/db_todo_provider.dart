
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DBTodoProvider extends ChangeNotifier {
  DBTodoProvider() {
    db = openDB();
    init();
  }

  late Future<Isar?> db;

  List<DBTodo> _todos = <DBTodo>[];
  List<DBTodo> get todos => _todos;

  Future<void> update() async {
    final isar = await db;
    _todos = await isar!.dBTodos.where().findAll();
    notifyListeners();
  }

  Future<void> init() async {
    final isar = await db;
    isar!.txn(() async {
      await update();
    });
  }

  Future<Isar?> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return Isar.open(
        [DBTodoSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Isar.getInstance();
  }

  Future<void> putAll(List<DBTodo> list) async {
    final isar = await db;
    await isar?.writeTxn(() async {
      await isar.dBTodos.putAll(list);
      await update();
    });
  }

  Future<void> put(DBTodo e) async {
    await putAll([e]);
  }

  Future<void> deleteAll(List<DBTodo> list) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      final ids = list.map((e) => e.id).toList();
      final count = await isar.dBTodos.deleteAll(ids);
      debugPrint('$this deleted $count');

      await update();
    });
  }

  Future<void> delete(DBTodo e) async {
    await deleteAll([e]);
  }

}
