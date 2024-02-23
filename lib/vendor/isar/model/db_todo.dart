

import 'package:isar/isar.dart';
part 'db_todo.g.dart';

@Collection()
class DBTodo {
  Id id = Isar.autoIncrement;

  late String title;
  late bool isFinished;
  DateTime? createdDate;
  DateTime? updatedDate;
}