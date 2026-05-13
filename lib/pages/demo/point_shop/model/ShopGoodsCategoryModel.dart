//
//  ShopGoodsCategoryModel.dart
//  projects
//
//  Created by shang on 2026/4/21 18:38.
//  Copyright © 2026/4/21 shang. All rights reserved.
//

import 'package:collection/collection.dart';

import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_category_enum.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_status_enum.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/model/ShopGoodsDetailModel.dart';

/// 熊猫币礼物分类
class ShopGoodsCategoryModel {
  ShopGoodsCategoryModel({
    this.balance,
    this.categoryId,
    this.categoryName,
    this.categoryCode,
    this.goodsList,
  });

  int? balance;

  int? categoryId;

  String? categoryName;

  String? categoryCode;

  List<ShopGoodsDetailModel>? goodsList;

  GoodsCategoryEnum? get categoryEnum {
    if (categoryId == null) {
      return null;
    }
    final result = GoodsCategoryEnum.values.firstWhere((e) => e.value == categoryId || e.code == categoryCode);
    return result;
  }

  /// 已装扮
  ShopGoodsDetailModel? get equippedModel {
    final target = (goodsList ?? []).firstWhereOrNull((e) => e.goodsStatus == GoodsStatusEnum.equipped.name);
    if (target == null) {
      return null;
    }
    target.categoryCode = categoryCode;
    return target;
  }

  ShopGoodsCategoryModel.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    categoryCode = json['categoryCode'];
    if (json['goodsList'] != null) {
      final array = List<Map<String, dynamic>>.from(json['goodsList'] ?? []);
      goodsList = array.map((e) => ShopGoodsDetailModel.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['balance'] = balance;
    map['categoryId'] = categoryId;
    map['categoryName'] = categoryName;
    map['categoryCode'] = categoryCode;
    map['goodsList'] = goodsList?.map((v) => v.toJson()).toList();
    return map;
  }
}
