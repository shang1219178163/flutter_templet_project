/// api 属性
class ApiPropertyModel<T> {
  ApiPropertyModel({
    this.name = "unknown",
    this.type = "unknown",
    this.typeDart = "unknown",
    this.typeValidate = "",
    this.format,
    this.description,
    this.result,
  });

  String name;
  String type;
  String typeDart;
  String? typeValidate;

  /// int32/int64
  String? format;
  String? description;
  T? result;

  factory ApiPropertyModel.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJsonT,
  }) {
    return ApiPropertyModel<T>(
      name: json['name'] ?? "unknown",
      type: json['type'] ?? "unknown",
      typeDart: json['typeDart'] ?? "unknown",
      typeValidate: json['typeValidate'] ?? "",
      format: json['format'],
      description: json['description'],
      result: fromJsonT?.call(json['result']),
    );
  }

  Map<String, dynamic> toJson({
    dynamic Function(T value)? toJsonT,
  }) {
    return {
      'name': name,
      'type': type,
      'typeDart': typeDart,
      'typeValidate': typeValidate,
      'format': format,
      'description': description,
      'result': result == null ? null : toJsonT?.call(result as T),
    };
  }
}
