//
//  TagDetailModel.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/9 10:53.
//  Copyright © 2024/4/9 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter_templet_project/mixin/selectable_mixin.dart';

class TagsRootModel {
  TagsRootModel({
    this.code,
    this.result,
    this.application,
    this.traceId,
    this.message,
    this.isSelected = false,
  });

  String? code;
  List<TagDetailModel>? result;
  String? application;
  String? traceId;
  String? message;

  /// 非接口返回字段
  bool? isSelected;

  /// 疾病组名称
  List<String> get tagNames =>
      (result ?? []).where((e) => e.name != null && e.name!.isNotEmpty).map((e) => e.name!).toList();

  TagsRootModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = <TagDetailModel>[];
      json['result'].forEach((v) {
        result!.add(TagDetailModel.fromJson(v));
      });
    }
    application = json['application'];
    traceId = json['traceId'];
    message = json['message'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['application'] = application;
    data['traceId'] = traceId;
    data['message'] = message;
    data['isSelected'] = isSelected;
    return data;
  }
}

class TagDetailModel with SelectableMixin {
  TagDetailModel({
    this.id,
    this.createTime,
    this.updateTime,
    this.name,
    this.color,
  });

  String? id;
  int? createTime;
  int? updateTime;
  String? name;
  String? color;

  TagDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['tagsId'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    name = json['name'] ?? json['tagsName'];
    color = json['color'] ?? json['tagsColor'];
    isSelected = json['isSelected'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['name'] = name;
    data['color'] = color;
    data['isSelected'] = isSelected;
    return data;
  }

  @override
  String get selectableId => id.toString();

  @override
  String get selectableName => name ?? "";

  String _formatJson(Map<String, dynamic> jsonData) {
    final encoder = JsonEncoder.withIndent('  '); // 使用带缩进的 JSON 编码器
    return encoder.convert(toJson());
  }
}
