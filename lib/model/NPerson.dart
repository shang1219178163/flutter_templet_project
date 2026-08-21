import 'package:flutter/foundation.dart';

class NPerson {
  NPerson({
    required this.name,
    required this.age,
  });

  String? name;
  int? age;

  NPerson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['name'] = name;
    data['age'] = age;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    final isEqual = other is NPerson &&
        runtimeType == other.runtimeType &&
        mapEquals(toJson(), other.toJson());
    return isEqual;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;

  int get hashCode1 => Object.hash(
        name.hashCode,
        age.hashCode,
      );

  @override
  String toString() {
    return "this: ${toJson()}";
  }
}
