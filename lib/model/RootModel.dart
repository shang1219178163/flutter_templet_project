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

    switch (result) {
      case String:
      case bool:
      case int:
      case double:
        {
          result = json['result'] as T?;
        }
        break;
      case List:
        {}
        break;
      case Map:
        {}
        break;
      default:
        break;
    }
    // result = json['result'] != null ? DoctorListResultModel.fromJson(json['result']) : null;

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
