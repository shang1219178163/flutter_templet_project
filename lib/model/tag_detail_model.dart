//
//  TagDetailModel.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/9 10:53.
//  Copyright © 2024/4/9 shang. All rights reserved.
//


import 'package:flutter_templet_project/mixin/selectable_mixin.dart';

class TagDetailModel with SelectableMixin{
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


  // @override
  // bool isSelected = true;

  TagDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'] ?? json['tagsId'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    name = json['name'] ?? json['tagsName'];
    color = json['color'] ?? json['tagsColor'];
    isSelected = json['isSelected'];
  }

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
}