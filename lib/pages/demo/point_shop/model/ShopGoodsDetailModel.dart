//
//  ShopGoodsDetailModel.dart
//  projects
//
//  Created by shang on 2026/4/21 18:37.
//  Copyright © 2026/4/21 shang. All rights reserved.
//

import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_status_enum.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/model/ShopGoodsGiftExtra.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_category_enum.dart';

/// 熊猫币商品详情
class ShopGoodsDetailModel {
  ShopGoodsDetailModel({
    this.categoryCode,
    this.goodsId,
    this.goodsName,
    this.price,
    this.thumbUrl,
    this.animationUrl,
    this.description,
    this.goodsStatus,
    this.isDefault,
    this.attributes,
  });

  String? categoryCode;

  int? goodsId;

  String? goodsName;

  int? price;

  String? thumbUrl;

  String? animationUrl;

  String? description;

  /// 商品状态：not_owned-未兑换 owned-已兑换未装扮 equipped-已装扮
  String? goodsStatus;

  /// 是否默认商品，默认气泡时使用：0否 1是
  int? isDefault;

  List<String>? attributes;

  /// 未购买,已购买,未装扮
  GoodsStatusEnum? get goodsStatusEnum =>
      GoodsStatusEnum.values.firstWhereOrNull((e) => goodsStatus != null && e.value == goodsStatus);

  GoodsCategoryEnum? get categoryEnum {
    if (categoryCode == null) {
      return null;
    }
    final result = GoodsCategoryEnum.values.firstWhere((e) => e.code == categoryCode);
    return result;
  }

  /// 礼物专用
  static Map<int, GoodsGiftExtra> giftMap = <int, GoodsGiftExtra>{
    100: GoodsGiftExtra(color: const Color(0xFFCE7E9E)), //送花
    101: GoodsGiftExtra(color: const Color(0xFFEA4C3F)), //金牌专家
    102: GoodsGiftExtra(color: const Color(0xFFFE6EA8)), //圈粉了
    103: GoodsGiftExtra(color: const Color(0xFFFC8E11)), //收麻了
    104: GoodsGiftExtra(color: const Color(0xFFF5604D)), //爱心
    105: GoodsGiftExtra(color: const Color(0xFF453D3B)), //小诸葛
    106: GoodsGiftExtra(color: const Color(0xFF39A9CE)), //棒棒哒
    107: GoodsGiftExtra(color: const Color(0xFFF7860E)), //爆红
    108: GoodsGiftExtra(color: const Color(0xFFF7AB1F)), //稳
    109: GoodsGiftExtra(color: const Color(0xFFE13508)), //大火锅
    110: GoodsGiftExtra(color: const Color(0xFFCC9D07)), //大啤酒
    111: GoodsGiftExtra(color: const Color(0xFF9CAD29)), //确实牛
  };

  /// 气泡和入场特效
  static Map<int, GoodsBubbleExtra> pathMap = <int, GoodsBubbleExtra>{
    // 气泡背景
    1010: GoodsBubbleExtra(path: Assets.messageBubble1, color: const Color(0xFF375514)),
    1020: GoodsBubbleExtra(path: Assets.messageBubble2, color: const Color(0xFF703710)),
    1030: GoodsBubbleExtra(path: Assets.messageBubble3, color: const Color(0xFF1A3476)),
    1031: GoodsBubbleExtra(path: Assets.messageBubble4, color: const Color(0xFF5C4514)),
    1032: GoodsBubbleExtra(path: Assets.messageBubble5, color: const Color(0xFF303030)),
    1033: GoodsBubbleExtra(path: Assets.messageBubble6, color: const Color(0xFF652E01)),
    1034: GoodsBubbleExtra(path: Assets.messageBubble7, color: const Color(0xFF4F2F02)),
    1035: GoodsBubbleExtra(path: Assets.messageBubble8, color: const Color(0xFF013D0C)),
    1036: GoodsBubbleExtra(path: Assets.messageBubble9, color: const Color(0xFF023258)),
    1037: GoodsBubbleExtra(path: Assets.messageBubble10, color: const Color(0xFF580202)),

    // 进场动画
    2000: GoodsBubbleExtra(path: Assets.messageEffectFootball, color: const Color(0xFFFFFFFF)),
    2010: GoodsBubbleExtra(path: Assets.messageEffectBasketball, color: const Color(0xFFFFFFFF)),
    2020: GoodsBubbleExtra(path: Assets.messageEffectCar, color: const Color(0xFFFFFFFF)),
    2030: GoodsBubbleExtra(path: Assets.messageEffectBeer, color: const Color(0xFFFFFFFF)),
    2040: GoodsBubbleExtra(path: Assets.messageEffectFireworks, color: const Color(0xFFFFFFFF)),
    2050: GoodsBubbleExtra(path: Assets.messageEffectFirst, color: const Color(0xFFFFFFFF)),
  };

  /// 本地气泡背景路径
  String? get bubblePath {
    final result = pathMap[goodsId]?.path;
    if (result?.isNotEmpty != true) {
      debugPrint([runtimeType, "bubblePath", goodsId, pathMap.keys.where((k) => k >= 2000)].join(", "));
    }
    return result;
  }

  /// 本地气泡文字样式
  Color? get bubbleTextColor {
    return pathMap[goodsId]?.color;
  }

  ShopGoodsDetailModel.fromJson(Map<String, dynamic> json) {
    categoryCode = json['categoryCode'];
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
    price = json['price'];
    thumbUrl = json['thumbUrl'];
    animationUrl = json['animationUrl'];
    description = json['description'];
    goodsStatus = json['goodsStatus'];
    isDefault = json['isDefault'];
    attributes = List<String>.from(json['attributes'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['categoryCode'] = categoryCode;
    map['goodsId'] = goodsId;
    map['goodsName'] = goodsName;
    map['price'] = price;
    map['thumbUrl'] = thumbUrl;
    map['animationUrl'] = animationUrl;
    map['description'] = description;
    map['goodsStatus'] = goodsStatus;
    map['isDefault'] = isDefault;
    map['attributes'] = attributes;
    return map;
  }
}
