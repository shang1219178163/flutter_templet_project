//
//  PandaCoinGoodsRootModel.dart
//
//  Created by JsonToModel on 2026-03-09 11:00.
//

import 'package:flutter_templet_project/pages/demo/point_shop/model/ShopGoodsCategoryModel.dart';

export 'ShopGoodsCategoryModel.dart';
export 'ShopGoodsDetailModel.dart';

/// 熊猫币全部礼物
class ShopGoodsRootModel {
  ShopGoodsRootModel({
    this.code,
    this.msg,
    this.data,
  });

  int? code;

  String? msg;

  ShopGoodsDataModel? data;

  ShopGoodsRootModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? ShopGoodsDataModel.fromJson(json['data'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class ShopGoodsDataModel {
  ShopGoodsDataModel({
    this.balance,
    this.goodsList,
  });

  int? balance;

  List<ShopGoodsCategoryModel>? goodsList;

  ShopGoodsDataModel.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    final goodsListValue = json['goodsList'] ?? json['categoryGoodsList'];
    if (goodsListValue != null) {
      final array = List<Map<String, dynamic>>.from(goodsListValue ?? []);
      goodsList = array.map((e) => ShopGoodsCategoryModel.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['balance'] = balance;
    map['goodsList'] = goodsList?.map((v) => v.toJson()).toList();
    return map;
  }
}
