//
//  NewsRootModel.dart
//
//  Created by JsonToModel on 2025-12-02 10:40.
//

import 'package:flutter_templet_project/basicWidget/n_tag_sort_widget.dart';

/// 新闻分类
class NewsCatalogModel with NTagSortMixin {
  NewsCatalogModel({
    this.id,
    this.name,
    this.mine,
    this.tagOrder = 0,
    this.tagEnable = true,
  });

  int? id;

  String? name;

  int? mine;

  @override
  String get tagName => name ?? '';

  @override
  bool tagEnable = true;

  @override
  int tagOrder = 0;

  NewsCatalogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mine = json['mine'];
    tagOrder = json['tagOrder'] ?? 0; // 直接读取 mixin 字段
    tagEnable = json['tagEnable'] ?? true;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['mine'] = mine;
    map['tagOrder'] = tagOrder;
    map['tagName'] = tagName;
    map['tagEnable'] = tagEnable;
    return map;
  }
}
