import 'package:flutter/material.dart';


class NewsSportItemModel {
  NewsSportItemModel({
    this.id,
    this.type,
    this.sportId,
    this.logo,
    this.names,
  });

  int? id;

  /// 数据类型(1.比赛 2.赛事 3.球队/战队 4.球员/选手)
  int? type;

  /// 运动种类id
  int? sportId;

  String? logo;

  String? names;

  /// 相关资讯.战队,球员
  void jumpSportItemDetail() {

  }

  NewsSportItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    sportId = json['sportId'];
    logo = json['logo'];
    names = json['names'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['sportId'] = sportId;
    map['logo'] = logo;
    map['names'] = names;
    return map;
  }
}
