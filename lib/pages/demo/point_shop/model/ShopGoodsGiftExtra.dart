//
//  ShopGoodsExtra.dart
//  projects
//
//  Created by shang on 2026/4/23 18:16.
//  Copyright © 2026/4/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 本地补充参数
class GoodsGiftExtra<T> {
  GoodsGiftExtra({
    required this.color,
  });

  Color color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['color'] = color;
    return map;
  }
}

/// 本地补充参数
class GoodsBubbleExtra {
  GoodsBubbleExtra({
    required this.path,
    required this.color,
  });

  String path;

  /// 文字颜色
  Color color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['path'] = path;
    map['color'] = color;
    return map;
  }
}
