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

class XYZModel implements Codable {
  XYZModel({
    this.id,
    this.name,
  });
  String? id;
  String? name;

  XYZModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
