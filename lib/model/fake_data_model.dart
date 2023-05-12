



class FakeDataModel {
  String? id;
  String? name;
  String? code;
  String? createBy;

  /// 非接口返回字段
  bool? isSelected;

  FakeDataModel({
    required this.id,
    this.name,
    this.code,
    this.createBy,
    this.isSelected = false,
  });

  FakeDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'];
    name = json['name'];
    code = json['code'];
    createBy = json['createBy'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['createBy'] = createBy;
    data['isSelected'] = isSelected;
    return data;
  }
}