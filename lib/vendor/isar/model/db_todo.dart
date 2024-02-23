

import 'package:isar/isar.dart';
part 'db_todo.g.dart';

@Collection()
class DBTodo {
  DBTodo({
    this.id = Isar.autoIncrement,
    required this.title,
    this.isFinished = false,
    this.createdDate,
    this.updatedDate,
  });

  Id id;

  String title;
  bool isFinished;
  String? createdDate;
  String? updatedDate;


  static DBTodo? fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return DBTodo(
      title: map["title"],
      isFinished: map["isFinished"],
      createdDate: map["createdDate"],
      updatedDate: map["updatedDate"],
    );
  }

  Map<String, dynamic>toJson() {
    return {
      "id": id,
      "title": title,
      "isFinished": isFinished,
      "createdDate": createdDate,
      "updatedDate": updatedDate,
    };
  }

}


class DBBaseModel {
  DBBaseModel({
    this.id = Isar.autoIncrement,
  });

  Id id;

}
