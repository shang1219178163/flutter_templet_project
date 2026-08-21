import 'dart:convert';

import 'package:flutter_templet_project/mixin/selectable_mixin.dart';

class FakeDataModel with SelectableMixin {
  String? id;
  String? name;
  String? code;
  String? createBy;

  FakeDataModel({
    required this.id,
    this.name,
    this.code,
    this.createBy,
  });

  FakeDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    createBy = json['createBy'];
    isSelected = json['isSelected'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['createBy'] = createBy;
    data['isSelected'] = isSelected;
    return data;
  }

  @override
  String get selectableId => id ?? code ?? "";

  @override
  String get selectableName => name ?? "";

  @override
  String toString() {
    final result = toJson();
    var encoder = JsonEncoder.withIndent('  '); // 使用带缩进的 JSON 编码器
    return encoder.convert(result);
  }
}
