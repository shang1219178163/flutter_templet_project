class RootModel<T extends Coding> {
  RootModel({
    this.code,
    this.result,
    this.application,
    this.traceId,
    this.message,
  });

  String? code;
  T? result;

  String? application;
  String? traceId;
  String? message;

  RootModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    final dynamic resultValue = json['result'];
    if (resultValue is String || resultValue is bool || resultValue is int || resultValue is double) {
      result = resultValue as T?;
    }
    application = json['application'];
    traceId = json['traceId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;

    data['application'] = application;
    data['traceId'] = traceId;
    data['message'] = message;
    return data;
  }
}

interface class Coding {
  // factory Codable(Map<String, dynamic> json) {
  //   throw UnimplementedError();
  // }

  factory Coding.fromJson() {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
