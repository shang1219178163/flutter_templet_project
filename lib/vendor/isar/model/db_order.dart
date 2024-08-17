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
    this.user,
  });

  Id id;

  String title;
  @ignore
  bool isPay;
  String? createdDate;
  String? updatedDate;
  bool isSelected;

  User? user;

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
        user: User.fromJson(map["user"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "isPay": isPay,
      "createdDate": createdDate,
      "updatedDate": updatedDate,
      "isSelected": isSelected,
      "user": user?.toJson(),
    };
  }
}

@embedded
class User {
  User({
    required this.name,
    this.isSelected = false,
  });

  String name;
  bool isSelected;

  static User? fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return User(
      name: map["title"],
      isSelected: map["isSelected"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "isSelected": isSelected,
    };
  }
}
