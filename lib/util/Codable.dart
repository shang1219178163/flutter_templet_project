abstract class Codable {
  // factory Codable(Map<String, dynamic>? json) {
  //   throw UnimplementedError();
  // }

  // Codable.fromJson(Map<String, dynamic>? json) {
  //   throw UnimplementedError();
  // }

  factory Codable.fromJson() {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

abstract mixin class CodableMixin<T, M> {
  T fromJson(M json);
  M toJson(T object);
}

class XYZModel implements Codable {
  XYZModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
  XYZModel({
    this.id,
    this.name,
  });
  String? id;
  String? name;

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
