import 'package:isar/isar.dart';
part 'db_order.g.dart';

@Collection()
class DBOrder {
  DBOrder({
    this.id = Isar.autoIncrement,
    required this.title,
    this.isPay = false,
    this.createdDate,
    this.updatedDate,
    this.isSelected = false,
  });

  Id id;

  String title;
  bool isPay;
  String? createdDate;
  String? updatedDate;
  bool isSelected;


  static DBOrder? fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return DBOrder(
      title: map["title"],
      isPay: map["isPay"],
      createdDate: map["createdDate"],
      updatedDate: map["updatedDate"],
      isSelected: map["isSelected"],
    );
  }

  Map<String, dynamic>toJson() {
    return {
      "id": id,
      "title": title,
      "isPay": isPay,
      "createdDate": createdDate,
      "updatedDate": updatedDate,
      "isSelected": isSelected,
    };
  }

}
