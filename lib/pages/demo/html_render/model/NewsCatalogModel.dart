//
//  NewsRootModel.dart
//
//  Created by JsonToModel on 2025-12-02 10:40.
//

import 'package:flutter_templet_project/basicWidget/n_tag_sort_widget.dart';
// import 'package:flutter_templet_project/pages/demo/html_render/NewsDetailModel.dart';
import 'package:flutter_templet_project/pages/demo/html_render/model/NewsDetailModel.dart';
// import 'package:social_fe_app/widget/n_tag_sort_widget.dart';

export 'NewsDetailModel.dart';

/// 新闻分类
class NewsCatalogModel with NTagSortMixin {
  NewsCatalogModel({
    this.id,
    this.names,
    this.mine,
    this.pageNum,
    this.items = const [],
    this.tagOrder = 0,
    this.tagEnable = true,
  });

  int? id;

  String? names;

  int? mine;

  // 当前分类请求页面
  int? pageNum;

  /// 当前分类资讯列表
  List<NewsDetailModel>? items;

  @override
  String get tagName => names ?? '';

  @override
  bool tagEnable = true;

  @override
  int tagOrder = 0;

  NewsCatalogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    names = json['names'];
    mine = json['mine'];
    pageNum = json['pageNum'];
    if (json['items'] != null) {
      final array = List<Map<String, dynamic>>.from(json['items'] ?? []);
      items = array.map((e) => NewsDetailModel.fromJson(e)).toList();
    }
    tagOrder = json['tagOrder'] ?? 0; // 直接读取 mixin 字段
    tagEnable = json['tagEnable'] ?? true;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['names'] = names;
    map['mine'] = mine;
    map['pageNum'] = pageNum;
    map['items'] = items?.map((v) => v.toJson()).toList();

    map['tagOrder'] = tagOrder;
    map['tagName'] = tagName;
    map['tagEnable'] = tagEnable;
    return map;
  }
}
