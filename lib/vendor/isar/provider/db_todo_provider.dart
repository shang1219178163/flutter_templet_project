
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

  List<DBTodo> _todos = [];
  List<DBTodo> get todos => _todos;

  Future<void> init() async {
    final isar = await db;
    isar!.txn(() async {
      final todoCollection = isar.dBTodos;
      _todos = await todoCollection.where().findAll();
      notifyListeners();
    });
  }

  Future<Isar?> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      debugPrint("dir: $dir");

      return await Isar.open(
        [DBTodoSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Isar.getInstance();
  }

  Future<void> addTodo(DBTodo todo) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.dBTodos.put(todo);
      _todos.add(todo);
      notifyListeners();
    });
  }

  Future<void> toggleFinished(DBTodo todo) async {
    final isar = await db;

    isar!.writeTxn(() async {
      todo.isFinished = !todo.isFinished;
      todo.updatedDate = DateTime.now();
      await isar.dBTodos.put(todo);

      int todoIndex = _todos.indexWhere((element) => todo.id == element.id);
      _todos[todoIndex].isFinished = todo.isFinished;
      _todos[todoIndex].updatedDate = todo.updatedDate;
      notifyListeners();
    });
  }

  Future<void> deleteTodo(DBTodo todo) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.dBTodos.delete(todo.id);
      _todos.remove(todo);

      notifyListeners();
    });
  }
}