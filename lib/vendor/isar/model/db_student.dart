import 'package:isar/isar.dart';
part 'db_student.g.dart';

@Collection()
class DBStudent {
  DBStudent({
    this.id = Isar.autoIncrement,
    required this.name,
    this.isMale = false,
    this.createdDate,
    this.updatedDate,
    this.isSelected = false,
  });

  Id id;

  String name;
  bool isMale;
  String? createdDate;
  String? updatedDate;
  bool isSelected;

  static DBStudent? fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return DBStudent(
      name: map["name"],
      isMale: map["isMale"],
      createdDate: map["createdDate"],
      updatedDate: map["updatedDate"],
      isSelected: map["isSelected"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "isMale": isMale,
      "createdDate": createdDate,
      "updatedDate": updatedDate,
      "isSelected": isSelected,
    };
  }
}
